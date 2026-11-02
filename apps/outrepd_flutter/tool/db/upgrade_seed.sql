-- Accounts and duels on the live project's server (tool/db/live/install.sql),
-- the way they are there: ranks written by settle_duel, duels from last month
-- and from this one. Today's installer is pasted over this, and
-- upgrade_check.sql says whether everything came through.
\set ON_ERROR_STOP 1
\set A '00000000-0000-0000-0000-0000000000a1'
\set B '00000000-0000-0000-0000-0000000000b1'
\set C '00000000-0000-0000-0000-0000000000c1'
\set E '00000000-0000-0000-0000-0000000000e1'

create or replace function as_user(who uuid) returns void
language sql
as $$ select set_config('request.jwt.claim.sub', coalesce(who::text, ''), false) $$;

-- Each account made by itself, the way the app makes one.
insert into auth.users (id) values (:'A'), (:'B'), (:'C'), (:'E');
select as_user(:'A'); set role authenticated;
insert into profiles (id, username, country) values (:'A', 'alice_up', 'EG');
reset role;
select as_user(:'B'); set role authenticated;
insert into profiles (id, username, country) values (:'B', 'bob_up', 'US');
reset role;
select as_user(:'C'); set role authenticated;
insert into profiles (id, username, country) values (:'C', 'carol_up', 'FR');
reset role;
select as_user(:'E'); set role authenticated;
insert into profiles (id, username, country) values (:'E', 'erin_up', 'EG');
reset role;
select as_user(null);

-- Ranks, through the flag settle_duel uses: Gold III with 64 LP, Bronze V
-- with 10, one still unplaced, and one at the top of the ladder.
select set_config('outrepd.settling', 'on', false);
update profiles set placements_done = 5, tier_idx = 3, div_idx = 2, lp = 64,
                    peak_tier_idx = 3, wins = 10, losses = 4, win_streak = 2
 where id = :'A';
update profiles set placements_done = 5, tier_idx = 1, div_idx = 0, lp = 10,
                    peak_tier_idx = 2, wins = 3, losses = 7
 where id = :'B';
update profiles set placements_done = 5, tier_idx = 6, div_idx = 4, lp = 99,
                    peak_tier_idx = 6, wins = 90, losses = 10
 where id = :'E';
select set_config('outrepd.settling', 'off', false);

insert into sets (profile_id, reps, reps_camera, duration_ms)
values (:'A', 20, 20, 60000), (:'B', 12, 12, 60000);

-- Last month, before any week that could still be running: A beat B, 12 LP.
insert into duels (created_at, challenger, defender, challenger_set,
                   defender_set, winner, ranked, lp_challenger, lp_defender)
select (date_trunc('month', now() at time zone 'UTC') at time zone 'UTC')
         - interval '10 days',
       :'A'::uuid, :'B'::uuid,
       (select id from sets where profile_id = :'A' limit 1),
       (select id from sets where profile_id = :'B' limit 1),
       :'A'::uuid, true, 12, -12;

-- This month, the last few minutes: A beats B three times, then B beats A.
-- Under the rules from 2026-11-02 that is 5, 5, 10, -2 for A and -2, -2,
-- -2, 5 for B — 18 and 5 on the boards, B floored at nought on the way.
insert into duels (created_at, challenger, defender, challenger_set,
                   defender_set, winner, ranked, lp_challenger, lp_defender)
select now() - (5 - g) * interval '1 minute',
       :'A'::uuid, :'B'::uuid,
       (select id from sets where profile_id = :'A' limit 1),
       (select id from sets where profile_id = :'B' limit 1),
       case when g < 4 then :'A'::uuid else :'B'::uuid end,
       true,
       case when g < 4 then 8 else -8 end,
       case when g < 4 then -8 else 8 end
  from generate_series(1, 4) g;
