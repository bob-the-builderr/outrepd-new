-- OUTREPD — tidying up (the server at 100,000 lifters, 2026-11-12).
--
-- A few tables only ever grow, and nothing the app shows reads far back in
-- them: notices (the app lists the newest fifty), invites that were never
-- played, a live queue that a phone left without saying, the rate limiter's
-- marks, the sets handed out to race. At a hundred thousand lifters that is
-- millions of rows a month, paid for in disk and in every search over them.
-- Once a day, the old ones go, with the weeks' totals past last week (only
-- this week's is read). Nothing a lifter has earned is touched: sets,
-- duels, played live matches, the month's points, awards, friends.

-- Deletes what is past keeping, a batch at a time so no table is held for
-- long, and says how many of each went. Run by the scheduler below; nobody
-- calling from the app may run it.
create or replace function tidy_old_rows(batch int default 50000)
returns jsonb
language plpgsql
set search_path = public
as $$
declare
  gone_notices int;
  gone_invites int;
  gone_queue int;
  gone_marks int;
  gone_offers int;
  gone_weeks int;
begin
  -- Read notices after two months, and any notice after four.
  delete from notifications n
   where n.id in (select x.id from notifications x
                   where (x.read_at is not null and x.created_at < now() - interval '60 days')
                      or x.created_at < now() - interval '120 days'
                   limit batch);
  get diagnostics gone_notices = row_count;

  -- Live matches never played after a month: invites declined, cancelled or
  -- run out, and pairings nobody started. A played one has its duel and stays.
  delete from live_matches m
   where m.id in (select x.id from live_matches x
                   where x.status <> 'done' and x.duel is null
                     and x.created_at < now() - interval '30 days'
                   limit batch);
  get diagnostics gone_invites = row_count;

  -- Searches nobody has asked about for an hour (find_live_opponent drops
  -- those over a minute old, but only when somebody searches).
  delete from live_queue q where q.seen_at < now() - interval '1 hour';
  get diagnostics gone_queue = row_count;

  -- The rate limiter looks back a day at most (rate_ok clears the caller's
  -- own older than two days, but only when they call).
  delete from rate_events r where r.at < now() - interval '2 days';
  get diagnostics gone_marks = row_count;

  -- Sets handed out to race and never raced (find_opponent_set drops the
  -- caller's own after a day, but only when they search again).
  delete from set_offers o where o.offered_at < now() - interval '2 days';
  get diagnostics gone_offers = row_count;

  -- Weeks' totals past last week: only this week's is read (seasons.sql).
  delete from week_totals w where w.week < week_of(now()) - 7;
  get diagnostics gone_weeks = row_count;

  return jsonb_build_object(
    'notifications', gone_notices,
    'live_matches', gone_invites,
    'live_queue', gone_queue,
    'rate_events', gone_marks,
    'set_offers', gone_offers,
    'week_totals', gone_weeks);
end;
$$;
revoke all on function tidy_old_rows(int) from public, anon, authenticated;

-- Every night at 03:17 UTC, by Supabase's scheduler (pg_cron). Where there
-- is none — CI's bare Postgres — the job is skipped and the function stays,
-- to be run by hand: `select tidy_old_rows();`. Scheduling it again under
-- the same name replaces the job rather than adding a second.
do $$
begin
  if exists (select 1 from pg_available_extensions where name = 'pg_cron') then
    begin
      create extension if not exists pg_cron with schema pg_catalog;
      perform cron.schedule('outrepd-tidy', '17 3 * * *', 'select public.tidy_old_rows()');
    exception when others then
      raise notice 'tidy_old_rows is not scheduled: %', sqlerrm;
    end;
  end if;
end $$;
