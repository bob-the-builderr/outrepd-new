-- ─────────────────────────────── adventure ────────────────────────────────────
--
-- The adventure's progress on the account: the best stars won on each of its
-- hundred and forty levels, so a new phone or a reinstall picks up where the
-- last one left off.
--
-- Nothing anybody else sees depends on it — no board, no rank — so the server
-- does not referee the stars; it only keeps them, and never lets one phone
-- take stars off another: a save keeps the best of what was held and what was
-- sent, level by level.

create table if not exists adventure_progress (
  profile_id uuid primary key references profiles on delete cascade,
  -- One per level from the first, 0 to 3; 0 is a level not won.
  stars      smallint[] not null default '{}',
  updated_at timestamptz not null default now(),
  constraint adventure_progress_levels check (cardinality(stars) <= 140)
);

-- Row level security and no policy at all: the two functions below are the
-- only way in, for reading and for writing.
alter table adventure_progress enable row level security;

-- This account's stars, or none.
create or replace function my_adventure()
returns smallint[]
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select stars from adventure_progress where profile_id = auth.uid()),
    '{}'::smallint[]
  );
$$;

-- Saves [new_stars] onto this account, the best of them and what it already
-- held on every level, and hands back what it now holds.
create or replace function save_adventure(new_stars smallint[])
returns smallint[]
language plpgsql
security definer
set search_path = public
as $$
declare
  held smallint[];
  merged smallint[] := '{}';
  levels int;
begin
  if auth.uid() is null then
    raise exception 'not signed in';
  end if;
  if new_stars is null or cardinality(new_stars) > 140 then
    raise exception 'not an adventure';
  end if;
  -- A save follows a won fight, a minute each at most; a phone sending more
  -- than this is not a phone lifting.
  if not within_rate('adventure', interval '1 hour', 240) then
    raise exception 'too often';
  end if;

  select stars into held
    from adventure_progress
   where profile_id = auth.uid()
     for update;
  held := coalesce(held, '{}');

  levels := greatest(cardinality(held), cardinality(new_stars));
  for i in 1 .. levels loop
    merged := merged || least(3, greatest(
      0,
      coalesce(held[i], 0),
      coalesce(new_stars[i], 0)
    ))::smallint;
  end loop;

  insert into adventure_progress (profile_id, stars, updated_at)
  values (auth.uid(), merged, now())
  on conflict (profile_id)
  do update set stars = excluded.stars, updated_at = excluded.updated_at;
  return merged;
end;
$$;

revoke all on function my_adventure() from public, anon;
grant execute on function my_adventure() to authenticated;
revoke all on function save_adventure(smallint[]) from public, anon;
grant execute on function save_adventure(smallint[]) to authenticated;

-- ─────────────────────────────── rewards ──────────────────────────────────────
--
-- The titles this lifter has earned and the one they wear, with the tallies
-- and the training streak the titles are earned by (lib/rewards.dart). They
-- lived on the phone alone, so a new phone, or one handed between accounts,
-- started them all again (the user, 2026-10-29). Nobody else's screen
-- depends on them past the worn title, which profiles carries already, so
-- the server keeps them rather than referees them, the way it keeps the
-- adventure's stars — and never lets one phone take anything from another:
-- a save keeps every title either side has, the larger of each tally, and
-- the streak of whichever side trained last.

create table if not exists rewards_progress (
  profile_id uuid primary key references profiles on delete cascade,
  state      jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  constraint rewards_progress_object check (jsonb_typeof(state) = 'object'),
  constraint rewards_progress_size check (pg_column_size(state) <= 16384)
);

-- Row level security and no policy: the two functions below are the way in.
alter table rewards_progress enable row level security;

-- A whole number at [k] in [j], or 0 for anything else: what a phone sends
-- is never trusted to be the shape it should be.
create or replace function rewards_int(j jsonb, k text)
returns bigint
language sql
immutable
set search_path = public
as $$
  select case when jsonb_typeof(j -> k) = 'number'
              then greatest(0, least((j ->> k)::numeric, 9e15))::bigint
              else 0 end;
$$;

-- Two copies made one. Titles are ids as lib/rewards.dart names them.
create or replace function rewards_merge(a jsonb, b jsonb)
returns jsonb
language sql
immutable
set search_path = public
as $$
  with later as (
    select case when rewards_int(b, 'lastSession') >= rewards_int(a, 'lastSession')
                then b else a end as s
  ),
  titles as (
    select distinct e #>> '{}' as id
      from (
        select jsonb_array_elements(case when jsonb_typeof(a -> 'earned') = 'array'
                                         then a -> 'earned' else '[]'::jsonb end) as e
        union all
        select jsonb_array_elements(case when jsonb_typeof(b -> 'earned') = 'array'
                                         then b -> 'earned' else '[]'::jsonb end)
      ) every_title
     where jsonb_typeof(e) = 'string'
       and (e #>> '{}') ~ '^[a-z0-9_]{1,40}$'
     limit 200
  )
  select jsonb_strip_nulls(jsonb_build_object(
    'streak',        (select rewards_int(s, 'streak') from later),
    'restUsed',      (select rewards_int(s, 'restUsed') from later),
    'perfectDayRun', (select rewards_int(s, 'perfectDayRun') from later),
    'lastSession',   nullif((select rewards_int(s, 'lastSession') from later), 0),
    'wearing',       (select case when (s ->> 'wearing') ~ '^[a-z0-9_]{1,40}$'
                                  then s ->> 'wearing' end from later),
    'bestStreak',    greatest(rewards_int(a, 'bestStreak'), rewards_int(b, 'bestStreak')),
    'cleanSets',     greatest(rewards_int(a, 'cleanSets'), rewards_int(b, 'cleanSets')),
    'earlySessions', greatest(rewards_int(a, 'earlySessions'), rewards_int(b, 'earlySessions')),
    'lateSessions',  greatest(rewards_int(a, 'lateSessions'), rewards_int(b, 'lateSessions')),
    'perfectWeeks',  greatest(rewards_int(a, 'perfectWeeks'), rewards_int(b, 'perfectWeeks')),
    'earned',        coalesce((select jsonb_agg(id order by id) from titles), '[]'::jsonb)
  ));
$$;

-- What the account holds; an empty object for an account with nothing yet.
create or replace function my_rewards()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select r.state from rewards_progress r where r.profile_id = auth.uid()),
    '{}'::jsonb
  );
$$;

-- This phone's copy, merged into the account's; the merged one back, for the
-- phone to take in what another phone added.
create or replace function save_rewards(new_state jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  held jsonb;
  merged jsonb;
begin
  if auth.uid() is null then
    raise exception 'not signed in';
  end if;
  if new_state is null or jsonb_typeof(new_state) <> 'object'
     or pg_column_size(new_state) > 16384 then
    raise exception 'not a rewards copy';
  end if;
  -- A save follows a session or a title worn; a phone saving faster than
  -- that is a loop, and gets the copy held instead.
  if not within_rate('rewards', interval '1 hour', 240) then
    return my_rewards();
  end if;

  select r.state into held from rewards_progress r where r.profile_id = auth.uid();
  merged := rewards_merge(coalesce(held, '{}'::jsonb), new_state);

  insert into rewards_progress (profile_id, state, updated_at)
  values (auth.uid(), merged, now())
  on conflict (profile_id)
  do update set state = excluded.state, updated_at = excluded.updated_at;
  return merged;
end;
$$;

revoke all on function rewards_int(jsonb, text) from public, anon, authenticated;
revoke all on function rewards_merge(jsonb, jsonb) from public, anon, authenticated;
revoke all on function my_rewards() from public, anon;
grant execute on function my_rewards() to authenticated;
revoke all on function save_rewards(jsonb) from public, anon;
grant execute on function save_rewards(jsonb) to authenticated;
