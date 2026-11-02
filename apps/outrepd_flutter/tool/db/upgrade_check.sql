-- After today's installer was pasted over the live project's server
-- (upgrade_seed.sql): nothing lost, and the new parts filled in right.
\set ON_ERROR_STOP 1
\set A '00000000-0000-0000-0000-0000000000a1'
\set B '00000000-0000-0000-0000-0000000000b1'
\set E '00000000-0000-0000-0000-0000000000e1'

create or replace function upgrade_check(ok boolean, what text) returns void
language plpgsql
as $$
begin
  if ok is not true then
    raise exception 'UPGRADE FAIL: %', what;
  end if;
end;
$$;

-- Every account kept its exact place: the rating is the same rungs.
select upgrade_check(
  (select tier_idx = 3 and div_idx = 2 and lp = 64 and wins = 10
     from profiles where id = :'A'),
  'Gold III with 64 LP did not come through as it was');
select upgrade_check(
  (select tier_idx = 6 and div_idx = 4 and lp = 99 from profiles where id = :'E'),
  'the top of the ladder did not come through as it was');
select upgrade_check((select count(*) = 4 from profiles where username like '%\_up'),
  'an account went missing');

-- Every duel is still there.
select upgrade_check((select count(*) = 5 from duels), 'a duel went missing');

-- This month's duels were given their board points, in order; last
-- month's kept their LP and nothing else.
select upgrade_check(
  (select count(*) = 4 from duels
    where pts_challenger is not null
      and created_at >= date_trunc('month', now() at time zone 'UTC') at time zone 'UTC'),
  'this month''s duels were not given their points');
select upgrade_check(
  (select array_agg(pts_challenger order by created_at) = array[5, 5, 10, -2]
          and array_agg(pts_defender order by created_at) = array[-2, -2, -2, 5]
     from duels
    where created_at >= date_trunc('month', now() at time zone 'UTC') at time zone 'UTC'),
  'this month''s points are not 5, 5, 10, -2 and -2, -2, -2, 5');
select upgrade_check(
  (select pts_challenger is null from duels
    where created_at < date_trunc('month', now() at time zone 'UTC') at time zone 'UTC'),
  'last month''s duel was given points');

-- The month added up again from those: 18 for A, 5 for B (floored at
-- nought on the way). Last month's total is untouched.
select season_points_refresh();
select upgrade_check(
  (select points = 18 from season_points
    where profile_id = :'A' and season = season_of(now())),
  'this month''s board does not have A on 18');
select upgrade_check(
  (select points = 5 from season_points
    where profile_id = :'B' and season = season_of(now())),
  'this month''s board does not have B on 5');
select upgrade_check(
  (select points = 12 from season_points
    where profile_id = :'A' and season = season_of(now() - interval '1 month')),
  'last month''s total changed');

-- Master I can climb past 99 now.
select set_config('outrepd.settling', 'on', false);
update profiles set lp = 140 where id = :'E';
select set_config('outrepd.settling', 'off', false);
select upgrade_check((select lp = 140 from profiles where id = :'E'),
  'Master I could not climb past 99');
select set_config('outrepd.settling', 'on', false);
update profiles set lp = 99 where id = :'E';
select set_config('outrepd.settling', 'off', false);

-- What 1.1.6 added is there.
select upgrade_check(
  (select count(*) = 2 from information_schema.columns
    where table_name = 'profiles' and column_name in ('lifter', 'cover')),
  'the lifter and cover columns are missing');
select upgrade_check(
  (select count(*) = 3 from pg_proc
    where proname in ('last_month_winners', 'pro_looks', 'board_points')),
  'a function 1.1.6 needs is missing');

drop function upgrade_check(boolean, text);
\echo 'upgrade: everything came through'
