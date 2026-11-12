-- Never run against the real project. See README.md beside this file.
-- Times each call the app makes, as a signed-in lifter would make it (the
-- authenticated role, row security on), averaged over a number of runs.
select (select count(*) from profiles) || ' profiles, ' || (select count(*) from sets) || ' sets, '
    || (select count(*) from duels) || ' duels, ' || (select count(*) from friendships) || ' friendships, '
    || (select count(*) from notifications) || ' notifications, ' || (select count(*) from live_matches)
    || ' live matches, ' || (select count(*) from live_queue) || ' in queue, '
    || (select count(*) from challenges) || ' challenges, '
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
  return rpad(label, 36) || lpad(to_char(total / n, 'FM99990.00'), 10) || ' ms avg'
      || lpad(to_char(worst, 'FM99990.00'), 10) || ' ms worst' || lpad(rows::text, 7) || ' rows';
exception when others then
  return rpad(label, 36) || ' error: ' || sqlerrm;
end;
$$;
grant execute on function bench(text, text, int) to authenticated, anon;

-- A lifter in the middle of the crowd, with friends, history and a
-- challenge link out; the one after them is whose profile is opened.
select set_config('request.jwt.claim.sub',
  (select id::text from profiles where username = 'lifter_' || (select count(*) / 2 from profiles)), false) as result;
select set_config('bench.other',
  (select id::text from profiles where username = 'lifter_' || (select count(*) / 2 + 1 from profiles)), false) as result;
select set_config('bench.code',
  coalesce((select c.code from challenges c join profiles p on p.id = c.owner
    where p.username = 'lifter_' || (select count(*) / 2 from profiles)), ''), false) as result;
select set_config('bench.match',
  coalesce((select m.id::text from live_matches m
             where m.a = current_setting('request.jwt.claim.sub')::uuid limit 1), ''), false) as result;
-- And the lowest placed lifter on the rating, whose place on it counts
-- everybody above them.
select set_config('bench.low',
  (select id::text from profiles where placements_done >= 5
    order by tier_idx, div_idx, lp, wins limit 1), false) as result;
set role authenticated;

\echo
\echo '-- Polled while the app is open'
select bench('my_live_invites (every 5 s)', 'select * from my_live_invites()') as result;
select bench('live_online (every 3 s searching)', 'select * from live_online()') as result;
select bench('find_live_opponent (every 3 s)', 'select * from find_live_opponent()', 10) as result;
select bench('live_match_state (every 3 s live)', 'select * from live_match_state(nullif(current_setting(''bench.match''), '''')::uuid)') as result;

\echo
\echo '-- Home and profile'
select bench('own profile row', 'select * from profiles where id = auth.uid()') as result;
select bench('unread_notifications', 'select unread_notifications()') as result;
select bench('my_notifications', 'select * from my_notifications()') as result;
select bench('my_challenges', 'select * from my_challenges()') as result;
select bench('challenge_best', 'select * from challenge_best()') as result;
select bench('my_plan', 'select * from my_plan()') as result;
select bench('my_rewards', 'select * from my_rewards()') as result;
select bench('my_adventure', 'select * from my_adventure()') as result;
select bench('my_best_minute (week)', 'select * from my_best_minute(now() - interval ''7 days'', now())') as result;
select bench('my_days (60)', 'select * from my_days(0, 60)') as result;
select bench('my_duels', 'select * from my_duels()') as result;
select bench('my_month_recap', 'select * from my_month_recap(date_trunc(''month'', now()), now())') as result;
select bench('my_season_awards', 'select * from my_season_awards()') as result;
select bench('award_rarity', 'select * from award_rarity()') as result;
select bench('my_account_summary', 'select * from my_account_summary()') as result;
select bench('lifter_profile', 'select * from lifter_profile(current_setting(''bench.other'')::uuid)') as result;
select bench('lifter_profile (lowest placed)', 'select * from lifter_profile(current_setting(''bench.low'')::uuid)') as result;
select bench('lifter_showcase', 'select * from lifter_showcase(current_setting(''bench.other'')::uuid)') as result;
select bench('lifter_season_awards', 'select * from lifter_season_awards(current_setting(''bench.other'')::uuid)') as result;

\echo
\echo '-- Friends'
select bench('my_friends', 'select * from my_friends()') as result;
select bench('friend_requests', 'select * from friend_requests()') as result;
select bench('friends_board (week)', 'select * from friends_board(false)') as result;
select bench('friends_board (month)', 'select * from friends_board(true)') as result;
select bench('friends_leaderboard', 'select * from friends_leaderboard()') as result;
select bench('my_blocks', 'select * from my_blocks()') as result;
select bench('my_mutes', 'select * from my_mutes()') as result;
select bench('find_lifters', 'select * from find_lifters(''lifter_12'')') as result;

\echo
\echo '-- Boards'
select bench('week_board (everyone)', 'select * from week_board(null, 100)') as result;
select bench('week_board (country)', 'select * from week_board(''US'', 100)') as result;
select bench('my_week_place (everyone)', 'select * from my_week_place(null)') as result;
select bench('my_week_place (country)', 'select * from my_week_place(''US'')') as result;
select bench('month_board', 'select * from month_board()') as result;
select bench('my_month_place', 'select * from my_month_place()') as result;
select bench('last_month_winners', 'select * from last_month_winners()') as result;
select bench('leaderboard (top players)', 'select * from leaderboard(null, 100)') as result;
select bench('leaderboard (country)', 'select * from leaderboard(''US'', 100)') as result;
select bench('leaderboard (your tier)', 'select * from leaderboard(null, 100, 2, 3)') as result;
select bench('my_board_place (global)', 'select my_board_place(null)') as result;
select bench('my_board_place (country)', 'select my_board_place(''US'')') as result;
select bench('pro_looks (a board of 100)', 'select * from pro_looks(array(select id from profiles order by tier_idx desc, div_idx desc, lp desc limit 100))') as result;

\echo
\echo '-- Matches'
select bench('find_opponent_set', 'select * from find_opponent_set()', 5) as result;
select bench('open_challenge (a link)', 'select * from open_challenge(current_setting(''bench.code''))') as result;

\echo
\echo '-- Rare'
select bench('my_data (export)', 'select my_data()', 3) as result;
reset role;

\echo
\echo '-- The website, signed out'
set role anon;
select bench('public_lifter_card (u/<name>)', 'select * from public_lifter_card(''lifter_77'')') as result;
reset role;
