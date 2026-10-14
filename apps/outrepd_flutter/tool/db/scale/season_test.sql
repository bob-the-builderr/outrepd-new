-- Never run against the real project. See README.md beside this file.
-- The running totals against the duels they come from, through each way a
-- duel is written: a raced set, a live match (the duel named on the match
-- only after it is written, as settle_live does), an unranked duel, and an
-- account deleted with its duels.
create or replace function season_test() returns text language plpgsql as $$
declare
  a uuid; b uuid; c uuid;
  sa uuid; sb uuid; sc uuid; sd uuid;
  d1 uuid; d2 uuid; lm uuid;
  before_a season_points; after_a season_points;
  before_b season_points; after_b season_points;
  out text := '';
begin
  select id into a from profiles where username = 'lifter_100';
  select id into b from profiles where username = 'lifter_200';
  select id into c from profiles where username = 'lifter_300';
  select * into before_a from season_points where season = season_of(now()) and profile_id = a;
  select * into before_b from season_points where season = season_of(now()) and profile_id = b;
  insert into sets (profile_id, reps, reps_camera, duration_ms) values (a, 20, 20, 60000) returning id into sa;
  insert into sets (profile_id, reps, reps_camera, duration_ms) values (b, 15, 15, 60000) returning id into sb;
  insert into duels (challenger, defender, challenger_set, defender_set, winner, ranked, lp_challenger, lp_defender)
  values (a, b, sa, sb, a, true, 9, -6) returning id into d1;
  return d1::text;
end $$;

-- 1. A raced set: the challenger played, the defender (away) did not.
select season_test() as result;
create temp table t1 as select profile_id, points, wins, played from season_points where season = season_of(now());
select 'raced set   — totals vs duels differing: ' || count(*) as result from (
  (select * from season_points_from_duels(season_of(now())) except select profile_id, points, wins, played from season_points where season = season_of(now()))
  union all
  (select profile_id, points, wins, played from season_points where season = season_of(now()) except select * from season_points_from_duels(season_of(now())))) x;

-- 2. A live match: the duel, then the match naming it, in one transaction.
do $$
declare a uuid; b uuid; sa uuid; sb uuid; d uuid; m uuid;
begin
  select id into a from profiles where username = 'lifter_400';
  select id into b from profiles where username = 'lifter_500';
  insert into live_matches (ranked, a, b, status) values (true, a, b, 'live') returning id into m;
  insert into sets (profile_id, reps, reps_camera, duration_ms, live_match) values (a, 22, 22, 60000, m) returning id into sa;
  insert into sets (profile_id, reps, reps_camera, duration_ms, live_match) values (b, 25, 25, 60000, m) returning id into sb;
  insert into duels (challenger, defender, challenger_set, defender_set, winner, ranked, lp_challenger, lp_defender)
  values (a, b, sa, sb, b, true, -4, 8) returning id into d;
  update live_matches set status = 'done', duel = d where id = m;
end $$;
select 'live match  — totals vs duels differing: ' || count(*) as result from (
  (select * from season_points_from_duels(season_of(now())) except select profile_id, points, wins, played from season_points where season = season_of(now()))
  union all
  (select profile_id, points, wins, played from season_points where season = season_of(now()) except select * from season_points_from_duels(season_of(now())))) x;

-- 3. An unranked duel changes nothing.
create temp table before_unranked as select * from season_points;
do $$
declare a uuid; b uuid; sa uuid; sb uuid;
begin
  select id into a from profiles where username = 'lifter_600';
  select id into b from profiles where username = 'lifter_700';
  insert into sets (profile_id, reps, reps_camera, duration_ms) values (a, 20, 20, 60000) returning id into sa;
  insert into sets (profile_id, reps, reps_camera, duration_ms) values (b, 15, 15, 60000) returning id into sb;
  insert into duels (challenger, defender, challenger_set, defender_set, winner, ranked, lp_challenger, lp_defender)
  values (a, b, sa, sb, a, false, 0, 0);
end $$;
select 'unranked    — rows changed: ' || count(*) as result from (
  (select * from season_points except select * from before_unranked)
  union all (select * from before_unranked except select * from season_points)) x;

-- 4. An account deleted: its duels go, the month is stale until read, then
--    matches the duels again.
delete from auth.users where id = (select id from profiles where username = 'lifter_800');
select 'deleted     — months stale: ' || count(*) as result from season_points_stale;
select season_points_refresh();
select 'deleted     — totals vs duels differing after refresh: ' || count(*) as result from (
  (select * from season_points_from_duels(season_of(now())) except select profile_id, points, wins, played from season_points where season = season_of(now()))
  union all
  (select profile_id, points, wins, played from season_points where season = season_of(now()) except select * from season_points_from_duels(season_of(now())))) x;
select 'deleted     — months stale after refresh: ' || count(*) as result from season_points_stale;
