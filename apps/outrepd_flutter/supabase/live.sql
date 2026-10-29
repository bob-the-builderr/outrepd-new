-- OUTREPD — live matches: both lifters on camera at the same time.
--
-- Two ways in:
--   ranked   `find_live_opponent` is called every second or so while the
--            search screen counts to fifteen. It pairs the caller with
--            whoever has been waiting longest near their level, or puts the
--            caller in the queue to be found. After fifteen seconds with
--            nobody, the app leaves the queue and races a saved set instead
--            (duel.sql) — the ranked button always ends in a match.
--   friend   `invite_live` asks one friend, who gets a notice and a push and
--            has a minute to join. Friendly: it moves no rank.
--
-- Then both phones say they are on the match screen (`live_ready`) — in
-- position or not — and the server picks one instant for the round to start,
-- ten seconds after the second of them, handed to each phone as "this many
-- milliseconds from now" so neither phone's clock has to be right.
--
-- The counts travel phone to phone over Supabase Realtime while the round
-- runs; that is only for showing them. What settles the match is the two
-- sets, sent at the end (`finish_live_match`) and judged by `settle_duel` —
-- the same rule as every other duel, not a second copy of it. Each phone also
-- reports its count every few seconds (`report_live_count`), so a phone that
-- drops out mid-round still has a number: the round finishes on the clock,
-- and the one that vanished is judged on the last count that arrived.

create table if not exists live_matches (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  ranked      boolean not null,

  -- For an invite, `a` asked and `b` was asked. For ranked, `a` made the
  -- pairing and `b` was the one waiting in the queue.
  a           uuid not null references profiles on delete cascade,
  b           uuid not null references profiles on delete cascade,

  status      text not null default 'invited'
              check (status in ('invited', 'ready', 'live', 'done',
                                'cancelled', 'declined', 'expired')),

  -- The invite's minute.
  expires_at  timestamptz,
  -- How long the two have to both reach the match screen once paired.
  ready_by    timestamptz,

  a_ready     boolean not null default false,
  b_ready     boolean not null default false,

  -- The one instant the round starts on both phones.
  starts_at   timestamptz,

  -- The last count each phone reported, and when.
  a_reps      int not null default 0,
  b_reps      int not null default 0,
  a_seen      timestamptz,
  b_seen      timestamptz,

  a_set       uuid references sets on delete set null,
  b_set       uuid references sets on delete set null,
  duel        uuid references duels on delete set null
);

create index if not exists live_matches_b_idx on live_matches (b, status);
create index if not exists live_matches_a_idx on live_matches (a, status);
-- The foreign keys' own indexes; see sets_challenge_target_idx in schema.sql.
create index if not exists live_matches_a_set_idx
  on live_matches (a_set) where a_set is not null;
create index if not exists live_matches_b_set_idx
  on live_matches (b_set) where b_set is not null;
create index if not exists live_matches_duel_idx
  on live_matches (duel) where duel is not null;

-- The match a rematch was asked for after; null for every other match.
alter table live_matches
  add column if not exists rematch_of uuid references live_matches on delete set null;
create index if not exists live_matches_rematch_of_idx
  on live_matches (rematch_of) where rematch_of is not null;

-- After the round, on the result screen: when each phone last said it was
-- still there, and when it left. What the other phone's rematch button reads
-- (live_result_presence).
alter table live_matches add column if not exists a_result_seen timestamptz;
alter table live_matches add column if not exists b_result_seen timestamptz;
alter table live_matches add column if not exists a_left_result timestamptz;
alter table live_matches add column if not exists b_left_result timestamptz;

-- Nobody reads or writes it directly; the functions below are the only way.
alter table live_matches enable row level security;

-- Who is searching for a ranked live match right now.
create table if not exists live_queue (
  profile_id  uuid primary key references profiles on delete cascade,
  level       int not null,
  joined_at   timestamptz not null default now(),
  -- Refreshed by every call from the search screen. Somebody whose phone
  -- stopped asking a few seconds ago has left, whatever the row says.
  seen_at     timestamptz not null default now()
);

alter table live_queue enable row level security;

-- ─────────────────────────────── ranked: the queue ─────────────────────────────

-- How far apart in level two lifters may be, given how long one of them has
-- searched: close at first, wider every five seconds, and the whole ladder's
-- worth of reach before the fifteen seconds after which the app gives up and
-- races a recorded set instead. A level is one division; a tier is five.
create or replace function live_reach(waited_seconds double precision)
returns int
language sql
immutable
set search_path = public
as $$
  select case
           when waited_seconds < 5 then 2
           when waited_seconds < 10 then 6
           else 12
         end
$$;

-- For the search screen while it waits: how many are searching right now,
-- and how many have had the app open in the last few minutes. Counts only;
-- nobody in them is named.
create or replace function live_online()
returns table (searching int, online int)
language sql
stable
security definer
set search_path = public
as $$
  select
    (select count(*)::int from live_queue q
      where q.seen_at > now() - interval '5 seconds'
        and q.profile_id <> auth.uid()),
    (select count(*)::int from profiles p
      where p.last_seen > now() - interval '3 minutes'
        and p.id <> auth.uid());
$$;

revoke all on function live_reach(double precision) from public, anon;
revoke all on function live_online() from public, anon;
grant execute on function live_online() to authenticated;

-- Pairs the caller with somebody live, or waits in the queue. Returns one row
-- once there is somebody to race, and nothing while there is not.
-- Dropped first: the opponent's picture was added to what it returns, and a
-- function's columns cannot change in place.
drop function if exists find_live_opponent();
create or replace function find_live_opponent()
returns table (
  match_id uuid,
  opponent_id uuid,
  opponent_name text,
  opponent_tier int,
  opponent_div int,
  opponent_avatar text,
  opponent_xp int
)
language plpgsql
security definer
set search_path = public
as $$
declare
  me profiles;
  my_level int;
  my_wait double precision;
  paired live_matches;
  waiting live_queue;
begin
  perform require_pro();
  select * into me from profiles where id = auth.uid();
  if me is null then
    raise exception 'no profile for this account';
  end if;
  my_level := ladder_level(me.tier_idx, me.div_idx);
  -- How long this search has run: the phone asks again every few seconds,
  -- and the queue row keeps when it first joined.
  my_wait := coalesce(
    extract(epoch from now() - (select q.joined_at from live_queue q
                                 where q.profile_id = me.id)),
    0);

  -- One pairing at a time, so two people can never both take the same third.
  perform pg_advisory_xact_lock(hashtext('outrepd.live_queue'));

  -- Whoever stopped asking a minute ago has gone: the app was closed mid
  -- search, or the phone lost its connection, and leave_live_queue never
  -- came. Left there, the queue grows with everybody who ever did that, and
  -- every search reads all of them; and coming back to search later would
  -- start from the old row's joined_at, as if they had waited all along.
  delete from live_queue q where q.seen_at < now() - interval '1 minute';

  -- Somebody else's call may already have paired this account.
  select * into paired from live_matches lm
   where lm.b = me.id and lm.ranked and lm.status = 'ready'
     and lm.created_at > now() - interval '30 seconds'
   order by lm.created_at desc
   limit 1;
  if paired.id is not null then
    delete from live_queue where live_queue.profile_id = me.id;
    return query
      select paired.id, p.id, p.username, p.tier_idx, p.div_idx, p.avatar_url,
             p.xp
        from profiles p where p.id = paired.a;
    return;
  end if;

  -- Whoever has waited longest, near this level, and still here, with no
  -- block or mute either way — a mute in a live match would be offering each
  -- of them the other. Two who have met before meet again: two people
  -- searching at the same moment are a match whoever they are, and every one
  -- of those matches counts (settle_duel).
  select q.* into waiting from live_queue q
    join profiles p on p.id = q.profile_id
   where q.profile_id <> me.id
     and q.seen_at > now() - interval '5 seconds'
     -- Close in level first, wider the longer either of them has waited:
     -- the nearest opponent when there is one, and a match rather than a
     -- recorded set when there is not.
     and abs(q.level - my_level) <= greatest(
           live_reach(my_wait),
           live_reach(extract(epoch from now() - q.joined_at)))
     and not exists (
       select 1 from blocks bl
        where (bl.blocker = me.id and bl.blocked = p.id)
           or (bl.blocker = p.id and bl.blocked = me.id)
     )
     and not exists (
       select 1 from mutes mu
        where (mu.muter = me.id and mu.muted = p.id)
           or (mu.muter = p.id and mu.muted = me.id)
     )
   order by abs(q.level - my_level), q.joined_at
   limit 1;

  if waiting.profile_id is not null then
    delete from live_queue
     where live_queue.profile_id in (me.id, waiting.profile_id);
    insert into live_matches (ranked, a, b, status, ready_by)
    values (true, me.id, waiting.profile_id, 'ready',
            now() + interval '75 seconds')
    returning * into paired;
    return query
      select paired.id, p.id, p.username, p.tier_idx, p.div_idx, p.avatar_url,
             p.xp
        from profiles p where p.id = waiting.profile_id;
    return;
  end if;

  -- Nobody yet: wait here to be found.
  insert into live_queue (profile_id, level)
  values (me.id, my_level)
  on conflict (profile_id) do update
    set seen_at = now(), level = excluded.level;
end;
$$;

-- The search gave up at fifteen seconds. Also calls off a pairing that landed
-- in the moment between the last check and giving up: the other phone is told
-- by `live_match_state` and searches again, rather than waiting for somebody
-- who has already gone to race a saved set.
create or replace function leave_live_queue()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  perform pg_advisory_xact_lock(hashtext('outrepd.live_queue'));
  delete from live_queue where live_queue.profile_id = auth.uid();
  update live_matches lm set status = 'cancelled'
   where lm.b = auth.uid() and lm.ranked and lm.status = 'ready'
     and not lm.b_ready;
end;
$$;

-- ─────────────────────────────── friend: the invite ────────────────────────────

-- Asks one friend to go live now. Any earlier invite of the caller's that is
-- still open is withdrawn: one invite at a time.
create or replace function invite_live(friend_id uuid)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  me profiles;
  new_id uuid;
begin
  perform require_pro();
  select * into me from profiles where id = auth.uid();
  if me is null then
    raise exception 'no profile for this account';
  end if;
  if not exists (
    select 1 from friendships f
     where f.accepted_at is not null
       and ((f.requester = me.id and f.addressee = friend_id)
         or (f.addressee = me.id and f.requester = friend_id))
  ) then
    raise exception 'only a friend can be invited live';
  end if;
  if exists (
    select 1 from blocks bl
     where (bl.blocker = me.id and bl.blocked = friend_id)
        or (bl.blocker = friend_id and bl.blocked = me.id)
  ) then
    raise exception 'only a friend can be invited live';
  end if;

  -- Every invite is a push on their phone, and cancelling one and sending
  -- another is a second: three to one friend in ten minutes, six in all.
  if not within_rate('live_invite_to', interval '10 minutes', 3, friend_id)
     or not within_rate('live_invite', interval '10 minutes', 6) then
    raise exception 'too many invites, wait a few minutes';
  end if;

  update live_matches lm set status = 'cancelled'
   where lm.a = me.id and lm.status = 'invited';

  insert into live_matches (ranked, a, b, status, expires_at)
  values (false, me.id, friend_id, 'invited', now() + interval '60 seconds')
  returning id into new_id;

  -- A notice, and with it a push (push.sql): the friend may not have the
  -- app open, which is the whole reason there is a minute to answer in.
  -- Unless they turned these off — the invite still shows in the app.
  if exists (
    select 1 from profiles p where p.id = friend_id and p.notify_live_invite
  ) then
    insert into notifications (profile_id, kind, actor, actor_name)
    values (friend_id, 'live_invite', me.id, coalesce(me.username, ''));
  end if;

  return new_id;
end;
$$;

-- Invites waiting on the caller, newest first, with how long each has left.
-- A friend's invite is friendly; a rematch is whatever the match before it
-- was, so the one being asked is told which. Dropped first because `ranked`
-- was added after the other columns.
drop function if exists my_live_invites();
create or replace function my_live_invites()
returns table (
  match_id uuid,
  from_id uuid,
  from_name text,
  from_tier int,
  from_div int,
  expires_in_ms int,
  ranked boolean,
  from_avatar text,
  from_xp int
)
language sql
security definer
set search_path = public
stable
as $$
  select lm.id, p.id, p.username, p.tier_idx, p.div_idx,
         greatest(0, (extract(epoch from lm.expires_at - now()) * 1000)::int),
         lm.ranked, p.avatar_url, p.xp
    from live_matches lm
    join profiles p on p.id = lm.a
   where lm.b = auth.uid()
     and lm.status = 'invited'
     and lm.expires_at > now()
   order by lm.created_at desc;
$$;

-- Yes or no to an invite. Answers with what the invite is now: 'ready' once
-- accepted, otherwise why it could not be.
create or replace function answer_live_invite(invite uuid, accept boolean)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  m live_matches;
begin
  if accept then
    perform require_pro();
  end if;
  select * into m from live_matches lm
   where lm.id = invite and lm.b = auth.uid()
   for update;
  if m.id is null then
    return 'gone';
  end if;
  if m.status <> 'invited' then
    return m.status;
  end if;
  if m.expires_at <= now() then
    update live_matches lm set status = 'expired' where lm.id = m.id;
    return 'expired';
  end if;

  if accept then
    update live_matches lm
       set status = 'ready', ready_by = now() + interval '75 seconds'
     where lm.id = m.id;
    return 'ready';
  end if;
  update live_matches lm set status = 'declined' where lm.id = m.id;
  return 'declined';
end;
$$;

-- The one who asked, changing their mind before it was answered.
create or replace function cancel_live_invite(invite uuid)
returns void
language sql
security definer
set search_path = public
as $$
  update live_matches lm set status = 'cancelled'
   where lm.id = invite and lm.a = auth.uid() and lm.status = 'invited';
$$;

-- ──────────────────────────────── both: the rematch ────────────────────────────

-- Another one, straight after a live match, from the result screen: either of
-- the two asks, and when the other asks too it starts. Not only for friends —
-- the two were just on camera together — and as ranked as the match before
-- it.
--
-- Answers with the rematch and where it stands: 'invited' while waiting on
-- the other, 'ready' once both have asked.
create or replace function rematch_live(after uuid)
returns table (match_id uuid, match_status text, is_ranked boolean)
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
  prev live_matches;
  them uuid;
  theirs live_matches;
  mine live_matches;
  pays boolean;
  new_id uuid;
begin
  perform require_pro();
  -- Both pressing at once would otherwise send two invites past each other,
  -- each waiting on the other. One at a time, the second finds the first.
  perform pg_advisory_xact_lock(hashtext('rematch:' || after::text));

  select * into prev from live_matches lm
   where lm.id = after and me in (lm.a, lm.b);
  if prev.id is null or prev.status <> 'done' then
    raise exception 'no finished live match to rematch';
  end if;
  -- Asked for on the result screen, not days later.
  if coalesce(prev.starts_at, prev.created_at) < now() - interval '10 minutes' then
    raise exception 'that match was too long ago to rematch';
  end if;
  them := case when prev.a = me then prev.b else prev.a end;
  if exists (
    select 1 from blocks bl
     where (bl.blocker = me and bl.blocked = them)
        or (bl.blocker = them and bl.blocked = me)
  ) then
    raise exception 'no rematch with this lifter';
  end if;
  -- They have left the result screen: nobody is there to say yes.
  if (case when prev.a = me then prev.b_left_result else prev.a_left_result end)
       is not null then
    raise exception 'they left';
  end if;

  -- They asked first: this is the yes.
  select * into theirs from live_matches lm
   where lm.rematch_of = after and lm.a = them and lm.b = me
     and lm.status = 'invited' and lm.expires_at > now()
   for update;
  if theirs.id is not null then
    update live_matches lm
       set status = 'ready', ready_by = now() + interval '75 seconds'
     where lm.id = theirs.id;
    return query select theirs.id, 'ready'::text, theirs.ranked;
    return;
  end if;

  -- Asked already: the same rematch, not a second one.
  select * into mine from live_matches lm
   where lm.rematch_of = after and lm.a = me
     and lm.status in ('invited', 'ready', 'live')
     and (lm.status <> 'invited' or lm.expires_at > now());
  if mine.id is not null then
    return query select mine.id, mine.status, mine.ranked;
    return;
  end if;

  if not within_rate('live_rematch', interval '10 minutes', 6) then
    raise exception 'too many rematches, wait a few minutes';
  end if;

  -- Ranked if the match before was: a friend's match stays friendly, a
  -- match the search found pays again.
  pays := prev.ranked;

  update live_matches lm set status = 'cancelled'
   where lm.a = me and lm.status = 'invited';
  insert into live_matches (ranked, a, b, status, expires_at, rematch_of)
  values (pays, me, them, 'invited', now() + interval '30 seconds', after)
  returning id into new_id;
  return query select new_id, 'invited'::text, pays;
end;
$$;

-- The caller is on the result screen of [after], or — with [leaving] — has
-- just left it. Answers where the other one is: 'here', 'waiting' (not on
-- their result screen yet), or 'left' — gone from it, or silent for longer
-- than a phone that is still there ever is, or never arriving long after the
-- round ended.
create or replace function live_result_presence(after uuid, leaving boolean default false)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  m live_matches;
  i_am_a boolean;
  their_seen timestamptz;
  their_left timestamptz;
begin
  select * into m from live_matches lm
   where lm.id = after and auth.uid() in (lm.a, lm.b)
   for update;
  if m.id is null then
    raise exception 'no such live match';
  end if;
  i_am_a := m.a = auth.uid();

  if i_am_a then
    update live_matches lm
       set a_result_seen = now(),
           a_left_result = case when leaving then now() else lm.a_left_result end
     where lm.id = m.id;
    their_seen := m.b_result_seen;
    their_left := m.b_left_result;
  else
    update live_matches lm
       set b_result_seen = now(),
           b_left_result = case when leaving then now() else lm.b_left_result end
     where lm.id = m.id;
    their_seen := m.a_result_seen;
    their_left := m.a_left_result;
  end if;

  if their_left is not null then
    return 'left';
  end if;
  if their_seen is not null then
    -- A phone on the result screen says so every couple of seconds.
    return case when their_seen > now() - interval '12 seconds'
                then 'here' else 'left' end;
  end if;
  -- Not there yet: still finishing, or never coming. A minute's round and
  -- forty seconds after it is longer than any phone takes to get there.
  if coalesce(m.starts_at, m.created_at) < now() - interval '100 seconds' then
    return 'left';
  end if;
  return 'waiting';
end;
$$;

-- ─────────────────────────────── both: the match ───────────────────────────────

-- Where a match stands, from the caller's side of it. Also where lapsed
-- invites and pairings are called off: nothing else runs on a timer.
drop function if exists live_match_state(uuid);
create or replace function live_match_state(live uuid)
returns table (
  match_status text,
  is_ranked boolean,
  opponent_id uuid,
  opponent_name text,
  opponent_tier int,
  opponent_div int,
  they_are_ready boolean,
  starts_in_ms int,
  expires_in_ms int,
  their_reps int,
  opponent_avatar text,
  opponent_xp int
)
language plpgsql
security definer
set search_path = public
as $$
declare
  m live_matches;
  i_am_a boolean;
begin
  select * into m from live_matches lm
   where lm.id = live and auth.uid() in (lm.a, lm.b)
   for update;
  if m.id is null then
    raise exception 'no such live match';
  end if;
  i_am_a := m.a = auth.uid();

  if m.status = 'invited' and m.expires_at <= now() then
    update live_matches lm set status = 'expired' where lm.id = m.id;
    m.status := 'expired';
  elsif m.status = 'ready' and m.ready_by <= now() then
    -- Paired, and one of them never turned up.
    update live_matches lm set status = 'expired' where lm.id = m.id;
    m.status := 'expired';
  end if;

  return query
    select m.status, m.ranked, p.id, p.username, p.tier_idx, p.div_idx,
           case when i_am_a then m.b_ready else m.a_ready end,
           case when m.starts_at is null then null
                else (extract(epoch from m.starts_at - now()) * 1000)::int end,
           case when m.expires_at is null then null
                else greatest(0, (extract(epoch from m.expires_at - now()) * 1000)::int) end,
           case when i_am_a then m.b_reps else m.a_reps end,
           p.avatar_url, p.xp
      from profiles p
     where p.id = case when i_am_a then m.b else m.a end;
end;
$$;

-- The caller is on the match screen. When both are, the round gets its
-- start: ten seconds out, for both to get down while both phones count to
-- it, and then it starts for both at once whether or not they are down.
-- Returns how far away that start is, or null while the other is not there.
create or replace function live_ready(live uuid)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  m live_matches;
begin
  select * into m from live_matches lm
   where lm.id = live and auth.uid() in (lm.a, lm.b)
   for update;
  if m.id is null then
    raise exception 'no such live match';
  end if;
  if m.status not in ('ready', 'live') then
    return null;
  end if;

  if m.a = auth.uid() then
    m.a_ready := true;
  else
    m.b_ready := true;
  end if;
  if m.a_ready and m.b_ready and m.starts_at is null then
    m.starts_at := now() + interval '10 seconds';
    m.status := 'live';
  end if;

  update live_matches lm
     set a_ready = m.a_ready, b_ready = m.b_ready,
         starts_at = m.starts_at, status = m.status
   where lm.id = m.id;

  if m.starts_at is null then
    return null;
  end if;
  return (extract(epoch from m.starts_at - now()) * 1000)::int;
end;
$$;

-- The caller's count so far. Only kept for a phone that drops out: the live
-- display travels phone to phone, and this is what is left if one vanishes.
create or replace function report_live_count(live uuid, reps_now int)
returns void
language sql
security definer
set search_path = public
as $$
  update live_matches lm set
    a_reps = case when lm.a = auth.uid() then least(greatest(reps_now, 0), 300) else lm.a_reps end,
    a_seen = case when lm.a = auth.uid() then now() else lm.a_seen end,
    b_reps = case when lm.b = auth.uid() then least(greatest(reps_now, 0), 300) else lm.b_reps end,
    b_seen = case when lm.b = auth.uid() then now() else lm.b_seen end
   where lm.id = live and lm.status = 'live' and auth.uid() in (lm.a, lm.b);
$$;

-- The three below answer with the same columns, and `result_ranked` was added
-- after the rest; a function's result columns cannot change in place.
drop function if exists live_outcome(live_matches);
drop function if exists finish_live_match(uuid, int, int, real, boolean, int, boolean, int[]);
drop function if exists live_match_result(uuid);

-- A finished match, from the caller's side: `settle_duel`'s answer for
-- whoever settled it, read back off the duel and the account for the other.
create or replace function live_outcome(m live_matches)
returns table (
  is_settled boolean,
  result_duel uuid,
  result_won boolean,
  result_lp_delta int,
  result_tier int,
  result_div int,
  result_lp int,
  result_wins int,
  result_losses int,
  result_win_streak int,
  result_best_streak int,
  result_placements_done int,
  result_placement_wins int,
  result_their_reps int,
  -- Whether it moved the ladder: see settle_duel's was_ranked.
  result_ranked boolean
)
language sql
security definer
set search_path = public
stable
as $$
  select true, d.id, d.winner = p.id,
         case when d.challenger = p.id then d.lp_challenger else d.lp_defender end,
         p.tier_idx, p.div_idx, p.lp, p.wins, p.losses, p.win_streak,
         p.best_streak, p.placements_done, p.placement_wins,
         (select s.reps from sets s
           where s.id = case when m.a = p.id then m.b_set else m.a_set end),
         d.ranked
    from duels d, profiles p
   where d.id = m.duel and p.id = auth.uid();
$$;

revoke all on function live_outcome(live_matches) from public, anon, authenticated;

-- Settles a match whose two sets are both in, as the caller.
create or replace function settle_live(m live_matches)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  mine uuid := case when m.a = auth.uid() then m.a_set else m.b_set end;
  theirs uuid := case when m.a = auth.uid() then m.b_set else m.a_set end;
  settled record;
begin
  select * into settled from settle_duel(mine, theirs, m.ranked);
  update live_matches lm set status = 'done', duel = settled.duel_id
   where lm.id = m.id;
  -- settle_duel tells the other side they were raced (notify.sql). They were
  -- there, on camera, watching it happen; that notice is for a set raced
  -- while its owner was away.
  delete from notifications n where n.duel_id = settled.duel_id;
end;
$$;

revoke all on function settle_live(live_matches) from public, anon, authenticated;

-- The caller's set, at the end of the round. Settles the match if the other
-- set is already in; otherwise the caller waits on `live_match_result`.
create or replace function finish_live_match(
  live uuid,
  set_reps int,
  set_reps_camera int,
  set_depth real,
  set_confident boolean,
  set_duration_ms int,
  set_gave_up boolean,
  set_rep_times int[]
)
returns table (
  is_settled boolean,
  result_duel uuid,
  result_won boolean,
  result_lp_delta int,
  result_tier int,
  result_div int,
  result_lp int,
  result_wins int,
  result_losses int,
  result_win_streak int,
  result_best_streak int,
  result_placements_done int,
  result_placement_wins int,
  result_their_reps int,
  -- Whether it moved the ladder: see settle_duel's was_ranked.
  result_ranked boolean
)
language plpgsql
security definer
set search_path = public
as $$
declare
  m live_matches;
  i_am_a boolean;
  my_set uuid;
begin
  select * into m from live_matches lm
   where lm.id = live and auth.uid() in (lm.a, lm.b)
   for update;
  if m.id is null then
    raise exception 'no such live match';
  end if;
  if m.starts_at is null then
    raise exception 'this match never started';
  end if;
  i_am_a := m.a = auth.uid();
  my_set := case when i_am_a then m.a_set else m.b_set end;

  -- Once. A phone that lost its connection and sends again, or whose set the
  -- other side already had to stand in for, gets the result and nothing more.
  if my_set is null then
    insert into sets (profile_id, reps, reps_camera, depth, confident,
                      duration_ms, gave_up, rep_times, live_match)
    values (auth.uid(), set_reps, set_reps_camera, set_depth, set_confident,
            set_duration_ms, set_gave_up, coalesce(set_rep_times, '{}'), m.id)
    returning id into my_set;
    if i_am_a then
      m.a_set := my_set;
      m.a_reps := set_reps;
    else
      m.b_set := my_set;
      m.b_reps := set_reps;
    end if;
    update live_matches lm
       set a_set = m.a_set, b_set = m.b_set,
           a_reps = m.a_reps, b_reps = m.b_reps
     where lm.id = m.id;
  end if;

  if m.duel is null and m.a_set is not null and m.b_set is not null then
    perform settle_live(m);
    select * into m from live_matches lm where lm.id = live;
  end if;

  if m.duel is null then
    return query select false, null::uuid, null::boolean, null::int, null::int,
                        null::int, null::int, null::int, null::int, null::int,
                        null::int, null::int, null::int, null::int,
                        null::boolean;
    return;
  end if;
  return query select * from live_outcome(m);
end;
$$;

-- For the one who finished first. The result once there is one; and once the
-- other side is long overdue — the round, plus forty seconds to send — the
-- match is settled on the last count their phone reported, which is the rule
-- the screen showed while it ran: their number froze, the clock did not.
create or replace function live_match_result(live uuid)
returns table (
  is_settled boolean,
  result_duel uuid,
  result_won boolean,
  result_lp_delta int,
  result_tier int,
  result_div int,
  result_lp int,
  result_wins int,
  result_losses int,
  result_win_streak int,
  result_best_streak int,
  result_placements_done int,
  result_placement_wins int,
  result_their_reps int,
  -- Whether it moved the ladder: see settle_duel's was_ranked.
  result_ranked boolean
)
language plpgsql
security definer
set search_path = public
as $$
declare
  m live_matches;
  i_am_a boolean;
  stand_in uuid;
begin
  select * into m from live_matches lm
   where lm.id = live and auth.uid() in (lm.a, lm.b)
   for update;
  if m.id is null then
    raise exception 'no such live match';
  end if;
  i_am_a := m.a = auth.uid();

  if m.duel is null
     and (case when i_am_a then m.a_set else m.b_set end) is not null
     and (case when i_am_a then m.b_set else m.a_set end) is null
     and m.starts_at + interval '100 seconds' < now() then
    -- At most what a minute holds (sets_reps_fit_the_time, schema.sql): the
    -- count came from their phone, and the stand-in is stored as a minute.
    insert into sets (profile_id, reps, reps_camera, depth, confident,
                      duration_ms, gave_up, rep_times, live_match)
    values (case when i_am_a then m.b else m.a end,
            least(case when i_am_a then m.b_reps else m.a_reps end, 200),
            least(case when i_am_a then m.b_reps else m.a_reps end, 200),
            0, false, 60000, false, '{}', m.id)
    returning id into stand_in;
    if i_am_a then
      m.b_set := stand_in;
    else
      m.a_set := stand_in;
    end if;
    update live_matches lm set a_set = m.a_set, b_set = m.b_set
     where lm.id = m.id;
    perform settle_live(m);
    select * into m from live_matches lm where lm.id = live;
  end if;

  if m.duel is null then
    return query select false, null::uuid, null::boolean, null::int, null::int,
                        null::int, null::int, null::int, null::int, null::int,
                        null::int, null::int, null::int, null::int,
                        null::boolean;
    return;
  end if;
  return query select * from live_outcome(m);
end;
$$;

revoke all on function find_live_opponent() from public, anon;
grant execute on function find_live_opponent() to authenticated;
revoke all on function leave_live_queue() from public, anon;
grant execute on function leave_live_queue() to authenticated;
revoke all on function invite_live(uuid) from public, anon;
grant execute on function invite_live(uuid) to authenticated;
revoke all on function my_live_invites() from public, anon;
grant execute on function my_live_invites() to authenticated;
revoke all on function answer_live_invite(uuid, boolean) from public, anon;
grant execute on function answer_live_invite(uuid, boolean) to authenticated;
revoke all on function cancel_live_invite(uuid) from public, anon;
grant execute on function cancel_live_invite(uuid) to authenticated;
revoke all on function rematch_live(uuid) from public, anon;
grant execute on function rematch_live(uuid) to authenticated;
revoke all on function live_result_presence(uuid, boolean) from public, anon;
grant execute on function live_result_presence(uuid, boolean) to authenticated;
revoke all on function live_match_state(uuid) from public, anon;
grant execute on function live_match_state(uuid) to authenticated;
revoke all on function live_ready(uuid) from public, anon;
grant execute on function live_ready(uuid) to authenticated;
revoke all on function report_live_count(uuid, int) from public, anon;
grant execute on function report_live_count(uuid, int) to authenticated;
revoke all on function finish_live_match(uuid, int, int, real, boolean, int, boolean, int[]) from public, anon;
grant execute on function finish_live_match(uuid, int, int, real, boolean, int, boolean, int[]) to authenticated;
revoke all on function live_match_result(uuid) from public, anon;
grant execute on function live_match_result(uuid) to authenticated;

-- ──────────────────────────────────── XP ─────────────────────────────────────

-- Twenty XP for every match won, ranked or friendly, on top of its reps,
-- which arrive with each set (count_reps_of_set, schema.sql). A lost match
-- pays nothing: the reps its set paid when it was stored come back off. The
-- side of a duel that was only raced — a stored set somebody else took on —
-- did not play it, and is neither paid nor charged for it. Deferred, as
-- season_points is: a live match names its duel only after the duel is
-- written.
create or replace function xp_for_duel()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  d duels;
  live boolean;
  side record;
begin
  select * into d from duels where id = new.id;
  if d.id is null then
    return null;
  end if;
  live := exists (select 1 from live_matches m where m.duel = d.id);
  perform set_config('outrepd.settling', 'on', true);
  for side in
    select d.challenger as id, d.challenger_set as set_id
    union all
    select d.defender, d.defender_set where live
  loop
    if d.winner is null or d.winner = side.id then
      update profiles set xp = xp + 20 where id = side.id;
    else
      update profiles p set xp = greatest(p.xp - s.reps, 0)
        from sets s
       where s.id = side.set_id and p.id = side.id;
    end if;
  end loop;
  perform set_config('outrepd.settling', 'off', true);
  return null;
end;
$$;

drop trigger if exists duels_xp on duels;
create constraint trigger duels_xp
  after insert on duels
  deferrable initially deferred
  for each row execute function xp_for_duel();

revoke all on function xp_for_duel() from public, anon, authenticated;

-- Accounts from before XP: what they would have earned, worked out from what
-- is kept — every rep of every set, twenty for every match won, and the reps
-- of every match lost taken back. The same sum the triggers keep, so running
-- it again changes nothing; and it only ever raises a number, because XP
-- never goes down: what matches lost before this rule paid stays paid.
-- In a block of its own, so the guard on profiles reads the flag for this
-- update alone.
do $$
begin
  perform set_config('outrepd.settling', 'on', true);
  with played as (
    select d.challenger as id, d.challenger_set as set_id, d.winner
      from duels d
    union all
    select d.defender, d.defender_set, d.winner
      from duels d
      join live_matches m on m.duel = d.id
  ), earned as (
    select p.id,
           (p.total_reps
            + 20 * (select count(*) from played x
                     where x.id = p.id
                       and (x.winner is null or x.winner = p.id))
            - coalesce((select sum(s.reps) from played x
                          join sets s on s.id = x.set_id
                         where x.id = p.id
                           and x.winner is not null
                           and x.winner <> p.id), 0)
           )::int as xp
      from profiles p
  )
  update profiles p
     set xp = earned.xp
    from earned
   where earned.id = p.id
     and earned.xp > p.xp;
  perform set_config('outrepd.settling', 'off', true);
end;
$$;
