-- OUTREPD — a challenge by link (the user's pick, 2026-11-09).
--
-- One set, sent anywhere as outrepd.com/c/<code>: whoever opens it races that
-- minute, the same way a saved set is raced, and the sender hears how it
-- went. It is how somebody who has never heard of the app ends up in it — a
-- friend dared them — so it has to work for anybody who has the link, not
-- only friends or past opponents the way a rematch does.
--
-- Friendly, every part of it. No duel is written and no rank, record or week
-- point moves: a challenge anybody can be sent is a challenge anybody can
-- arrange with a second account, and the ladder already has its own rules
-- for who may meet whom (duel.sql). The sets themselves are ordinary sets, so
-- the push-ups count toward the day the way any set's do.
--
-- Many people can take one challenge — a whole group chat — so it cannot be
-- built on `claimed_by`, which lets a set be faced once. Each person gets one
-- try, and the challenge is open for seven days.
--
-- Nothing here is readable straight from the tables. Every read and write is
-- one of the functions below, which take the caller from auth.uid() and treat
-- everything else they are handed as hostile.

create table if not exists challenges (
  id          uuid primary key default gen_random_uuid(),
  -- What the link carries. Six letters and digits with the ones that are
  -- easy to misread left out (no i, l, o, 0 or 1): short enough to say out
  -- loud, and about nine hundred million of them.
  code        text not null unique check (code ~ '^[2-9a-hjkmnp-z]{6}$'),
  -- The minute being raced. One challenge per set: sending the same set
  -- twice sends the same link.
  set_id      uuid not null unique references sets on delete cascade,
  owner       uuid not null references profiles on delete cascade,
  -- Copied from the set, so the board never has to read it again.
  reps        int  not null check (reps between 1 and 300),
  created_at  timestamptz not null default now(),
  expires_at  timestamptz not null default now() + interval '7 days'
);

create index if not exists challenges_owner_idx
  on challenges (owner, created_at desc);

alter table challenges enable row level security;

create table if not exists challenge_takes (
  id            uuid primary key default gen_random_uuid(),
  challenge_id  uuid not null references challenges on delete cascade,
  taker         uuid not null references profiles on delete cascade,
  -- The taker's own minute, which is what "take it back" races.
  set_id        uuid not null unique references sets on delete cascade,
  reps          int  not null check (reps between 0 and 300),
  created_at    timestamptz not null default now(),
  -- When the taker sent it back to the owner, so they are told once.
  backed_at     timestamptz,
  -- One try each.
  unique (challenge_id, taker)
);

create index if not exists challenge_takes_taker_idx
  on challenge_takes (taker);

alter table challenge_takes enable row level security;

-- ─────────────────────────────── the pieces ──────────────────────────────────

-- A fresh code. The randomness is gen_random_uuid()'s, which is the server's
-- strong generator, rather than random()'s.
create or replace function challenge_new_code()
returns text
language plpgsql
volatile
set search_path = public
as $$
declare
  alphabet constant text := '23456789abcdefghjkmnpqrstuvwxyz';
  raw bytea := decode(replace(gen_random_uuid()::text, '-', ''), 'hex');
  made text := '';
begin
  for i in 0..5 loop
    made := made || substr(alphabet, 1 + get_byte(raw, i) % 31, 1);
  end loop;
  return made;
end;
$$;

-- Whether a set can be sent as a challenge: a whole minute, lifted to the
-- end, with the times of its reps — the number on the card is "in 60
-- seconds", and the bar the taker races moves at those times.
create or replace function challenge_set_ok(s sets)
returns boolean
language sql
immutable
set search_path = public
as $$
  select s.id is not null
     and not s.gave_up
     and s.reps between 1 and 300
     and s.duration_ms between 55000 and 61500
     and coalesce(array_length(s.rep_times, 1), 0) > 0;
$$;

-- Whether two accounts are kept apart, whichever of them did the blocking.
create or replace function challenge_blocked(one uuid, other uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from blocks b
     where (b.blocker = one and b.blocked = other)
        or (b.blocker = other and b.blocked = one)
  );
$$;

-- The challenge on [s], made if there is none and opened again for seven
-- days if it has closed. Owned by whoever lifted the set. The rate limit
-- counts the caller, who is the one asking for links to be made.
create or replace function challenge_for_set(s sets)
returns challenges
language plpgsql
security definer
set search_path = public
as $$
declare
  made challenges;
begin
  select * into made from challenges where set_id = s.id;
  if made.id is not null then
    if made.expires_at <= now() then
      update challenges set expires_at = now() + interval '7 days'
       where id = made.id
      returning * into made;
    end if;
    return made;
  end if;

  if not within_rate('challenge_make', interval '1 hour', 20) then
    raise exception 'that is enough challenges for now';
  end if;

  for attempt in 1..6 loop
    begin
      insert into challenges (code, set_id, owner, reps)
      values (challenge_new_code(), s.id, s.profile_id, s.reps)
      returning * into made;
      return made;
    exception when unique_violation then
      -- Another link took the same code, or the same set, at the same time.
      select * into made from challenges where set_id = s.id;
      if made.id is not null then
        return made;
      end if;
    end;
  end loop;
  raise exception 'could not make a code';
end;
$$;

-- Everybody on a challenge, best first: the owner, who set it, and each
-- taker. Nobody the viewer is blocked with either way, and nobody who is
-- blocked with the owner.
create or replace function challenge_board(c challenges, viewer uuid)
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(jsonb_agg(to_jsonb(b) order by b.reps desc, b.at), '[]'::jsonb)
    from (
      select null::uuid as take_id, p.id, p.username, p.avatar_url,
             c.reps, c.created_at as at, true as owner, false as beat,
             false as can_back
        from profiles p
       where p.id = c.owner
      union all
      select * from (
        select t.id as take_id, p.id as pid, p.username, p.avatar_url,
               t.reps, t.created_at, false, t.reps > c.reps,
               challenge_set_ok(s)
          from challenge_takes t
          join profiles p on p.id = t.taker
          join sets s on s.id = t.set_id
         where t.challenge_id = c.id
           and not challenge_blocked(viewer, t.taker)
           and not challenge_blocked(c.owner, t.taker)
         order by t.reps desc, t.created_at
         limit 50
      ) takes
    ) b;
$$;

-- A challenge as the app draws it, for [viewer].
create or replace function challenge_view(c challenges, viewer uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  who profiles;
  s sets;
  mine challenge_takes;
begin
  select * into who from profiles where id = c.owner;
  select * into s from sets where id = c.set_id;
  select * into mine from challenge_takes
   where challenge_id = c.id and taker = viewer;
  return jsonb_build_object(
    'code', c.code,
    'reps', c.reps,
    'rep_times', to_jsonb(coalesce(s.rep_times, '{}')),
    'created_at', c.created_at,
    'expires_at', c.expires_at,
    'open', c.expires_at > now(),
    'mine', c.owner = viewer,
    'taken', mine.reps,
    'take_id', mine.id,
    'owner', jsonb_build_object(
      'id', who.id,
      'username', who.username,
      'avatar_url', who.avatar_url,
      'tier_idx', who.tier_idx,
      'div_idx', who.div_idx,
      'xp', who.xp
    ),
    'board', challenge_board(c, viewer)
  );
end;
$$;

-- ─────────────────────────────── what a phone calls ──────────────────────────

-- A link for one of the caller's own sets: [of_set], or, when null, the
-- latest one that can be sent, from the last day — the set just lifted,
-- whichever kind of match it was. Null when there is none.
create or replace function make_challenge(of_set uuid default null)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
  s sets;
  made challenges;
begin
  if me is null then
    raise exception 'not signed in';
  end if;
  if of_set is null then
    select * into s from sets
     where profile_id = me
       and created_at > now() - interval '1 day'
       and challenge_set_ok(sets)
     order by created_at desc
     limit 1;
  else
    select * into s from sets where id = of_set and profile_id = me;
  end if;
  if not coalesce(challenge_set_ok(s), false) then
    return null;
  end if;
  made := challenge_for_set(s);
  return jsonb_build_object('code', made.code, 'reps', made.reps,
                            'expires_at', made.expires_at);
end;
$$;

-- A link for the caller's best minute ever, for the home screen's card.
create or replace function challenge_best()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
  s sets;
  made challenges;
begin
  if me is null then
    raise exception 'not signed in';
  end if;
  select * into s from sets
   where profile_id = me and challenge_set_ok(sets)
   order by reps desc, created_at desc
   limit 1;
  if s.id is null then
    return null;
  end if;
  made := challenge_for_set(s);
  return jsonb_build_object('code', made.code, 'reps', made.reps,
                            'expires_at', made.expires_at);
end;
$$;

-- What a link opens: whose it is, the minute to race, and everybody who has
-- taken it. Null for a code that does not exist, or one between two people
-- who are blocked — not said which, as a block is not announced. A closed
-- challenge still opens, so its board can be seen; it says it is closed.
create or replace function open_challenge(of_code text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
  c challenges;
begin
  if me is null then
    raise exception 'not signed in';
  end if;
  -- Codes are not secrets, but trying all of them should not be free.
  if not within_rate('challenge_open', interval '1 hour', 300) then
    raise exception 'too many challenges opened';
  end if;
  select * into c from challenges where code = lower(trim(of_code));
  if c.id is null or challenge_blocked(me, c.owner) then
    return null;
  end if;
  return challenge_view(c, me);
end;
$$;

-- The caller's try at a challenge, with the set they just lifted for it.
--
-- The set must be the caller's own, lifted after the challenge was made and
-- within the last fifteen minutes, and not already used for another try:
-- anything older is a set chosen afterwards rather than one lifted against
-- this. One try each; none at your own challenge, a closed one, or one
-- between blocked accounts. Writes the try and tells the owner, and touches
-- nothing else: no duel, no rank, no week points.
create or replace function take_challenge(of_code text, my_set uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
  c challenges;
  s sets;
  took challenge_takes;
  my_name text;
begin
  if me is null then
    raise exception 'not signed in';
  end if;
  -- Only a subscriber plays (see subscriptions.sql; off until switched on).
  perform require_pro();

  select * into c from challenges where code = lower(trim(of_code));
  if c.id is null or challenge_blocked(me, c.owner) then
    raise exception 'no such challenge';
  end if;
  if c.expires_at <= now() then
    raise exception 'that challenge has closed';
  end if;
  if c.owner = me then
    raise exception 'that is your own challenge';
  end if;

  select * into s from sets where id = my_set and profile_id = me;
  if s.id is null then
    raise exception 'not your set';
  end if;
  if s.created_at < c.created_at or s.created_at < now() - interval '15 minutes' then
    raise exception 'that set was not lifted for this challenge';
  end if;
  if exists (select 1 from challenge_takes t where t.set_id = s.id) then
    raise exception 'that set has been used already';
  end if;
  if exists (select 1 from challenge_takes t
              where t.challenge_id = c.id and t.taker = me) then
    raise exception 'one try each';
  end if;
  if not within_rate('challenge_take', interval '1 hour', 30) then
    raise exception 'that is enough challenges for now';
  end if;

  insert into challenge_takes (challenge_id, taker, set_id, reps)
  values (c.id, me, s.id, s.reps)
  returning * into took;

  -- The owner hears how it went, unless they asked not to hear about
  -- challenges, and at most twenty times a day, however big the group.
  if exists (select 1 from profiles where id = c.owner and notify_challenged)
     and (select count(*) from notifications n
           where n.profile_id = c.owner and n.kind = 'challenge_taken'
             and n.created_at > now() - interval '1 day') < 20 then
    select username into my_name from profiles where id = me;
    insert into notifications (profile_id, kind, actor, actor_name, you_won,
                               your_reps, their_reps, challenge_code)
    values (c.owner, 'challenge_taken', me, coalesce(my_name, ''),
            c.reps >= took.reps, c.reps, took.reps, c.code);
  end if;

  return challenge_view(c, me);
end;
$$;

-- A challenge on one try's set, the other way round.
--
-- Called by the one who took it: "challenge them back" — the owner is told,
-- once. Called by the owner: "take it back" — the link to race the set that
-- took theirs. Either way the challenge belongs to whoever lifted the set.
-- Null when the try is not between the caller and somebody else, the two are
-- blocked, or the set cannot be sent (given up, or not a whole minute).
create or replace function back_challenge(of_take uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
  took challenge_takes;
  c challenges;
  s sets;
  made challenges;
  my_name text;
begin
  if me is null then
    raise exception 'not signed in';
  end if;
  select * into took from challenge_takes where id = of_take;
  if took.id is null then
    return null;
  end if;
  select * into c from challenges where id = took.challenge_id;
  if me <> took.taker and me <> c.owner then
    return null;
  end if;
  if challenge_blocked(took.taker, c.owner) then
    return null;
  end if;
  select * into s from sets where id = took.set_id;
  if not coalesce(challenge_set_ok(s), false) then
    return null;
  end if;

  made := challenge_for_set(s);

  if me = took.taker and took.backed_at is null then
    update challenge_takes set backed_at = now() where id = took.id;
    if exists (select 1 from profiles where id = c.owner and notify_challenged) then
      select username into my_name from profiles where id = me;
      insert into notifications (profile_id, kind, actor, actor_name,
                                 your_reps, their_reps, challenge_code)
      values (c.owner, 'challenge_back', me, coalesce(my_name, ''),
              c.reps, took.reps, made.code);
    end if;
  end if;

  return jsonb_build_object('code', made.code, 'reps', made.reps,
                            'expires_at', made.expires_at);
end;
$$;

-- The caller's own challenges from the last month, newest first, each with
-- how many took it and how many beat it.
create or replace function my_challenges()
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
begin
  if me is null then
    raise exception 'not signed in';
  end if;
  return coalesce((
    select jsonb_agg(item order by item->>'created_at' desc)
      from (
        select jsonb_build_object(
                 'code', c.code,
                 'reps', c.reps,
                 'created_at', c.created_at,
                 'expires_at', c.expires_at,
                 'open', c.expires_at > now(),
                 'takes', (select count(*) from challenge_takes t
                            where t.challenge_id = c.id
                              and not challenge_blocked(me, t.taker)),
                 'beat', (select count(*) from challenge_takes t
                           where t.challenge_id = c.id and t.reps > c.reps
                             and not challenge_blocked(me, t.taker))
               ) as item
          from challenges c
         where c.owner = me and c.created_at > now() - interval '30 days'
         order by c.created_at desc
         limit 30
      ) mine
  ), '[]'::jsonb);
end;
$$;

-- What the website's /c/<code> page shows, for whoever a link reaches: who
-- sent it, the number, and how many have taken it. Signed out, like
-- public_lifter_card, and as narrow: nothing about who took it.
create or replace function public_challenge_card(of_code text)
returns table (
  username text,
  avatar_url text,
  reps int,
  expires_at timestamptz,
  is_open boolean,
  takes int
)
language sql
stable
security definer
set search_path = public
as $$
  select p.username, p.avatar_url, c.reps, c.expires_at, c.expires_at > now(),
         (select count(*)::int from challenge_takes t where t.challenge_id = c.id)
    from challenges c
    join profiles p on p.id = c.owner
   where c.code = lower(trim(of_code));
$$;

revoke all on function challenge_new_code() from public, anon, authenticated;
revoke all on function challenge_set_ok(sets) from public, anon, authenticated;
revoke all on function challenge_blocked(uuid, uuid) from public, anon, authenticated;
revoke all on function challenge_for_set(sets) from public, anon, authenticated;
revoke all on function challenge_board(challenges, uuid) from public, anon, authenticated;
revoke all on function challenge_view(challenges, uuid) from public, anon, authenticated;
revoke all on function make_challenge(uuid) from public;
grant execute on function make_challenge(uuid) to authenticated;
revoke all on function challenge_best() from public;
grant execute on function challenge_best() to authenticated;
revoke all on function open_challenge(text) from public;
grant execute on function open_challenge(text) to authenticated;
revoke all on function take_challenge(text, uuid) from public;
grant execute on function take_challenge(text, uuid) to authenticated;
revoke all on function back_challenge(uuid) from public;
grant execute on function back_challenge(uuid) to authenticated;
revoke all on function my_challenges() from public;
grant execute on function my_challenges() to authenticated;
revoke all on function public_challenge_card(text) from public;
grant execute on function public_challenge_card(text) to anon, authenticated;
