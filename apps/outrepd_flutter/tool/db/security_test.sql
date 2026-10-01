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
insert into profiles (id, username, country, tier_idx, wins)
values (:'D', 'dan_d1', 'EG', 6, 999);
reset role;

select check_that((select username from profiles where id = :'C') like 'lifter%',
                  'a name with a space in it was stored as typed');
select check_that((select tier_idx = 0 and wins = 0 from profiles where id = :'D'),
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
select check_that(set_my_username('Alice2') = 'ok', 'renaming');
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

select as_user(:'A'); set role authenticated;
select invite_live(:'B');
select invite_live(:'B');
select invite_live(:'B');
select must_fail('a fourth live invite in ten minutes', format('select invite_live(%L)', :'B'));
reset role;

select 'all security checks passed' as result;
