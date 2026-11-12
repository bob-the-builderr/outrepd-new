-- Never run against the real project. See README.md beside this file.
-- A crowd of lifters and a few months of what they did, for timing the
-- server's calls at the size the app is being readied for. How many:
--   psql -v n=100000 -f seed.sql      (ten thousand when n is not given)
-- Written straight into the tables with the triggers off: the guards and
-- counters are not what is being measured, and the totals they keep are
-- filled in directly.
\if :{?n}
\else
  \set n 10000
\endif
\timing on
set session_replication_role = replica;
select setseed(0.42);

insert into auth.users (id, email, email_confirmed_at)
select ('00000000-0000-4000-8000-' || lpad(to_hex(i), 12, '0'))::uuid,
       'lifter' || i || '@example.com', now()
  from generate_series(1, :n) i;

-- Most low on the ladder, few at the top; one in five still in placements;
-- about one in twenty with the app open in the last three minutes; one in
-- ten with a photo.
insert into profiles (id, username, country, created_at, tier_idx, div_idx, lp,
                      peak_tier_idx, placements_done, placement_wins, wins,
                      losses, win_streak, best_streak, total_reps, best_set,
                      friend_code, last_seen, xp, avatar_url)
select ('00000000-0000-4000-8000-' || lpad(to_hex(i), 12, '0'))::uuid,
       'lifter_' || i,
       (array['US','EG','GB','DE','FR','IN','BR','SA','AE','TR','ES','IT',
              'CA','MX','ID','JP','KR','RU','NG','PK'])[1 + (i % 20)],
       now() - (random() * interval '90 days'),
       t, d, (random() * 99)::int, t,
       case when i % 7 = 0 then (random() * 4)::int else 5 end,
       (random() * 5)::int,
       w, l, (random() * 5)::int, (random() * 12)::int,
       (w + l) * 22, 15 + (random() * 30)::int,
       lpad(i::text, 6, '0'),
       case when i % 20 = 0 then now() - random() * interval '2 minutes'
            else now() - random() * interval '20 days' end,
       (w + l) * 40,
       case when i % 10 = 3 then 'https://example.supabase.co/storage/v1/object/public/avatars/'
                                 || i || '/avatar.jpg?v=1' end
  from generate_series(1, :n) i
  cross join lateral (
    select least(6, floor(power(random(), 2.2) * 7))::int + 0 * i as t,
           (random() * 4)::int as d,
           (random() * 60)::int as w,
           (random() * 60)::int as l
  ) r;

-- Twenty sets each, one every three days. The second and third newest wait
-- unclaimed in the open pool; the newest was raced, so this week has duels.
insert into sets (id, profile_id, created_at, reps, reps_camera, depth,
                  confident, duration_ms, rep_times, claimed_by)
select gen_random_uuid(), p.id,
       now() - ((n - 1) * interval '3 days') - random() * interval '3 days',
       r, r, 0.7, true, 60000,
       (select array_agg(k * 60000 / greatest(r, 1)) from generate_series(1, r) k),
       case when n not in (2, 3) then gen_random_uuid() end
  from profiles p
  cross join generate_series(1, 20) n
  cross join lateral (select 10 + (random() * 30)::int + 0 * n as r) x;

-- A duel for every claimed set's worth: pairs of lifters next to each
-- other in time, so the head-to-head and the 24-hour checks have rows to
-- read. Board points as a ranked duel pays them: +5 a win, -2 a loss.
with numbered as (
  select s.id, s.profile_id, s.created_at, s.reps,
         row_number() over (order by s.created_at, s.id) as rn
    from sets s where s.claimed_by is not null
)
insert into duels (created_at, challenger, defender, challenger_set,
                   defender_set, winner, ranked, lp_challenger, lp_defender,
                   pts_challenger, pts_defender)
select a.created_at, a.profile_id, b.profile_id, a.id, b.id,
       case when a.reps >= b.reps then a.profile_id else b.profile_id end,
       random() < 0.8,
       case when a.reps >= b.reps then 25 else -20 end,
       case when a.reps >= b.reps then -20 else 25 end,
       case when a.reps >= b.reps then 5 else -2 end,
       case when a.reps >= b.reps then -2 else 5 end
  from numbered a
  join numbered b on b.rn = a.rn + 1
 where a.rn % 2 = 1 and a.profile_id <> b.profile_id;

-- About ten friends each, most accepted.
insert into friendships (requester, addressee, created_at, accepted_at)
select distinct on (a.id, b.id) a.id, b.id, now() - interval '30 days',
       case when random() < 0.85 then now() - interval '29 days' end
  from profiles a
  cross join generate_series(1, 5) k
  join profiles b on b.friend_code = lpad(((a.friend_code::int + k * 37) % :n + 1)::text, 6, '0')
 where a.id <> b.id
on conflict do nothing;

-- Fifteen notices each, most read.
insert into notifications (profile_id, created_at, read_at, kind, actor, actor_name)
select p.id, now() - n * interval '2 days',
       case when n > 2 then now() - n * interval '2 days' + interval '1 hour' end,
       (array['raced','friend_request','friend_accepted','challenged','live_invite'])[1 + n % 5],
       p.id, 'someone'
  from profiles p cross join generate_series(1, 15) n;

-- Live matches over the months: finished ones, and invites that ran out.
insert into live_matches (created_at, ranked, a, b, status, expires_at)
select now() - random() * interval '60 days', random() < 0.6, a.id, b.id,
       (array['done','done','done','expired','cancelled','declined'])[1 + (random() * 5)::int],
       now() - interval '61 days'
  from profiles a
  join profiles b on b.friend_code = lpad(((a.friend_code::int + 101) % :n + 1)::text, 6, '0')
  cross join generate_series(1, 4);

-- Everybody who ever left a search without saying so is still in the queue.
insert into live_queue (profile_id, level, joined_at, seen_at)
select p.id, p.tier_idx * 5 + p.div_idx,
       now() - random() * interval '30 days', now() - random() * interval '30 days'
  from profiles p where random() < 0.3;
-- And forty searching right now.
update live_queue set seen_at = now(), joined_at = now() - interval '3 seconds'
 where profile_id in (select profile_id from live_queue limit 40);

-- One lifter in five has sent a challenge link from their newest set, and
-- three others took each one with sets of their own.
with ranked_sets as (
  select s.id, s.profile_id, s.reps, s.created_at,
         row_number() over (partition by s.profile_id order by s.created_at desc) as rk
    from sets s
), owners as (
  select p.id, p.friend_code::int as i from profiles p where p.friend_code::int % 5 = 0
)
insert into challenges (code, set_id, owner, reps, created_at, expires_at)
select (select string_agg(substr('23456789abcdefghjkmnpqrstuvwxyz',
                                 1 + ((o.i / power(31, k)::bigint) % 31)::int, 1), '' order by k)
          from generate_series(0, 5) k),
       s.id, o.id, s.reps, s.created_at, s.created_at + interval '7 days'
  from owners o
  join ranked_sets s on s.profile_id = o.id and s.rk = 1;

with ranked_sets as (
  select s.id, s.profile_id, s.reps,
         row_number() over (partition by s.profile_id order by s.created_at desc) as rk
    from sets s
)
insert into challenge_takes (challenge_id, taker, set_id, reps, created_at)
select c.id, t.id, s.id, s.reps, c.created_at + interval '1 hour'
  from challenges c
  join profiles o on o.id = c.owner
  cross join generate_series(1, 3) k
  join profiles t on t.friend_code = lpad(((o.friend_code::int + k * 13) % :n + 1)::text, 6, '0')
  join ranked_sets s on s.profile_id = t.id and s.rk = 1 + k
 where t.id <> o.id;

set session_replication_role = origin;

-- The month's and last month's board totals, as the duels have them; then
-- last month closed (its awards given), timed, as the first call of a new
-- month would close it.
select season_points_rebuild(season_of(now()));
select season_points_rebuild(season_of(now() - interval '1 month'));
select season_points_rebuild(season_of(now() - interval '2 months'));
select close_finished_seasons();
\timing off
analyze;

select (select count(*) from profiles) profiles, (select count(*) from sets) sets,
       (select count(*) from duels) duels, (select count(*) from friendships) friendships,
       (select count(*) from notifications) notifications,
       (select count(*) from live_matches) live_matches,
       (select count(*) from live_queue) live_queue,
       (select count(*) from challenges) challenges,
       (select count(*) from season_awards) awards,
       pg_size_pretty(pg_database_size(current_database())) size;
