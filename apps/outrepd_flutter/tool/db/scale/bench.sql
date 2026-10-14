-- Never run against the real project. See README.md beside this file.
-- Times each call the app makes, as a signed-in lifter would make it (the
-- authenticated role, row security on), averaged over a number of runs.
select (select count(*) from profiles) || ' profiles, ' || (select count(*) from sets) || ' sets, '
    || (select count(*) from duels) || ' duels, ' || (select count(*) from friendships) || ' friendships, '
    || (select count(*) from notifications) || ' notifications, ' || (select count(*) from live_matches)
    || ' live matches, ' || (select count(*) from live_queue) || ' in queue, '
    || pg_size_pretty(pg_database_size(current_database())) as result;

create or replace function bench(label text, q text, n int default 20)
returns text
language plpgsql
as $$
declare
  t0 timestamptz;
  worst double precision := 0;
  total double precision := 0;
  one double precision;
  rows bigint;
begin
  for i in 1..n loop
    t0 := clock_timestamp();
    execute format('select count(*) from (%s) x', q) into rows;
    one := extract(epoch from clock_timestamp() - t0) * 1000;
    total := total + one;
    worst := greatest(worst, one);
  end loop;
  return rpad(label, 34) || lpad(to_char(total / n, 'FM9990.00'), 9) || ' ms avg'
      || lpad(to_char(worst, 'FM9990.00'), 9) || ' ms worst' || lpad(rows::text, 6) || ' rows';
end;
$$;
grant execute on function bench(text, text, int) to authenticated, anon;

-- A lifter in the middle of the ladder, with friends and history.
select set_config('request.jwt.claim.sub',
  (select id::text from profiles where username = 'lifter_5000'), false) as result;
select set_config('bench.other', (select id::text from profiles where username = 'lifter_5001'), false) as result;
set role authenticated;

select bench('own profile row', 'select * from profiles where id = auth.uid()') as result;
select bench('my_live_invites (every 5 s)', 'select * from my_live_invites()') as result;
select bench('unread_notifications', 'select unread_notifications()') as result;
select bench('my_notifications', 'select * from my_notifications()') as result;
select bench('my_friends', 'select * from my_friends()') as result;
select bench('friend_requests', 'select * from friend_requests()') as result;
select bench('leaderboard (top players)', 'select * from leaderboard(null, 100)') as result;
select bench('leaderboard (country)', 'select * from leaderboard(''US'', 100)') as result;
select bench('leaderboard (your tier)', 'select * from leaderboard(null, 100, 2, 3)') as result;
select bench('my_board_place (global)', 'select my_board_place(null)') as result;
select bench('my_board_place (country)', 'select my_board_place(''US'')') as result;
select bench('lifter_profile', 'select * from lifter_profile(current_setting(''bench.other'')::uuid)') as result;
select bench('month_board', 'select * from month_board()') as result;
select bench('my_month_place', 'select * from my_month_place()') as result;
select bench('live_online (every 3 s searching)', 'select * from live_online()') as result;
select bench('find_lifters', 'select * from find_lifters(''lifter_12'')') as result;
select bench('find_opponent_set', 'select * from find_opponent_set()', 5) as result;
select bench('find_live_opponent (every 3 s)', 'select * from find_live_opponent()', 10) as result;
select bench('my_season_awards', 'select * from my_season_awards()') as result;
select bench('my_invites', 'select * from my_invites()') as result;
select bench('my_account_summary', 'select * from my_account_summary()') as result;
select bench('my_data (export)', 'select my_data()', 3) as result;
reset role;
