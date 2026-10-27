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
