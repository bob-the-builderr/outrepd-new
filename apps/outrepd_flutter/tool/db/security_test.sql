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
-- And the photo's small copy for the boards, beside it.
insert into storage.objects (bucket_id, name)
values ('avatars', :'A' || '/thumb.jpg');
select must_fail('a small copy in another account''s folder',
  $q$insert into storage.objects (bucket_id, name)
     values ('avatars', '00000000-0000-0000-0000-00000000000b/thumb.jpg')$q$);
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
-- Last month's top ten, for the new month's empty board: A alone, first.
select check_that((select count(*) from last_month_winners()) = 1,
                  'last month''s winners are not the ones with a place');
select check_that((select id from last_month_winners() where place = 1) = :'A',
                  'last month''s champion is not first among its winners');
select must_fail('a lifter closing a month', 'select close_finished_seasons()');
select must_fail('a lifter reading the raw standings',
                 'select * from season_standings(current_date)');
reset role;
select close_finished_seasons();
select check_that((select count(*) from season_awards) = 2, 'a month was closed twice');

-- This month: the running totals are what the month's duels add up to when
-- added up again from scratch, and the board is in order.
select set_config('test.month_pts', coalesce((
  select points from season_points_from_duels(season_of(now()))
   where profile_id = :'A'), 0)::text, false);
select as_user(:'A'); set role authenticated;
select check_that(
  (select points from my_month_place()) = current_setting('test.month_pts')::int,
  'this month''s points are not what this month''s duels add up to');
select check_that((select points >= 0 from my_month_place()),
  'this month''s points went below nought');
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
-- It paid the rating's rule (2026-11-02): 25 and the gap to the winner, 20
-- and the gap off the loser, and the boards' points to both.
select check_that(
  (select lp_challenger = 25 + 40
     from duels where challenger_set = current_setting('test.a3')::uuid),
  'a ranked win did not pay 25 and the gap');
select check_that(
  (select pts_challenger in (0, 5, 10) and pts_defender = -2
     from duels where challenger_set = current_setting('test.a3')::uuid),
  'a ranked duel did not give the boards 5 or 10 for the win and 2 off for the loss');
-- Two wins already in a row: this one is the third. (0 past the day's twenty.)
select check_that(board_points(true, 2, :'A') in (0, 10) and board_points(true, 1, :'A') in (0, 5)
                  and board_points(true, 0, :'A') in (0, 5) and board_points(false, 2, :'A') in (0, -2),
  'the third win in a row is not worth 10');

-- ── the week's board ───────────────────────────────────────────────────────────

select as_user(:'A'); set role authenticated;
select check_that((select count(*) >= 0 from week_board()), 'week_board');
select check_that((select played >= 0 from my_week_place()), 'my_week_place');
select must_fail('reading week_points directly',
  'select * from week_points(now() - interval ''7 days'')');
reset role;

-- ── the boards among friends ──────────────────────────────────────────────────

-- A and B are friends; D, whom A has duelled all day, is not, nor is C.
select as_user(:'A'); set role authenticated;
select check_that(not exists (select 1 from friends_board()
                               where id not in (:'A', :'B')),
  'the week among friends shows somebody who is not a friend');
select check_that(not exists (select 1 from friends_board(true)
                               where id not in (:'A', :'B')),
  'the month among friends shows somebody who is not a friend');
select check_that(not exists (select 1 from friends_leaderboard()
                               where id not in (:'A', :'B')),
  'the rating among friends shows somebody who is not a friend');
-- The caller is on their own circle's board, by the whole board's rules,
-- with the points the whole board gives them.
select check_that(
  (select placements_done < 5 or not show_on_board from profiles where id = :'A')
  or exists (select 1 from friends_board(true) where id = :'A'),
  'the month among friends leaves out the one asking');
select check_that(not exists (
  select 1 from friends_board(true)
   where id = :'A' and points <> (select points from my_month_place())),
  'the month among friends counts other points than the month''s');
select check_that(not exists (
  select 1 from friends_board()
   where id = :'A' and points <> (select points from my_week_place())),
  'the week among friends counts other points than the week''s');
select check_that(not exists (
  select 1 from (select points, lag(points) over (order by place) as before
                   from friends_board(true)) b
   where b.before < b.points), 'the month among friends is out of order');
select must_fail('reading the circle directly', 'select * from my_circle()');
reset role;
select as_user(:'C'); set role authenticated;
select check_that(not exists (select 1 from friends_board()
                               where id in (:'A', :'B', :'D')),
  'a lifter with no friends sees other people on their friends board');
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

-- A friendly live match between B and C: the winner is paid their reps and
-- twenty, the one who lost nothing at all.
select set_config('test.xp_b', (select xp::text from profiles where id = :'B'), false);
select set_config('test.xp_c', (select xp::text from profiles where id = :'C'), false);
select set_config('test.reps_c', (select total_reps::text from profiles where id = :'C'), false);
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
  (select xp from profiles where id = :'C') = current_setting('test.xp_c')::int,
  'the loser of a live match was paid experience');
select check_that(
  (select total_reps from profiles where id = :'C') = current_setting('test.reps_c')::int + 8,
  'the loser''s reps went missing from their total');

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
-- match they won, the reps of every match they lost taken back, and nothing
-- either way for a set raced while they were away. The same sum the install
-- works out for accounts from before experience.
select check_that(count(*) = 0,
                  'experience off for: ' || coalesce(string_agg(p.username, ', '), ''))
  from profiles p
 where p.xp <> (
         with played as (
           select d.challenger as id, d.challenger_set as set_id, d.winner
             from duels d
           union all
           select d.defender, d.defender_set, d.winner
             from duels d
             join live_matches m on m.duel = d.id
         )
         select p.total_reps
                + 20 * (select count(*) from played x
                         where x.id = p.id
                           and (x.winner is null or x.winner = p.id))
                - coalesce((select sum(s.reps) from played x
                              join sets s on s.id = x.set_id
                             where x.id = p.id
                               and x.winner is not null
                               and x.winner <> p.id), 0));

-- ── signed out ────────────────────────────────────────────────────────────────

-- How people look: A's lifter and cover read by B; the cover only while A
-- is Pro; nobody's cover can point at somebody else's file.
select as_user(:'A'); set role authenticated;
update profiles set lifter = '{"v":1,"skin":"tan"}', cover = 'neon_city' where id = :'A';
-- The four scenes added after 1.1.6 went live.
update profiles set cover = 'fireworks' where id = :'A';
update profiles set cover = 'champion_podium' where id = :'A';
update profiles set cover = 'neon_city' where id = :'A';
select must_fail('a cover that is not one of the scenes',
                 format('update profiles set cover = %L where id = %L', 'my_site', :'A'));
select must_fail('a cover from another account''s folder',
                 format('update profiles set cover = %L where id = %L',
                        'https://x.supabase.co/storage/v1/object/public/avatars/' || :'B' || '/cover.jpg', :'A'));
select must_fail('a lifter too big to be one',
                 format('update profiles set lifter = %L where id = %L',
                        jsonb_build_object('junk', repeat('x', 4000)), :'A'));
reset role;
select as_user(:'B'); set role authenticated;
select check_that((select lifter->>'skin' from pro_looks(array[:'A'::uuid])) = 'tan',
                  'another lifter''s lifter cannot be read');
select check_that((select not pro and cover is null from pro_looks(array[:'A'::uuid])),
                  'a cover shows without Pro');
reset role;
insert into subscriptions (user_id, active, expires_at)
  values (:'A', true, now() + interval '7 days')
  on conflict (user_id) do update set active = true, expires_at = excluded.expires_at;
select as_user(:'B'); set role authenticated;
select check_that((select pro and cover = 'neon_city' from pro_looks(array[:'A'::uuid])),
                  'a Pro lifter''s cover does not show');
reset role;
delete from subscriptions where user_id = :'A';

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
   -- The share card, the challenge card (challenge.sql), and this file's own
   -- helpers.
   and p.proname not in ('public_lifter_card', 'public_challenge_card',
                         'as_user', 'must_fail', 'check_that');

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

-- ── a friend passing you this week ────────────────────────────────────────────

-- A and B are friends. B scores this week; then A wins enough to pass B. B is
-- told, once; a second pass the same day is not told again.
insert into friendships (requester, addressee, accepted_at)
select :'A', :'B', now()
 where not exists (select 1 from friendships
                    where (requester = :'A' and addressee = :'B')
                       or (requester = :'B' and addressee = :'A'));
update friendships set accepted_at = coalesce(accepted_at, now())
 where (requester = :'A' and addressee = :'B') or (requester = :'B' and addressee = :'A');
delete from notifications where profile_id = :'B' and kind = 'passed';
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (:'A', 30, 30, 60000), (:'B', 30, 30, 60000), (:'D', 5, 5, 60000);
select set_config('test.gap', greatest(
  week_points_of(:'A', week_start(now())) - week_points_of(:'B', week_start(now())) + 40,
  1)::text, false);
insert into duels (challenger, defender, challenger_set, defender_set,
                   winner, ranked, lp_challenger, lp_defender,
                   pts_challenger, pts_defender)
values (:'B', :'D',
        (select id from sets where profile_id = :'B' order by created_at desc limit 1),
        (select id from sets where profile_id = :'D' order by created_at desc limit 1),
        :'B', true, 0, 0, current_setting('test.gap')::int, 0);
select check_that(week_points_of(:'B', week_start(now()))
                    > week_points_of(:'A', week_start(now())),
                  'the test could not put B ahead of A this week');
select set_config('test.gap', (
  week_points_of(:'B', week_start(now())) - week_points_of(:'A', week_start(now())) + 5
)::text, false);
insert into duels (challenger, defender, challenger_set, defender_set,
                   winner, ranked, lp_challenger, lp_defender,
                   pts_challenger, pts_defender)
values (:'A', :'D',
        (select id from sets where profile_id = :'A' order by created_at desc limit 1),
        (select id from sets where profile_id = :'D' order by created_at desc limit 1),
        :'A', true, 0, 0, current_setting('test.gap')::int, 0);
select check_that(exists (select 1 from notifications
                           where profile_id = :'B' and kind = 'passed' and actor = :'A'),
                  'a friend passing you this week was not told');
-- B takes it back, and A passes again: not told twice in a day.
insert into duels (challenger, defender, challenger_set, defender_set,
                   winner, ranked, lp_challenger, lp_defender,
                   pts_challenger, pts_defender)
values (:'B', :'D',
        (select id from sets where profile_id = :'B' order by created_at desc limit 1),
        (select id from sets where profile_id = :'D' order by created_at desc limit 1),
        :'B', true, 0, 0, 20, 0);
insert into duels (challenger, defender, challenger_set, defender_set,
                   winner, ranked, lp_challenger, lp_defender,
                   pts_challenger, pts_defender)
values (:'A', :'D',
        (select id from sets where profile_id = :'A' order by created_at desc limit 1),
        (select id from sets where profile_id = :'D' order by created_at desc limit 1),
        :'A', true, 0, 0, 40, 0);
select check_that((select count(*) from notifications
                    where profile_id = :'B' and kind = 'passed' and actor = :'A') = 1,
                  'being passed by the same friend was told twice in a day');
-- An app from before it knew the notice does not see it in its list.
select as_user(:'B'); set role authenticated;
select check_that(not exists (select 1 from my_notifications() where kind = 'passed'),
                  'an older app was shown a notice it cannot read');
select check_that(exists (select 1 from my_notifications(50, true) where kind = 'passed'),
                  'the app that knows it was not shown being passed');
reset role;

-- ── a challenge by link ───────────────────────────────────────────────────────

-- A's whole minute, sent as a link, and a set given up after twenty seconds,
-- which cannot be. Put in as the owner, past the guard's eight seconds.
insert into sets (profile_id, reps, reps_camera, duration_ms, rep_times)
values (:'A', 20, 20, 60000, array(select g * 2900 from generate_series(1, 20) g));
select id as challenge_set from sets where profile_id = :'A' order by created_at desc limit 1 \gset
insert into sets (profile_id, reps, reps_camera, duration_ms, rep_times, gave_up)
values (:'A', 9, 9, 20000, array(select g * 2000 from generate_series(1, 9) g), true);
select id as short_set from sets where profile_id = :'A' order by created_at desc limit 1 \gset
select as_user(:'A'); set role authenticated;
select check_that(make_challenge(:'short_set') is null,
                  'a set given up after twenty seconds was sent as a challenge');
select make_challenge(:'challenge_set')->>'code' as code \gset
select check_that(:'code' ~ '^[2-9a-hjkmnp-z]{6}$', 'a challenge code came out in the wrong shape');
select check_that(make_challenge(:'challenge_set')->>'code' = :'code',
                  'the same set sent twice made two links');
select check_that(make_challenge()->>'code' = :'code',
                  'the set just lifted was not the one sent');
select check_that(not exists (select 1 from challenges), 'a phone read the challenges table');
select check_that(not exists (select 1 from challenge_takes), 'a phone read the tries table');
select must_fail('writing a challenge straight into the table',
                 format('insert into challenges (code, set_id, owner, reps) values (''zzzzzz'', %L, %L, 300)',
                        :'challenge_set', :'A'));
select must_fail('a try at your own challenge',
                 format('select take_challenge(%L, %L)', :'code', :'short_set'));
reset role;

-- B lifts a minute for it, after it was made. B's rank before, to compare.
select tier_idx as b_tier, div_idx as b_div, lp as b_lp, wins as b_wins,
       losses as b_losses from profiles where id = :'B' \gset
insert into sets (profile_id, reps, reps_camera, duration_ms, rep_times, practice)
values (:'B', 22, 22, 60000, array(select g * 2600 from generate_series(1, 22) g), true);
select id as b_set from sets where profile_id = :'B' order by created_at desc limit 1 \gset
select as_user(:'A'); set role authenticated;
select check_that(make_challenge(:'b_set') is null,
                  'a challenge was made out of somebody else''s set');
reset role;
select as_user(:'B'); set role authenticated;
select check_that((open_challenge(:'code')->>'reps')::int = 20, 'a challenge opened with the wrong number');
select check_that(open_challenge('nope42') is null, 'a code nobody made opened something');
select must_fail('a try with somebody else''s set',
                 format('select take_challenge(%L, %L)', :'code', :'challenge_set'));
select check_that((take_challenge(:'code', :'b_set')->>'taken')::int = 22, 'a try was not written');
select must_fail('a second try at the same challenge',
                 format('select take_challenge(%L, %L)', :'code', :'b_set'));
select open_challenge(:'code')->>'take_id' as take_id \gset
select check_that(jsonb_array_length(open_challenge(:'code')->'board') = 2,
                  'the board did not show the owner and the try');
reset role;
select check_that((select tier_idx = :b_tier and div_idx = :b_div and lp = :b_lp
                          and wins = :b_wins and losses = :b_losses
                     from profiles where id = :'B'),
                  'a challenge moved a rank or a record');
select check_that(not exists (select 1 from duels
                               where challenger_set = :'b_set' or defender_set = :'b_set'),
                  'a challenge wrote a duel');
select check_that(exists (select 1 from notifications
                           where profile_id = :'A' and kind = 'challenge_taken'
                             and actor = :'B' and challenge_code = :'code'
                             and your_reps = 20 and their_reps = 22 and not you_won),
                  'the owner was not told their challenge was beaten');
-- An app from before challenges does not see the notice; one that knows does.
select as_user(:'A'); set role authenticated;
select check_that(not exists (select 1 from my_notifications(50, true) where kind = 'challenge_taken'),
                  'an older app was shown a challenge notice it cannot read');
select check_that(exists (select 1 from my_notifications(50, true, true) where kind = 'challenge_taken'),
                  'the app that knows challenges was not shown one');
select check_that(jsonb_array_length(my_challenges()) >= 1, 'the owner''s challenges did not list it');
-- The owner takes it back: a link to B's minute, which belongs to B.
select check_that(back_challenge(:'take_id')->>'code' is not null,
                  'the owner could not take a try back');
reset role;
select as_user(:'B'); set role authenticated;
select check_that(back_challenge(:'take_id')->>'code' is not null,
                  'the one who took it could not send it back');
select back_challenge(:'take_id');
reset role;
select check_that((select count(*) from notifications
                    where profile_id = :'A' and kind = 'challenge_back' and actor = :'B') = 1,
                  'sending a challenge back told the owner other than once');
select check_that((select owner from challenges where set_id = :'b_set') = :'B',
                  'the challenge on B''s minute did not belong to B');
select as_user(:'C'); set role authenticated;
select check_that(back_challenge(:'take_id') is null,
                  'a stranger turned somebody''s try into a challenge');
reset role;

-- Closed: no try.
insert into sets (profile_id, reps, reps_camera, duration_ms, rep_times, practice)
values (:'C', 15, 15, 60000, array(select g * 3500 from generate_series(1, 15) g), true);
select id as c_set from sets where profile_id = :'C' order by created_at desc limit 1 \gset
update challenges set expires_at = now() - interval '1 second' where code = :'code';
select as_user(:'C'); set role authenticated;
select must_fail('a try at a closed challenge',
                 format('select take_challenge(%L, %L)', :'code', :'c_set'));
reset role;
update challenges set expires_at = now() + interval '7 days' where code = :'code';

-- Blocked: not opened, no try.
insert into sets (profile_id, reps, reps_camera, duration_ms, rep_times, practice)
values (:'D', 12, 12, 60000, array(select g * 4000 from generate_series(1, 12) g), true);
select id as d_set from sets where profile_id = :'D' order by created_at desc limit 1 \gset
insert into blocks (blocker, blocked) values (:'D', :'A') on conflict do nothing;
select as_user(:'D'); set role authenticated;
select check_that(open_challenge(:'code') is null, 'a blocked account opened the challenge');
select must_fail('a try between blocked accounts',
                 format('select take_challenge(%L, %L)', :'code', :'d_set'));
reset role;
delete from blocks where blocker = :'D' and blocked = :'A';

-- ── what a rewarded video gives ──────────────────────────────────────────────

-- The match's XP twice: once, for the winner's own fresh duel only.
insert into sets (profile_id, reps, reps_camera, duration_ms)
values (:'A', 17, 17, 60000), (:'C', 9, 9, 60000);
insert into duels (challenger, defender, challenger_set, defender_set,
                   winner, ranked, lp_challenger, lp_defender,
                   pts_challenger, pts_defender)
values (:'A', :'C',
        (select id from sets where profile_id = :'A' order by created_at desc limit 1),
        (select id from sets where profile_id = :'C' order by created_at desc limit 1),
        :'A', false, 0, 0, 0, 0);
select id as xp_duel from duels where challenger = :'A' order by created_at desc limit 1 \gset
select xp as a_xp from profiles where id = :'A' \gset
select as_user(:'C'); set role authenticated;
select check_that(double_duel_xp(:'xp_duel') = 0, 'the side that was raced doubled a duel');
reset role;
select as_user(:'A'); set role authenticated;
select check_that(double_duel_xp(:'xp_duel') = 37, 'a won duel did not pay its XP again');
select check_that(double_duel_xp(:'xp_duel') = 0, 'a duel''s XP was doubled twice');
select must_fail('writing XP straight into the profile',
                 format('update profiles set xp = xp + 1000 where id = %L', :'A'));
reset role;
select check_that((select xp from profiles where id = :'A') = :a_xp + 37,
                  'doubling did not add exactly the match''s XP');

-- A Pro part for a day: worn, seen, and taken off for everybody after it.
select as_user(:'D'); set role authenticated;
update profiles set lifter = '{"v": 1, "hair": "flame", "skin": "tan"}'::jsonb where id = :'D';
select check_that(start_pro_trial('hair', 'flame', 'buzz') > now(), 'a day with a Pro part did not start');
select must_fail('a phone writing its own day with a Pro part',
                 format('update profiles set pro_trial = ''{"key":"hair","id":"flame","until":"2999-01-01"}''::jsonb where id = %L', :'D'));
select must_fail('a part key that is not a key', 'select start_pro_trial(''hair; drop'', ''flame'', null)');
reset role;
select as_user(:'A'); set role authenticated;
select check_that((select lifter ->> 'hair' from pro_looks(array[:'D'::uuid])) = 'flame',
                  'a Pro part worn for a day was not seen');
reset role;
-- As the server's own functions do: the guard lets only them write it.
select set_config('outrepd.settling', 'on', false);
update profiles set pro_trial = jsonb_set(pro_trial, '{until}', to_jsonb(now() - interval '1 minute'))
 where id = :'D';
select set_config('outrepd.settling', 'off', false);
select as_user(:'A'); set role authenticated;
select check_that((select lifter ->> 'hair' from pro_looks(array[:'D'::uuid])) = 'buzz',
                  'a Pro part stayed on after its day');
reset role;

-- A streak brought back is kept as the later of the two copies.
select check_that((rewards_merge('{"streakSaved": 100}'::jsonb, '{"streakSaved": 50}'::jsonb)
                   ->> 'streakSaved')::bigint = 100,
                  'when a streak was brought back was lost in the merge');

-- ── beat your past self ──────────────────────────────────────────────────────

-- A plan is kept as the phone sent it, cleaned to what a plan is.
select as_user(:'A'); set role authenticated;
select check_that((save_plan('{"start": 24, "goal": 36, "days": 3, "began": 20400, "sets": {"20401": 3, "x": 9}, "races": {"1": 26, "9": 5}}'::jsonb) -> 'sets')
                    = '{"20401": 3}'::jsonb,
                  'a plan kept a day that is not a day');
select check_that((my_plan() -> 'races') = '{"1": 26}'::jsonb, 'a plan kept a week that is not a week');
select must_fail('a goal under the start',
                 'select save_plan(''{"start": 24, "goal": 20, "days": 3, "began": 20400}''::jsonb)');
select must_fail('seven training days a week',
                 'select save_plan(''{"start": 24, "goal": 36, "days": 7, "began": 20400}''::jsonb)');
select check_that(not exists (select 1 from training_plans), 'a phone read the plans table');
select must_fail('writing a plan straight into the table',
                 format('insert into training_plans (profile_id, plan) values (%L, ''{}''::jsonb)', :'A'));
reset role;

-- Last week's you: the caller's own best whole minute in the week, with its pace.
insert into sets (profile_id, reps, reps_camera, duration_ms, rep_times, practice, created_at)
values (:'A', 27, 27, 60000, array(select g * 2000 from generate_series(1, 27) g), true, now() - interval '8 days'),
       (:'A', 31, 31, 60000, '{}', true, now() - interval '9 days'),
       (:'B', 40, 40, 60000, array(select g * 1400 from generate_series(1, 40) g), true, now() - interval '8 days');
select as_user(:'A'); set role authenticated;
select check_that((my_best_minute(now() - interval '14 days', now() - interval '7 days') ->> 'reps')::int = 27,
                  'last week''s best minute was not the caller''s own, with its pace');
select check_that(jsonb_array_length(my_best_minute(now() - interval '14 days', now() - interval '7 days') -> 'rep_times') = 27,
                  'last week''s best minute came without its pace');
select check_that(my_best_minute(now() - interval '6 days', now()) is null
                    or (my_best_minute(now() - interval '6 days', now()) ->> 'reps')::int <> 27,
                  'a minute from before the week was handed back as the week''s');
select save_plan(null);
select check_that(my_plan() is null, 'a stopped plan stayed');
reset role;

-- ── the month's recap ────────────────────────────────────────────────────────

-- The caller's own month: their sets and their duels, nobody else's.
select as_user(:'A'); set role authenticated;
select check_that((my_month_recap(now() - interval '14 days', now() + interval '1 minute') ->> 'reps')::int
                    >= 27 + 31,
                  'the month left out the caller''s own sets');
select check_that((my_month_recap(now() - interval '14 days', now() + interval '1 minute') ->> 'best')::int >= 27,
                  'the month''s best minute was missing');
select check_that((my_month_recap(now() - interval '7 days', now() + interval '1 minute') ->> 'best_before')::int >= 27,
                  'the best before the month was missing');
reset role;
select as_user(:'B'); set role authenticated;
select check_that((my_month_recap(now() - interval '9 days', now() - interval '7 days') ->> 'reps')::int = 40,
                  'one account''s month held another''s sets');
reset role;

-- And as a request would actually try it.
select as_user(null); set role anon;
select must_fail('signed out, a lifter''s profile',
                 format('select * from lifter_profile(%L)', :'B'));
select must_fail('signed out, somebody''s recorded set',
                 'select * from find_opponent_set()');
select must_fail('signed out, whether a name is taken',
                 'select username_available(''alice_a1'')');
select must_fail('signed out, the profiles table', 'select * from profiles');
select must_fail('signed out, how people look',
                 format('select * from pro_looks(array[%L::uuid])', :'A'));
select must_fail('signed out, a challenge',
                 format('select open_challenge(%L)', :'code'));
select must_fail('signed out, making a challenge', 'select make_challenge()');
select must_fail('signed out, a plan', 'select my_plan()');
select must_fail('signed out, a best minute', 'select my_best_minute(now() - interval ''7 days'', now())');
select must_fail('signed out, a month', 'select my_month_recap(now() - interval ''30 days'', now())');
-- The things that are meant to work signed out: what a shared link shows.
select count(*) from public_lifter_card('alice_a1');
select count(*) from public_challenge_card(:'code');
reset role;

select 'all security checks passed' as result;
