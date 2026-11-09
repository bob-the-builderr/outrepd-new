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
  with me as (select auth.uid() as id),
  lifted as (
    select coalesce(sum(s.reps), 0)::int as reps, count(*)::int as sets
      from sets s, me
     where s.profile_id = me.id and s.created_at >= since and s.created_at < before
       and not s.gave_up
  ),
  best as (
    select coalesce(max(s.reps), 0)::int as best
      from sets s, me
     where s.profile_id = me.id and s.created_at >= since and s.created_at < before
       and challenge_set_ok(s)
  ),
  earlier as (
    select coalesce(max(s.reps), 0)::int as best
      from sets s, me
     where s.profile_id = me.id and s.created_at < since and challenge_set_ok(s)
  ),
  played as (
    select count(*) filter (where d.winner = me.id)::int as wins,
           count(*) filter (where d.winner is not null and d.winner <> me.id)::int as losses
      from duels d, me
     where (d.challenger = me.id or d.defender = me.id)
       and d.created_at >= since and d.created_at < before
  )
  select case when (select id from me) is null then null else
    jsonb_build_object(
      'reps', (select reps from lifted), 'sets', (select sets from lifted),
      'best', (select best from best), 'best_before', (select best from earlier),
      'wins', (select wins from played), 'losses', (select losses from played))
  end;
$$;

revoke all on function my_month_recap(timestamptz, timestamptz) from public;
grant execute on function my_month_recap(timestamptz, timestamptz) to authenticated;
