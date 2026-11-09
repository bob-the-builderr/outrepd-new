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
    'live_matches', coalesce((
      select jsonb_agg(to_jsonb(m) order by m.created_at)
        from live_matches m where m.a = auth.uid() or m.b = auth.uid()
    ), '[]'::jsonb),
    'month_awards', coalesce((
      select jsonb_agg(to_jsonb(w) - 'profile_id' order by w.season)
        from season_awards w where w.profile_id = auth.uid()
    ), '[]'::jsonb),
    'adventure_stars', (
      select to_jsonb(a.stars)
        from adventure_progress a where a.profile_id = auth.uid()
    ),
    'rewards', (
      select r.state from rewards_progress r where r.profile_id = auth.uid()
    ),
    'challenges', coalesce((
      select jsonb_agg(to_jsonb(c) - 'owner' order by c.created_at)
        from challenges c where c.owner = auth.uid()
    ), '[]'::jsonb),
    'challenges_taken', coalesce((
      select jsonb_agg(jsonb_build_object(
               'code', c.code, 'reps', t.reps, 'at', t.created_at)
               order by t.created_at)
        from challenge_takes t join challenges c on c.id = t.challenge_id
       where t.taker = auth.uid()
    ), '[]'::jsonb),
    'training_plan', (
      select t.plan from training_plans t where t.profile_id = auth.uid()
    ),
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
set search_path = public
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
-- Once the email is confirmed, a name can be changed again fourteen days after
-- it was last chosen (username_changed_at): often enough to fix a name somebody
-- regrets, not so often that nobody on a board knows who anybody is. The app
-- reads the same column to say on which day. Re-checks availability itself —
-- the gap between the screen's own check and this call is exactly long enough
-- for somebody else to take it.
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
     where id = auth.uid()
       and username_changed_at > now() - interval '14 days'
  ) then
    return 'already_changed';
  end if;

  -- Free as a guest, but not endless: renaming in a loop is holding names.
  if not within_rate('rename', interval '1 hour', 30) then
    return 'too_often';
  end if;

  -- Letters, numbers and underscores, the way a handle is usually written
  -- (iron_mike), with at least one letter or number among them. The same
  -- characters the guard on a new profile has always allowed; this was the
  -- one place that left the underscore out.
  if char_length(cleaned) < 4 or char_length(cleaned) > 20
     or cleaned !~ '^[A-Za-z0-9_]+$'
     or cleaned !~ '[A-Za-z0-9]' then
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

-- The country this lifter chooses, by its two-letter code. Free while the
-- account is a guest, as the name is; once it has a confirmed email, once
-- every fourteen days, for the same reason as the name — the country board
-- is one a lifter could hop between to sit on top of a small one.
create or replace function set_my_country(new_country text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  code text := upper(trim(coalesce(new_country, '')));
  confirmed boolean;
begin
  if auth.uid() is null or code !~ '^[A-Z]{2}$' then
    return 'invalid';
  end if;

  select coalesce(u.email, '') <> '' and u.email_confirmed_at is not null
    into confirmed
    from auth.users u where u.id = auth.uid();

  if coalesce(confirmed, false) and exists (
    select 1 from profiles
     where id = auth.uid()
       and country_changed_at > now() - interval '14 days'
  ) then
    return 'too_soon';
  end if;

  if not within_rate('country', interval '1 hour', 30) then
    return 'too_often';
  end if;

  -- The guard on profiles refuses a country written any other way. The
  -- fourteen days start from a choice made with a confirmed account, so a
  -- guest who picks one on the way to signing up can still fix it after.
  perform set_config('outrepd.recountry', 'on', true);
  update profiles
     set country = code,
         country_changed_at = case
           when coalesce(confirmed, false) then now()
           else country_changed_at
         end
   where id = auth.uid();
  perform set_config('outrepd.recountry', 'off', true);
  return 'ok';
end;
$$;

revoke all on function set_my_country(text) from public, anon;
grant execute on function set_my_country(text) to authenticated;

-- ─────────────────────────────── the days ───────────────────────────────────
--
-- This lifter's push-ups day by day, every set they uploaded — ranked, live,
-- a friend's, practice, the adventure — summed in their own days:
-- [tz_minutes] is their clock's offset from UTC. For a phone that has not
-- kept them: a new one, or the same one signed out and back in, which
-- started its week, its streak and today's goal from nothing (2026-10-29).
create or replace function my_days(tz_minutes int default 0, last_days int default 60)
returns table (day date, reps int)
language sql
stable
security definer
set search_path = public
as $$
  select ((s.created_at at time zone 'UTC')
            + make_interval(mins => greatest(-840, least(840, tz_minutes))))::date,
         sum(s.reps)::int
    from sets s
   where s.profile_id = auth.uid()
     and s.created_at > now()
           - make_interval(days => greatest(1, least(400, last_days)))
   group by 1
   order by 1;
$$;

revoke all on function my_days(int, int) from public, anon;
grant execute on function my_days(int, int) to authenticated;

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

-- How the people on a screen look: whether each is Pro, the lifter they
-- made, and their cover — for the boards' holo rows, the VS screen before a
-- live match, and a profile's cover. Asked for the ids a screen already has,
-- at most two hundred. Pro is the subscription itself, not has_pro(), which
-- lets everybody play while the app is free. A cover shows only while its
-- account is Pro.
create or replace function pro_looks(ids uuid[])
returns table (id uuid, pro boolean, lifter jsonb, cover text)
language sql
stable
security definer
set search_path = public
as $$
  -- A Pro part worn for a day comes off for everybody once the day is
  -- over (rewarded.sql, lifter_as_seen).
  select p.id, x.pro, lifter_as_seen(p.lifter, p.pro_trial, x.pro),
         case when x.pro then p.cover end
  from profiles p
  cross join lateral (
    select exists (
      select 1
      from subscriptions s
      where s.user_id = p.id
        and s.active
        and (s.expires_at is null or s.expires_at > now() - interval '1 hour')
    ) as pro
  ) x
  where p.id = any (ids[1:200])
$$;

revoke all on function pro_looks(uuid[]) from public, anon;
grant execute on function pro_looks(uuid[]) to authenticated;
