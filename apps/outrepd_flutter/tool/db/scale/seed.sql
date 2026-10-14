-- Never run against the real project. See README.md beside this file.
-- Ten thousand lifters and a few months of what they did, for timing the
-- server's calls at the size the app is being readied for. Written straight
-- into the tables with the triggers off: the guards and counters are not what
-- is being measured, and the totals they keep are filled in directly.
set session_replication_role = replica;
select setseed(0.42);

insert into auth.users (id, email, email_confirmed_at)
select ('00000000-0000-4000-8000-' || lpad(to_hex(i), 12, '0'))::uuid,
       'lifter' || i || '@example.com', now()
  from generate_series(1, 10000) i;

-- Most low on the ladder, few at the top; one in five still in placements;
-- about one in twenty with the app open in the last three minutes.
insert into profiles (id, username, country, created_at, tier_idx, div_idx, lp,
                      peak_tier_idx, placements_done, placement_wins, wins,
                      losses, win_streak, best_streak, total_reps, best_set,
                      friend_code, last_seen)
select u.id,
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
            else now() - random() * interval '20 days' end
  from generate_series(1, 10000) i
  join auth.users u on u.email = 'lifter' || i || '@example.com'
  cross join lateral (
    select least(6, floor(power(random(), 2.2) * 7))::int + 0 * i as t,
           (random() * 4)::int as d,
           (random() * 60)::int as w,
           (random() * 60)::int as l
  ) r;

-- Twenty sets each, the last few unclaimed in the open pool.
insert into sets (id, profile_id, created_at, reps, reps_camera, depth,
                  confident, duration_ms, rep_times, claimed_by)
select gen_random_uuid(), p.id,
       now() - (n * interval '3 days') - random() * interval '2 days',
       r, r, 0.7, true, 60000,
       (select array_agg(k * 60000 / greatest(r, 1)) from generate_series(1, r) k),
       case when n > 3 then gen_random_uuid() end
  from profiles p
  cross join generate_series(1, 20) n
  cross join lateral (select 10 + (random() * 30)::int + 0 * n as r) x;

-- A duel for every claimed set's worth: pairs of lifters a few hundred
-- apart, so the head-to-head and the 24-hour checks have rows to read.
with numbered as (
  select s.id, s.profile_id, s.created_at, s.reps,
         row_number() over (order by s.created_at, s.id) as rn
    from sets s where s.claimed_by is not null
)
insert into duels (created_at, challenger, defender, challenger_set,
                   defender_set, winner, ranked, lp_challenger, lp_defender)
select a.created_at, a.profile_id, b.profile_id, a.id, b.id,
       case when a.reps >= b.reps then a.profile_id else b.profile_id end,
       random() < 0.8, 7, -5
  from numbered a
  join numbered b on b.rn = a.rn + 1
 where a.rn % 2 = 1 and a.profile_id <> b.profile_id;

-- About ten friends each, most accepted.
insert into friendships (requester, addressee, created_at, accepted_at)
select distinct on (a.id, b.id) a.id, b.id, now() - interval '30 days',
       case when random() < 0.85 then now() - interval '29 days' end
  from profiles a
  cross join generate_series(1, 5) k
  join profiles b on b.friend_code = lpad(((a.friend_code::int + k * 37) % 10000 + 1)::text, 6, '0')
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
  join profiles b on b.friend_code = lpad(((a.friend_code::int + 101) % 10000 + 1)::text, 6, '0')
  cross join generate_series(1, 4);

-- Everybody who ever left a search without saying so is still in the queue.
insert into live_queue (profile_id, level, joined_at, seen_at)
select p.id, p.tier_idx * 5 + p.div_idx,
       now() - random() * interval '30 days', now() - random() * interval '30 days'
  from profiles p where random() < 0.3;
-- And forty searching right now.
update live_queue set seen_at = now(), joined_at = now() - interval '3 seconds'
 where profile_id in (select profile_id from live_queue limit 40);

set session_replication_role = origin;
analyze;

select (select count(*) from profiles) profiles, (select count(*) from sets) sets,
       (select count(*) from duels) duels, (select count(*) from friendships) friendships,
       (select count(*) from notifications) notifications,
       (select count(*) from live_matches) live_matches,
       (select count(*) from live_queue) live_queue,
       pg_size_pretty(pg_database_size(current_database())) size;
