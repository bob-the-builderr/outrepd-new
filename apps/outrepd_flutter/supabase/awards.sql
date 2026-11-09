-- OUTREPD — awards (the user's picks, 2026-11-09): how rare each one is, and
-- the three a lifter pins to their profile. What each account has earned is
-- its rewards copy (adventure.sql, rewards_progress.state -> 'earned').

-- How many of the lifters who keep awards hold each one, in whole percent:
-- {"grinder_1": 64, "photo_finish": 3, ...}. Only award ids, never who.
create or replace function award_rarity()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  with everyone as (
    select greatest(count(*), 1)::numeric as n from rewards_progress
  ),
  held as (
    select e #>> '{}' as id, count(*) as c
      from rewards_progress r,
           jsonb_array_elements(case when jsonb_typeof(r.state -> 'earned') = 'array'
                                     then r.state -> 'earned' else '[]'::jsonb end) e
     where jsonb_typeof(e) = 'string'
     group by 1
  )
  select coalesce(jsonb_object_agg(held.id, round(100 * held.c / everyone.n)::int), '{}'::jsonb)
    from held, everyone
   where auth.uid() is not null and held.id ~ '^[a-z0-9_]{1,40}$';
$$;

-- The awards [their_id] pinned to their profile, up to three; none between
-- two people who are blocked, as nothing else is shown between them.
create or replace function lifter_showcase(their_id uuid)
returns text[]
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(array(
    select e #>> '{}'
      from rewards_progress r,
           jsonb_array_elements(case when jsonb_typeof(r.state -> 'showcase') = 'array'
                                     then r.state -> 'showcase' else '[]'::jsonb end) e
     where r.profile_id = their_id
       and jsonb_typeof(e) = 'string'
       and (e #>> '{}') ~ '^[a-z0-9_]{1,40}$'
       and auth.uid() is not null
       and not exists (select 1 from blocks b
                        where (b.blocker = auth.uid() and b.blocked = their_id)
                           or (b.blocker = their_id and b.blocked = auth.uid()))
     limit 3), '{}');
$$;

revoke all on function award_rarity() from public;
grant execute on function award_rarity() to authenticated;
revoke all on function lifter_showcase(uuid) from public;
grant execute on function lifter_showcase(uuid) to authenticated;
