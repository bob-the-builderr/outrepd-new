-- The server, attacked the way a modified phone would, after install.sql has
-- run on a bare Postgres (see stubs.sql). Every check either passes quietly
-- or stops the run with FAIL and what got through.
--
-- Each request runs as `authenticated` with a user's id as its token's `sub`
-- claim — the exact shape a Supabase request has — switched with as_user()
-- and `set role`. Statements run one at a time, so now() moves between them
-- the way it does between a phone's calls.

\set ON_ERROR_STOP 1
\set A '00000000-0000-0000-0000-00000000000a'
\set B '00000000-0000-0000-0000-00000000000b'
\set C '00000000-0000-0000-0000-00000000000c'
\set D '00000000-0000-0000-0000-00000000000d'

create or replace function as_user(who uuid) returns void
language sql
as $$ select set_config('request.jwt.claim.sub', coalesce(who::text, ''), false) $$;

-- A statement that must be refused: runs it, and fails the run if it went
-- through. Execute rather than inline so each one is its own small test.
create or replace function must_fail(what text, statement text) returns void
language plpgsql
as $$
begin
  begin
    execute statement;
  exception when others then
    -- Said, so the log shows each refusal was the rule meant to refuse it
    -- and not some other error on the way there.
    raise notice 'refused, as it should be — %: %', what, sqlerrm;
    return;
  end;
  raise exception 'FAIL: % — it went through', what;
end;
$$;
grant execute on function as_user(uuid) to authenticated;
grant execute on function must_fail(text, text) to authenticated;

create or replace function check_that(ok boolean, what text) returns void
language plpgsql
as $$
begin
  if ok is not true then
    raise exception 'FAIL: %', what;
  end if;
end;
$$;
grant execute on function check_that(boolean, text) to authenticated;

insert into auth.users (id) values (:'A'), (:'B'), (:'C'), (:'D');

-- ── accounts, made the way the app makes them ─────────────────────────────────

select as_user(:'A'); set role authenticated;
insert into profiles (id, username, country) values (:'A', 'alice_a1', 'EG');
reset role;
select as_user(:'B'); set role authenticated;
insert into profiles (id, username, country) values (:'B', 'bob_b1', 'US');
reset role;
select as_user(:'C'); set role authenticated;
-- A name with a space and punctuation in it, sent around the app.
insert into profiles (id, username, country) values (:'C', 'carol c!', 'FR');
reset role;
select as_user(:'D'); set role authenticated;
-- And one trying to arrive already a Master.
insert into profiles (id, username, country, tier_idx, wins, xp)
values (:'D', 'dan_d1', 'EG', 6, 999, 50000);
reset role;

select check_that((select username from profiles where id = :'C') like 'lifter%',
                  'a name with a space in it was stored as typed');
select check_that((select tier_idx = 0 and wins = 0 and xp = 0 from profiles where id = :'D'),
                  'a new account arrived with a rank it never earned');

-- ── profiles: your own row only ───────────────────────────────────────────────

select as_user(:'A'); set role authenticated;
select check_that((select count(*) from profiles) = 1,
                  'a lifter can read other people''s rows straight from profiles');
select must_fail('writing your own LP',
                 $q$update profiles set lp = 99 where id = auth.uid()$q$);
reset role;

-- ── friendships ───────────────────────────────────────────────────────────────

select as_user(:'A'); set role authenticated;
select must_fail('a friendship written straight into the table, already accepted',
  $q$insert into friendships (requester, addressee, accepted_at)
     values ('00000000-0000-0000-0000-00000000000a',
             '00000000-0000-0000-0000-00000000000c', now())$q$);
select check_that(request_friend_with(:'B') = 'asked', 'asking a friend');
reset role;

select as_user(:'B'); set role authenticated;
-- Holding A's request, B tries to make it a friendship with C instead.
update friendships set requester = :'C', accepted_at = now()
 where addressee = :'B';
select check_that(answer_friend(:'A', true) = 'friends', 'answering a request');
reset role;

select check_that(not exists (select 1 from friendships where requester = :'C'),
                  'the asked one rewrote who a request was from');
select check_that(exists (select 1 from friendships
                           where requester = :'A' and addressee = :'B'
                             and accepted_at is not null),
                  'an accepted request is not a friendship');

-- Ask, withdraw, ask again: a push every time, unless counted.
select as_user(:'C'); set role authenticated;
do $$
begin
  for i in 1..6 loop
    perform request_friend_with('00000000-0000-0000-0000-00000000000d');
    delete from friendships
     where requester = '00000000-0000-0000-0000-00000000000c'
       and addressee = '00000000-0000-0000-0000-00000000000d';
  end loop;
end $$;
reset role;
select check_that((select count(*) from notifications
                    where profile_id = :'D' and kind = 'friend_request') <= 3,
                  'asking and withdrawing sent a push every time');

-- ── sets ──────────────────────────────────────────────────────────────────────

select as_user(:'A'); set role authenticated;
select must_fail('250 push-ups in a minute',
  $q$insert into sets (profile_id, reps, reps_camera, duration_ms)
     values (auth.uid(), 250, 250, 60000)$q$);
select must_fail('a minute stretched to an hour to fit the count',
  $q$insert into sets (profile_id, reps, reps_camera, duration_ms)
     values (auth.uid(), 250, 250, 3600000)$q$);
insert into sets (profile_id, reps, reps_camera, duration_ms, claimed_by,
                  created_at)
values (auth.uid(), 30, 30, 60000, gen_random_uuid(), now() - interval '1 year');
select must_fail('a second set two seconds after the first',
  $q$insert into sets (profile_id, reps, reps_camera, duration_ms)
     values (auth.uid(), 30, 30, 60000)$q$);
reset role;

select check_that((select claimed_by is null and created_at > now() - interval '1 minute'
                     from sets where profile_id = :'A'),
                  'a set kept the claim and the date the phone sent');

-- A challenge to somebody who is neither a friend nor a past opponent.
select as_user(:'C'); set role authenticated;
select must_fail('a challenge sent to a stranger',
  $q$insert into sets (profile_id, reps, reps_camera, duration_ms, challenge_target)
     values (auth.uid(), 10, 10, 60000, '00000000-0000-0000-0000-00000000000a')$q$);
reset role;

-- ── settling: only what was handed to you ─────────────────────────────────────

-- D is a second account with nothing in its sets.
select as_user(:'D'); set role authenticated;
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (auth.uid(), 0, 0, 60000);
reset role;

-- Read as the owner: D's set is not A's to see, which is exactly why the
-- attack is to name its id anyway — an id can leak, or be D's own.
select set_config('test.d1',
  (select id::text from sets where profile_id = :'D' limit 1), false);
select set_config('test.a1',
  (select id::text from sets where profile_id = :'A' limit 1), false);
select as_user(:'A'); set role authenticated;
select must_fail('settling against a set nobody handed over',
  format('select settle_duel(%L, %L, true)',
         current_setting('test.a1'), current_setting('test.d1')));
-- Now the honest way round: the pool hands it over.
select check_that((select count(*) from find_opponent_set()) = 1,
                  'the pool did not hand out the set waiting in it');
-- A's set from before the offer is not the one raced against it.
select must_fail('settling with a set lifted before the offer',
  format('select settle_duel(%L, %L, true)',
         current_setting('test.a1'), current_setting('test.d1')));
reset role;

select pg_sleep(8.5);
select as_user(:'A'); set role authenticated;
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (auth.uid(), 40, 40, 60000);
reset role;
-- set_offers has no policy, so the offered id is read as the owner.
select set_config('test.offered',
  (select set_id::text from set_offers where offered_to = :'A' limit 1), false);
select set_config('test.mine',
  (select id::text from sets where profile_id = :'A' order by created_at desc limit 1), false);
select as_user(:'A'); set role authenticated;
select check_that(
  (select won from settle_duel(current_setting('test.mine')::uuid,
                               current_setting('test.offered')::uuid, true)),
  'an honest duel did not settle');
reset role;

-- The duel is in both histories, each from its own side; D was away for it.
select as_user(:'D'); set role authenticated;
select check_that((select count(*) from my_duels() where raced_while_away
                    and not you_won and your_reps = 0 and their_reps = 40) = 1,
                  'a set raced while its owner was away never reached them');
reset role;
select as_user(:'A'); set role authenticated;
select check_that((select count(*) from my_duels() where not raced_while_away
                    and you_won and your_reps = 40 and their_reps = 0) = 1,
                  'the lifter who raced was not shown the duel from their side');
reset role;
select as_user(:'C'); set role authenticated;
select check_that((select count(*) from my_duels()) = 0,
                  'somebody else''s duel was in a third lifter''s history');
reset role;

-- Again with the same second account: the pool will not pair them twice,
-- and a set it did not hand over does not settle.
select pg_sleep(8.5);
select as_user(:'D'); set role authenticated;
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (auth.uid(), 0, 0, 60000);
reset role;
select as_user(:'A'); set role authenticated;
select check_that((select count(*) from find_opponent_set()) = 0,
                  'the pool paired the same two accounts twice');
reset role;
select set_config('test.d2',
  (select id::text from sets where profile_id = :'D' and claimed_by is null limit 1), false);
select pg_sleep(8.5);
select as_user(:'A'); set role authenticated;
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (auth.uid(), 40, 40, 60000);
select must_fail('farming the same second account a second time',
  format('select settle_duel(%L, %L, true)',
         (select id from sets where profile_id = auth.uid() and claimed_by is null
           order by created_at desc limit 1),
         current_setting('test.d2')));
reset role;

-- ── a rematch never moves a rank ──────────────────────────────────────────────

select as_user(:'B'); set role authenticated;
insert into sets (profile_id, reps, reps_camera, duration_ms, challenge_target)
values (auth.uid(), 0, 0, 60000, :'A');
reset role;
select check_that(exists (select 1 from notifications
                           where profile_id = :'A' and kind = 'challenged'),
                  'a friend''s challenge never reached them');
select pg_sleep(8.5);
select as_user(:'A'); set role authenticated;
select check_that((select count(*) from find_targeted_set(:'B')) = 1,
                  'the challenge set was not handed over');
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (auth.uid(), 50, 50, 60000);
reset role;
select set_config('test.challenge',
  (select set_id::text from set_offers where offered_to = :'A' and targeted limit 1), false);
select set_config('test.mine',
  (select id::text from sets where profile_id = :'A' and claimed_by is null
    order by created_at desc limit 1), false);
select as_user(:'A'); set role authenticated;
select settle_duel(current_setting('test.mine')::uuid,
                   current_setting('test.challenge')::uuid, true);
reset role;
select check_that((select not ranked from duels
                    where challenger = :'A' and defender = :'B'),
                  'a rematch asked to be ranked, and was');

-- ── reports ───────────────────────────────────────────────────────────────────

select as_user(:'A'); set role authenticated;
insert into reports (reporter, reported, reason) values (auth.uid(), :'C', 'other');
insert into reports (reporter, reported, reason) values (auth.uid(), :'C', 'other');
insert into reports (reporter, reported, reason) values (auth.uid(), :'C', 'other');
reset role;
select check_that((select count(*) from reports where reporter = :'A') = 1,
                  'the same account was reported three times in a day, three emails');
-- A report that arrives already marked as emailed about would never be.
select as_user(:'B'); set role authenticated;
insert into reports (reporter, reported, reason, alerted_at)
values (auth.uid(), :'C', 'other', now());
reset role;
select check_that((select alerted_at is null from reports where reporter = :'B'),
                  'a report arrived already marked as alerted');
select check_that((select count(*) from pg_trigger
                    where tgrelid = 'reports'::regclass and not tgisinternal
                      and tgname = 'send_report_alert') = 1,
                  'no trigger hands new reports to report-alert');

-- ── what other people see ─────────────────────────────────────────────────────

select as_user(:'B'); set role authenticated;
update profiles set show_country = false where id = auth.uid();
reset role;
select as_user(:'A'); set role authenticated;
select check_that((select country is null from lifter_profile(:'B')),
                  'a profile card showed a country its owner hid');
select check_that((select count(*) from my_friends()) = 1,
                  'the friends list came back empty once profiles closed');
select check_that((select count(*) from friend_requests()) = 0,
                  'friend_requests failed');
select check_that(jsonb_array_length(my_data() -> 'friends') = 1,
                  'the export lost its friends');
select check_that(not username_available('BOB_B1'),
                  'a taken name read as free once profiles closed');
-- A guest picks a name on the sign-up screen, goes back and picks another.
select check_that(set_my_username('Alice2') = 'ok', 'renaming');
-- Underscores, the way handles are usually written — but not a name made
-- of nothing else, and still no spaces.
select check_that(set_my_username('iron_mike') = 'ok',
                  'an underscore in a name was refused');
select check_that(set_my_username('____') = 'invalid',
                  'a name of nothing but underscores');
select check_that(set_my_username('al ice') = 'invalid', 'a space in a name');
select check_that(set_my_username('Alice3') = 'ok',
                  'a guest could not change the name they had just typed');
reset role;
-- Then confirms the email: the name chosen is kept for fourteen days.
update auth.users set email = 'a@example.com', email_confirmed_at = now()
 where id = :'A';
select as_user(:'A'); set role authenticated;
select check_that(set_my_username('Alice4') = 'already_changed',
                  'a confirmed account renamed again inside fourteen days');
reset role;
select check_that((select username from profiles where id = :'A') = 'Alice3',
                  'the name kept is not the last one chosen');
-- Fourteen days on, it can change again, and the clock starts over.
set session_replication_role = replica;
update profiles set username_changed_at = now() - interval '15 days'
 where id = :'A';
set session_replication_role = default;
select as_user(:'A'); set role authenticated;
select check_that(set_my_username('Alice4') = 'ok',
                  'a rename fourteen days after the last was refused');
select check_that(set_my_username('Alice5') = 'already_changed',
                  'a second rename straight after the first');
reset role;
select check_that((select username from profiles where id = :'A') = 'Alice4',
                  'the name after a rename fourteen days on');

-- The country: chosen through set_my_country, under the same fourteen days
-- once the account is confirmed, and never written around it.
select as_user(:'A'); set role authenticated;
select must_fail('writing a country around set_my_country',
  $q$update profiles set country = 'US' where id = auth.uid()$q$);
select check_that(set_my_country('us') = 'ok',
                  'a confirmed account choosing its country');
select check_that(set_my_country('FR') = 'too_soon',
                  'a second country inside fourteen days');
select check_that(set_my_country('Egypt') = 'invalid',
                  'a country that is not a two-letter code');
reset role;
select check_that((select country from profiles where id = :'A') = 'US',
                  'the country kept is not the one chosen');
set session_replication_role = replica;
update profiles set country_changed_at = now() - interval '15 days'
 where id = :'A';
set session_replication_role = default;
select as_user(:'A'); set role authenticated;
select check_that(set_my_country('FR') = 'ok',
                  'a country change fourteen days after the last was refused');
reset role;
-- A guest picks freely, and nothing starts the fourteen days.
select as_user(:'B'); set role authenticated;
select check_that(set_my_country('DE') = 'ok', 'a guest choosing a country');
select check_that(set_my_country('AT') = 'ok', 'a guest changing it again');
reset role;
select check_that((select country_changed_at from profiles where id = :'B') is null,
                  'a guest''s choice started the fourteen days');

-- The adventure: kept per account, reached only through its two functions,
-- and a save never takes a star away.
select as_user(:'A'); set role authenticated;
select check_that(cardinality(my_adventure()) = 0,
                  'a new account started with an adventure');
select check_that(save_adventure('{3,1,2}') = '{3,1,2}'::smallint[],
                  'saving the first three levels');
select check_that(save_adventure('{1,3}') = '{3,3,2}'::smallint[],
                  'a save took stars off a level, or lost the ones it did not send');
select check_that(save_adventure('{0,0,0,9}') = '{3,3,2,3}'::smallint[],
                  'a level saved with more than three stars');
select must_fail('an adventure longer than the map',
  $q$select save_adventure(array_fill(1::smallint, array[141]))$q$);
select must_fail('writing the adventure around save_adventure',
  $q$insert into adventure_progress (profile_id, stars) values (auth.uid(), '{3,3,3,3}')$q$);
do $$
declare
  seen int;
begin
  begin
    select count(*) into seen from adventure_progress;
  exception when insufficient_privilege then
    seen := 0;
  end;
  if seen <> 0 then
    raise exception 'FAIL: the adventure table read around my_adventure';
  end if;
end;
$$;
reset role;
select as_user(:'B'); set role authenticated;
select check_that(cardinality(my_adventure()) = 0,
                  'one account read another''s adventure');
reset role;
select as_user(:'A'); set role authenticated;
select check_that(my_adventure() = '{3,3,2,3}'::smallint[],
                  'the adventure kept on the account is not the one saved');
reset role;

-- A search matches what was typed: `_` and `%` are not wildcards.
select as_user(:'B'); set role authenticated;
select check_that((select count(*) from find_lifters('dan_')) = 1,
                  'a search for a name with an underscore in it');
select check_that((select count(*) from find_lifters('d_n')) = 0,
                  'an underscore in a search matched any letter');
select check_that((select count(*) from find_lifters('%%')) = 0,
                  'a search for %% listed people');
reset role;
select as_user(:'A'); set role authenticated;
select check_that((select count(*) from leaderboard()) >= 0, 'leaderboard');
select must_fail('calling the rate counter directly',
                 $q$select within_rate('data_export', interval '1 day', 99)$q$);
select check_that(claim_data_export() and claim_data_export() and claim_data_export()
                  and not claim_data_export(),
                  'the data export could be emailed more than three times a day');
reset role;

-- ── avatars ───────────────────────────────────────────────────────────────────

select as_user(:'A'); set role authenticated;
select must_fail('a file under any other name in the public bucket',
  $q$insert into storage.objects (bucket_id, name)
     values ('avatars', '00000000-0000-0000-0000-00000000000a/free-hosting.mp4')$q$);
insert into storage.objects (bucket_id, name)
values ('avatars', :'A' || '/photo.jpg');
reset role;
select as_user(:'B'); set role authenticated;
select check_that((select count(*) from storage.objects) = 0,
                  'one account could list everybody''s photos');
reset role;

-- ── live invites ──────────────────────────────────────────────────────────────

-- B turned live invites off: the invite is made, nothing buzzes.
select as_user(:'B'); set role authenticated;
update profiles set notify_live_invite = false where id = auth.uid();
reset role;
select as_user(:'A'); set role authenticated;
select invite_live(:'B');
reset role;
select check_that((select count(*) from notifications
                    where profile_id = :'B' and kind = 'live_invite') = 0,
                  'a live invite pushed somebody who turned them off');
select as_user(:'B'); set role authenticated;
update profiles set notify_live_invite = true where id = auth.uid();
reset role;
select as_user(:'A'); set role authenticated;
select invite_live(:'B');
select invite_live(:'B');
select must_fail('a fourth live invite in ten minutes', format('select invite_live(%L)', :'B'));
reset role;
select check_that((select count(*) from notifications
                    where profile_id = :'B' and kind = 'live_invite') = 2,
                  'live invites with notices on did not reach them');

-- ── removing a friend ─────────────────────────────────────────────────────────

select as_user(:'A'); set role authenticated;
select check_that(remove_friend(:'B') = 'removed', 'removing a friend');
select check_that((select count(*) from my_friends()) = 0,
                  'a removed friend is still on the list');
select check_that(remove_friend(:'C') = 'not friends',
                  'removing somebody who was never a friend');
reset role;

-- ── the paywall switch ────────────────────────────────────────────────────────

-- Off, as installed: everybody may play.
select check_that(not paywall_enforced(), 'the paywall was on straight after install');
update server_switches set enabled = true where name = 'paywall_enforced';
select as_user(:'B'); set role authenticated;
select check_that(not has_pro(:'B'),
                  'enforcement on, and an account with no subscription played');
-- A row a lifter cannot see, and a switch a lifter cannot flip.
select check_that((select count(*) from server_switches) = 0,
                  'a lifter can read the server''s switches');
update server_switches set enabled = false where name = 'paywall_enforced';
reset role;
select check_that(paywall_enforced(), 'a lifter turned the paywall off');
insert into subscriptions (user_id, active, expires_at)
values (:'B', true, now() + interval '1 day');
select as_user(:'B'); set role authenticated;
select check_that(has_pro(:'B'), 'an active subscription did not count');
reset role;
update subscriptions set expires_at = now() - interval '2 hours' where user_id = :'B';
select as_user(:'B'); set role authenticated;
select check_that(not has_pro(:'B'), 'a subscription two hours lapsed still counted');
reset role;
update server_switches set enabled = false where name = 'paywall_enforced';
delete from subscriptions where user_id = :'B';

-- ── the monthly board ─────────────────────────────────────────────────────────

-- Placed, the way settle_duel would leave them: through its own flag, since
-- the guard on profiles lets nothing else touch the ladder columns.
select set_config('outrepd.settling', 'on', false);
update profiles set placements_done = 5 where id in (:'A', :'B');
select set_config('outrepd.settling', 'off', false);
-- Last month: twenty duels A won against B's recorded set, twelve LP each.
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (:'A', 20, 20, 60000), (:'B', 10, 10, 60000);
insert into duels (created_at, challenger, defender, challenger_set,
                   defender_set, winner, ranked, lp_challenger, lp_defender)
select (date_trunc('month', now() at time zone 'UTC') at time zone 'UTC')
         - interval '3 days' + g * interval '1 minute',
       :'A'::uuid, :'B'::uuid,
       (select id from sets where profile_id = :'A' order by created_at desc limit 1),
       (select id from sets where profile_id = :'B' order by created_at desc limit 1),
       :'A'::uuid, true, 12, -12
  from generate_series(1, 20) g;

-- The first request of the month closes the last one.
select as_user(:'A'); set role authenticated;
select check_that((select count(*) from my_season_awards() where award = 'champion') = 1,
                  'last month''s winner was not named Champion');
select check_that((select count(*) from my_season_awards() where award = 'regular') = 1,
                  'twenty duels in a month did not earn the badge');
reset role;
select as_user(:'B'); set role authenticated;
-- Raced twenty times while away: points lost, but no duel of theirs played.
select check_that((select count(*) from my_season_awards()) = 0,
                  'a month of losses was rewarded');
select check_that((select count(*) from season_awards) = 0,
                  'a lifter can read the awards table');
select check_that((select count(*) from lifter_season_awards(:'A')) = 2,
                  'another lifter''s awards are not on their card');
select must_fail('a lifter closing a month', 'select close_finished_seasons()');
select must_fail('a lifter reading the raw standings',
                 'select * from season_standings(current_date)');
reset role;
select close_finished_seasons();
select check_that((select count(*) from season_awards) = 2, 'a month was closed twice');

-- This month: the board's points are this month's LP, and it is in order.
select as_user(:'A'); set role authenticated;
select check_that(
  (select points from my_month_place()) = coalesce((
    select sum(lp) from (
      select lp_challenger as lp from duels
       where ranked and challenger = :'A'
         and created_at >= date_trunc('month', now() at time zone 'UTC') at time zone 'UTC'
      union all
      select lp_defender from duels
       where ranked and defender = :'A'
         and created_at >= date_trunc('month', now() at time zone 'UTC') at time zone 'UTC'
    ) x), 0),
  'this month''s points are not the LP of this month''s duels');
select check_that(not exists (
  select 1 from (select points, lag(points) over (order by place) as before
                   from month_board()) b
   where b.before < b.points), 'the monthly board is out of order');
reset role;

-- ── the same two lifters, again and again ─────────────────────────────────────

-- A and D have met twice today already. There used to be a cap of two ranked
-- a day between the same two; every ranked one counts now.
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (:'A', 10, 10, 60000), (:'D', 10, 10, 60000);
insert into duels (challenger, defender, challenger_set, defender_set,
                   winner, ranked, lp_challenger, lp_defender)
select :'A'::uuid, :'D'::uuid,
       (select id from sets where profile_id = :'A' order by created_at desc limit 1),
       (select id from sets where profile_id = :'D' order by created_at desc limit 1),
       :'A'::uuid, true, 5, -5
  from generate_series(1, 2);
-- A third time, handed over the honest way: it settles, and pays.
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (:'D', 0, 0, 60000);
select set_config('test.d3',
  (select id::text from sets where profile_id = :'D' order by created_at desc limit 1), false);
insert into set_offers (set_id, offered_to) values (current_setting('test.d3')::uuid, :'A');
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (:'A', 40, 40, 60000);
select set_config('test.a3',
  (select id::text from sets where profile_id = :'A' order by created_at desc limit 1), false);
select as_user(:'A'); set role authenticated;
select check_that(
  (select lp_delta <> 0 and was_ranked
     from settle_duel(current_setting('test.a3')::uuid,
                      current_setting('test.d3')::uuid, true)),
  'a third ranked duel in a day between the same two paid nothing');
reset role;
select check_that(
  (select ranked from duels where challenger_set = current_setting('test.a3')::uuid),
  'a third duel in a day between the same two was not ranked');

-- ── the week's board ───────────────────────────────────────────────────────────

select as_user(:'A'); set role authenticated;
select check_that((select count(*) >= 0 from week_board()), 'week_board');
select check_that((select played >= 0 from my_week_place()), 'my_week_place');
select must_fail('reading week_points directly',
  'select * from week_points(now() - interval ''7 days'')');
reset role;

-- ── the live search ───────────────────────────────────────────────────────────

select check_that(live_reach(0) = 2 and live_reach(7) = 6 and live_reach(20) = 12,
                  'the live search does not widen with the wait');
select as_user(:'A'); set role authenticated;
select check_that((select searching >= 0 and online >= 0 from live_online()),
                  'live_online');
select count(*) from find_live_opponent();
select leave_live_queue();
reset role;

-- Met three times today, both searching: they are paired, and A is told who
-- with their picture.
update profiles set avatar_url = 'https://example.com/d.jpg' where id = :'D';
insert into live_queue (profile_id, level)
select :'D'::uuid, ladder_level(tier_idx, div_idx) from profiles where id = :'A';
select as_user(:'A'); set role authenticated;
select check_that(
  (select opponent_id = :'D'::uuid and opponent_avatar = 'https://example.com/d.jpg'
     from find_live_opponent()),
  'two who met today were not paired, or the opponent came without a picture');
reset role;
update live_matches set status = 'cancelled'
 where a = :'A' and b = :'D' and status = 'ready';

-- ── the live rematch ──────────────────────────────────────────────────────────

-- A and D finished a ranked live match a couple of minutes ago — their
-- third meeting today, after the two ranked duels above.
insert into live_matches (ranked, a, b, status, starts_at)
values (true, :'A', :'D', 'done', now() - interval '2 minutes');
select set_config('test.lm',
  (select id::text from live_matches
    where a = :'A' and b = :'D' and status = 'done'
    order by created_at desc limit 1), false);

select as_user(:'C'); set role authenticated;
select must_fail('a rematch of somebody else''s match',
                 format('select * from rematch_live(%L)', current_setting('test.lm')));
reset role;

select as_user(:'A'); set role authenticated;
select check_that(
  (select match_status = 'invited' and is_ranked
     from rematch_live(current_setting('test.lm')::uuid)),
  'a rematch of a ranked match was not offered as ranked');
select count(*) from rematch_live(current_setting('test.lm')::uuid);
reset role;
select check_that((select count(*) from live_matches
                    where rematch_of = current_setting('test.lm')::uuid) = 1,
                  'asking for the same rematch twice sent two');

-- D asks too: that is the yes, and it starts.
select as_user(:'D'); set role authenticated;
select check_that(
  (select match_status = 'ready'
     from rematch_live(current_setting('test.lm')::uuid)),
  'both asking for a rematch did not start it');
reset role;

-- Only straight after a finished match.
insert into live_matches (ranked, a, b, status, starts_at)
values (true, :'A', :'C', 'done', now() - interval '1 hour'),
       (true, :'A', :'C', 'live', now() - interval '20 seconds');
select as_user(:'A'); set role authenticated;
select must_fail('a rematch of a match an hour old',
  format('select * from rematch_live(%L)',
    (select id from live_matches where a = :'A' and b = :'C' and status = 'done')));
select must_fail('a rematch of a match still running',
  format('select * from rematch_live(%L)',
    (select id from live_matches where a = :'A' and b = :'C' and status = 'live')));
reset role;

-- Not with somebody either of them blocked.
insert into live_matches (ranked, a, b, status, starts_at)
values (false, :'C', :'A', 'done', now() - interval '1 minute');
insert into blocks (blocker, blocked) values (:'C', :'A');
select as_user(:'A'); set role authenticated;
select must_fail('a rematch with somebody who blocked you',
  format('select * from rematch_live(%L)',
    (select id from live_matches where a = :'C' and b = :'A' and status = 'done')));
reset role;
delete from blocks where blocker = :'C' and blocked = :'A';

-- On the result screen each sees whether the other is still there, and once
-- one has left the other cannot ask them for a rematch.
insert into live_matches (ranked, a, b, status, starts_at)
values (false, :'B', :'D', 'done', now() - interval '70 seconds');
select set_config('test.lr',
  (select id::text from live_matches
    where a = :'B' and b = :'D' and status = 'done'
    order by created_at desc limit 1), false);
select as_user(:'C'); set role authenticated;
select must_fail('somebody else''s result screen',
  format('select live_result_presence(%L)', current_setting('test.lr')));
reset role;
select as_user(:'B'); set role authenticated;
select check_that(live_result_presence(current_setting('test.lr')::uuid) = 'waiting',
                  'the other one, not on the result screen yet, read as something else');
reset role;
select as_user(:'D'); set role authenticated;
select check_that(live_result_presence(current_setting('test.lr')::uuid) = 'here',
                  'the one on the result screen was not seen there');
reset role;
select as_user(:'B'); set role authenticated;
select check_that(live_result_presence(current_setting('test.lr')::uuid, true) = 'here',
                  'leaving the result screen');
reset role;
select as_user(:'D'); set role authenticated;
select check_that(live_result_presence(current_setting('test.lr')::uuid) = 'left',
                  'the one who left still read as there');
select must_fail('a rematch with somebody who left',
  format('select * from rematch_live(%L)', current_setting('test.lr')));
reset role;

-- ── the export ───────────────────────────────────────────────────────────────

select as_user(:'D'); set role authenticated;
select check_that(my_data() ? 'month_awards' and my_data() ? 'live_matches',
                  'the export left out month awards or live matches');
reset role;

-- ── closed-test testers ───────────────────────────────────────────────────────

-- The trigger on auth.users runs inside every sign-up, as whatever role the
-- auth server uses. It must work for a role that has no EXECUTE on it —
-- Postgres checks that when a trigger is made, not when it fires — and it
-- must never be the reason a sign-up fails.
do $$
begin
  create role auth_server_like nologin;
exception when duplicate_object then
  null;
end;
$$;
grant usage on schema auth to auth_server_like;
grant select, update on auth.users to auth_server_like;
insert into beta_testers (email) values ('tester@example.com');
set role auth_server_like;
update auth.users set email_change = 'tester@example.com' where id = :'D';
update auth.users set email_change = null where id = :'D';
reset role;
select check_that(true, 'a sign-up with a tester''s email went through');
-- An address with capitals in it is refused rather than stored unmatched.
select must_fail('a tester listed with capitals',
                 'insert into beta_testers (email) values (''Someone@Example.com'')');

select as_user(:'A'); set role authenticated;
select must_fail('a lifter handing out tester passes',
                 format('select grant_tester_pro(%L)', :'A'));
select check_that((select count(*) from beta_testers) = 0,
                  'a lifter can read the tester list');
select must_fail('a lifter putting themselves on the tester list',
                 'insert into beta_testers (email) values (''a@example.com'')');
reset role;
delete from beta_testers;

-- ── experience ────────────────────────────────────────────────────────────────

select as_user(:'A'); set role authenticated;
select must_fail('raising your own experience',
                 'update profiles set xp = xp + 1000 where id = auth.uid()');
reset role;

-- A friendly live match between B and C: each is paid their reps and twenty
-- for playing it, the one who lost as much as the one who won.
select set_config('test.xp_b', (select xp::text from profiles where id = :'B'), false);
select set_config('test.xp_c', (select xp::text from profiles where id = :'C'), false);
insert into live_matches (ranked, a, b, status, starts_at)
values (false, :'B', :'C', 'live', now() - interval '65 seconds');
select set_config('test.lm_xp',
  (select id::text from live_matches
    where a = :'B' and b = :'C' and status = 'live'), false);
select as_user(:'B'); set role authenticated;
select count(*) from finish_live_match(current_setting('test.lm_xp')::uuid,
                                       12, 12, 0.3, true, 60000, false, '{}');
reset role;
select as_user(:'C'); set role authenticated;
select check_that(
  (select is_settled from finish_live_match(current_setting('test.lm_xp')::uuid,
                                            8, 8, 0.3, true, 60000, false, '{}')),
  'a live match with both sets in did not settle');
reset role;
select check_that(
  (select xp from profiles where id = :'B') = current_setting('test.xp_b')::int + 12 + 20,
  'the winner of a live match was not paid their reps and twenty');
select check_that(
  (select xp from profiles where id = :'C') = current_setting('test.xp_c')::int + 8 + 20,
  'the loser of a live match was not paid their reps and twenty');

-- Practice: the reps count, and nothing else happens to the set.
select set_config('test.xp_a', (select xp::text from profiles where id = :'A'), false);
select pg_sleep(8.5);
select as_user(:'A'); set role authenticated;
select must_fail('a practice set sent as a challenge',
  format($q$insert into sets (profile_id, reps, reps_camera, duration_ms,
                              practice, challenge_target)
            values (auth.uid(), 10, 10, 60000, true, %L)$q$, :'B'));
insert into sets (profile_id, reps, reps_camera, duration_ms, practice)
values (auth.uid(), 25, 25, 60000, true);
reset role;
select check_that(
  (select xp from profiles where id = :'A') = current_setting('test.xp_a')::int + 25,
  'a practice set was not paid its reps');
select set_config('test.practice',
  (select id::text from sets where profile_id = :'A' and practice limit 1), false);
select as_user(:'C'); set role authenticated;
select check_that(
  not exists (select 1 from find_opponent_set(1000)
               where set_id = current_setting('test.practice')::uuid),
  'the pool handed out a practice set');
reset role;
select pg_sleep(8.5);
select as_user(:'C'); set role authenticated;
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (auth.uid(), 20, 20, 60000);
select must_fail('racing a practice set',
  format('select settle_duel(%L, %L, false)',
         (select id from sets where profile_id = auth.uid()
           order by created_at desc limit 1),
         current_setting('test.practice')));
reset role;

-- Everybody, after everything above: one for every rep, twenty for every
-- match they played, and nothing for a set raced while they were away. The
-- same sum the install works out for accounts from before experience.
select check_that(count(*) = 0,
                  'experience off for: ' || coalesce(string_agg(p.username, ', '), ''))
  from profiles p
 where p.xp <> p.total_reps + 20 * (
         (select count(*) from duels d where d.challenger = p.id)
         + (select count(*) from duels d
              join live_matches m on m.duel = d.id
             where d.defender = p.id));

-- ── signed out ────────────────────────────────────────────────────────────────

-- A request with no session runs as anon. It may draw the website's share
-- card and nothing else. Read off the catalogue rather than function by
-- function, so one added later and never closed fails here, not in use.
select check_that(count(*) = 0,
                  'signed out, these functions can still be called: '
                  || coalesce(string_agg(p.proname, ', '), ''))
  from pg_proc p
  join pg_namespace n on n.oid = p.pronamespace
 where n.nspname = 'public'
   and has_function_privilege('anon', p.oid, 'execute')
   -- The share card, and this file's own helpers.
   and p.proname not in ('public_lifter_card', 'as_user', 'must_fail', 'check_that');

select check_that(count(*) = 0,
                  'signed out, these tables still allow something: '
                  || coalesce(string_agg(c.relname, ', '), ''))
  from pg_class c
  join pg_namespace n on n.oid = c.relnamespace
 where n.nspname = 'public'
   and c.relkind in ('r', 'p', 'v', 'm')
   and (has_table_privilege('anon', c.oid, 'select')
     or has_table_privilege('anon', c.oid, 'insert')
     or has_table_privilege('anon', c.oid, 'update')
     or has_table_privilege('anon', c.oid, 'delete'));

-- And as a request would actually try it.
select as_user(null); set role anon;
select must_fail('signed out, a lifter''s profile',
                 format('select * from lifter_profile(%L)', :'B'));
select must_fail('signed out, somebody''s recorded set',
                 'select * from find_opponent_set()');
select must_fail('signed out, whether a name is taken',
                 'select username_available(''alice_a1'')');
select must_fail('signed out, the profiles table', 'select * from profiles');
-- The one thing that is meant to work signed out.
select count(*) from public_lifter_card('alice_a1');
reset role;

select 'all security checks passed' as result;
