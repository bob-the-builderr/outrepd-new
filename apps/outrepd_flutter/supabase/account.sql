-- OUTREPD — the two things a person is entitled to do with their account.
--
-- Take everything with them, and leave.
--
-- Both are irreversible and both are theirs alone: every query below is
-- scoped by `auth.uid()` and nothing takes an account id as an argument,
-- because a function that deletes the account you name is a function that
-- deletes anybody's.

-- Everything the server holds about the caller, in one object.
--
-- Read here rather than assembled on the phone so the answer is the
-- database's own, and so the export and the delete agree about what "your
-- data" means — the same tables appear in both.
--
-- What is *not* in here is as much the point as what is. There are no pose
-- landmarks and no video: pose detection runs on the phone and the frames
-- never leave it, so there is nothing on any server to hand back.
-- Security definer: a friend's or a blocked account's name is read off a
-- profile the caller cannot read directly. Every part is scoped to auth.uid().
create or replace function my_data()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'exported_at', now(),
    'profile', (
      select to_jsonb(p) - 'id' from profiles p where p.id = auth.uid()
    ),
    'sets', coalesce((
      select jsonb_agg(to_jsonb(s) - 'profile_id' order by s.created_at)
        from sets s where s.profile_id = auth.uid()
    ), '[]'::jsonb),
    'duels', coalesce((
      select jsonb_agg(to_jsonb(d) order by d.created_at)
        from duels d
       where d.challenger = auth.uid() or d.defender = auth.uid()
    ), '[]'::jsonb),
    'friends', coalesce((
      select jsonb_agg(jsonb_build_object(
               'username', p.username,
               'since', f.accepted_at,
               'you_asked', f.requester = auth.uid()))
        from friendships f
        join profiles p
          on p.id = case when f.requester = auth.uid()
                         then f.addressee else f.requester end
       where f.requester = auth.uid() or f.addressee = auth.uid()
    ), '[]'::jsonb),
    'blocked', coalesce((
      select jsonb_agg(jsonb_build_object(
               'username', p.username, 'at', b.created_at))
        from blocks b join profiles p on p.id = b.blocked
       where b.blocker = auth.uid()
    ), '[]'::jsonb),
    'notifications', coalesce((
      select jsonb_agg(to_jsonb(n) - 'profile_id' order by n.created_at)
        from notifications n where n.profile_id = auth.uid()
    ), '[]'::jsonb),
    'reports_filed', coalesce((
      select count(*) from reports r where r.reporter = auth.uid()
    ), 0)
  );
$$;

-- Whether the export may be emailed once more today. Asked by the
-- email-my-data function, with the caller's own sign-in, before it sends:
-- three a day is plenty for anybody's own copy, and the function's sender is
-- this project's, which mail services judge by how much it sends.
create or replace function claim_data_export()
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  return within_rate('data_export', interval '1 day', 3);
end;
$$;

-- What is about to be lost, for the screen that asks whether you are sure.
--
-- The same numbers the profile shows, fetched again rather than passed in:
-- a confirmation screen quoting figures the client supplied is a
-- confirmation of whatever the client felt like saying.
create or replace function my_account_summary()
returns table (
  tier_idx int,
  div_idx int,
  lp int,
  placements_done int,
  total_reps int,
  best_set int,
  friends int
)
language sql
stable
as $$
  select p.tier_idx, p.div_idx, p.lp, p.placements_done,
         p.total_reps, p.best_set,
         (select count(*)::int from friendships f
           where f.accepted_at is not null
             and (f.requester = p.id or f.addressee = p.id))
    from profiles p
   where p.id = auth.uid();
$$;

-- Delete this account and everything hanging off it.
--
-- One statement: `profiles` cascades from `auth.users`, and sets, duels,
-- friendships, blocks and notifications all cascade from `profiles`. Deleting
-- the auth user is therefore the whole of it, and doing it in one place means
-- there is no list of tables to keep in step with the schema.
--
-- Duels go too: `duels.challenger` and `duels.defender` cascade, so the
-- opponent loses the row from their history. The LP it paid them stays, since
-- that lives on their own profile.
create or replace function delete_my_account()
returns void
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  if auth.uid() is null then
    raise exception 'not signed in';
  end if;
  delete from auth.users where id = auth.uid();
end;
$$;

-- ─────────────────────────────── renaming ─────────────────────────────────────

-- Whether a name is free, checked before the rename screen shows it as such.
-- Case-insensitive: "Mokhtar" and "mokhtar" reading as different accounts
-- would be a bug nobody could explain.
create or replace function username_available(name text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select not exists (
    select 1 from profiles where lower(username) = lower(trim(name))
  );
$$;

-- Renames this account.
--
-- As a guest — no confirmed email yet — as often as it likes. The name is
-- chosen on the sign-up screen, before the code has been typed, and somebody
-- who goes back to fix a typo, or because their email was already taken,
-- has to be able to choose again: when the first try counted as the one
-- rename, the second was quietly refused and the account kept a name its
-- owner had already changed their mind about.
--
-- Once the email is confirmed the name is final if one was ever chosen
-- (username_changed_at is set), and an account that never chose one gets a
-- single rename. Re-checks availability itself — the gap between the
-- screen's own check and this call is exactly long enough for somebody else
-- to take it.
--
-- Letters and digits only, four characters minimum. A tag another lifter
-- reads off a leaderboard or types into a search box, not a display name —
-- no spaces or punctuation to type around, no length short enough to be
-- somebody else by accident.
--
-- Security definer: whether a name is taken means looking at everybody's,
-- and a lifter can only read their own row; and whether the email is
-- confirmed is in auth.users. It writes only the caller's row.
create or replace function set_my_username(new_name text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  cleaned text := trim(new_name);
  confirmed boolean;
begin
  if auth.uid() is null then
    return 'invalid';
  end if;

  select coalesce(u.email, '') <> '' and u.email_confirmed_at is not null
    into confirmed
    from auth.users u where u.id = auth.uid();

  if coalesce(confirmed, false) and exists (
    select 1 from profiles
     where id = auth.uid() and username_changed_at is not null
  ) then
    return 'already_changed';
  end if;

  -- Free as a guest, but not endless: renaming in a loop is holding names.
  if not within_rate('rename', interval '1 hour', 30) then
    return 'too_often';
  end if;

  if char_length(cleaned) < 4 or char_length(cleaned) > 20
     or cleaned !~ '^[A-Za-z0-9]+$' then
    return 'invalid';
  end if;

  if username_not_allowed(cleaned) then
    return 'not_allowed';
  end if;

  if exists (
    select 1 from profiles
     where lower(username) = lower(cleaned) and id <> auth.uid()
  ) then
    return 'taken';
  end if;

  -- The profiles guard refuses a username written any other way.
  perform set_config('outrepd.renaming', 'on', true);
  update profiles
     set username = cleaned, username_changed_at = now()
   where id = auth.uid();
  perform set_config('outrepd.renaming', 'off', true);
  return 'ok';
end;
$$;

revoke all on function my_data() from public;
grant execute on function my_data() to authenticated;
revoke all on function claim_data_export() from public, anon;
grant execute on function claim_data_export() to authenticated;
revoke all on function my_account_summary() from public;
grant execute on function my_account_summary() to authenticated;
revoke all on function delete_my_account() from public;
grant execute on function delete_my_account() to authenticated;
revoke all on function username_available(text) from public;
grant execute on function username_available(text) to authenticated;
revoke all on function set_my_username(text) from public;
grant execute on function set_my_username(text) to authenticated;
