-- OUTREPD — moments (the user's pick, 2026-11-09): a new personal best and
-- a milestone get a screen of their own, and each month a recap.
--
-- The best and the milestones are the phone's to notice: it counts every set
-- as it lands. The month is the account's: every set and every duel of it,
-- from whichever phone they were lifted on, so the recap is the whole month
-- and not just what this phone happened to see.

-- The caller's month from [since] up to [before]: push-ups and sets lifted,
-- the best whole minute and the best before the month (what it was beaten
-- from), and the duels won and lost. Nothing for a stranger's month: only
-- auth.uid()'s own rows are read.
create or replace function my_month_recap(since timestamptz, before timestamptz)
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  -- auth.uid() itself in each part, not joined in from a one-row list: the
  -- planner then reads the lifter's own rows by their index (sets_profile_idx,
  -- duels_for_profile_idx and duels_against_profile_idx) instead of every
  -- set and duel there is — eight seconds at 100,000 lifters (2026-11-12).
  with lifted as (
    select coalesce(sum(s.reps), 0)::int as reps, count(*)::int as sets
      from sets s
     where s.profile_id = auth.uid() and s.created_at >= since and s.created_at < before
       and not s.gave_up
  ),
  best as (
    select coalesce(max(s.reps), 0)::int as best
      from sets s
     where s.profile_id = auth.uid() and s.created_at >= since and s.created_at < before
       and challenge_set_ok(s)
  ),
  earlier as (
    select coalesce(max(s.reps), 0)::int as best
      from sets s
     where s.profile_id = auth.uid() and s.created_at < since and challenge_set_ok(s)
  ),
  sides as (
    select d.winner from duels d
     where d.challenger = auth.uid() and d.created_at >= since and d.created_at < before
    union all
    select d.winner from duels d
     where d.defender = auth.uid() and d.created_at >= since and d.created_at < before
  ),
  played as (
    select count(*) filter (where x.winner = auth.uid())::int as wins,
           count(*) filter (where x.winner is not null and x.winner <> auth.uid())::int as losses
      from sides x
  )
  select case when auth.uid() is null then null else
    jsonb_build_object(
      'reps', (select reps from lifted), 'sets', (select sets from lifted),
      'best', (select best from best), 'best_before', (select best from earlier),
      'wins', (select wins from played), 'losses', (select losses from played))
  end;
$$;

revoke all on function my_month_recap(timestamptz, timestamptz) from public;
grant execute on function my_month_recap(timestamptz, timestamptz) to authenticated;
