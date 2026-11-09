-- OUTREPD — telling people what happened while they were away.
--
-- This is the half of the async duel that was missing. You race somebody's
-- stored minute and see the result immediately; *they* were not there. Until
-- this file, nothing ever told them — their set was raced, their rank moved,
-- their record changed, and the app said nothing the next time they opened
-- it. A ladder people cannot feel themselves moving on is a ladder nobody
-- plays twice.
--
-- Written by triggers rather than by the app, for the same reason the ladder
-- is: the person being told is not the person holding the phone. A client
-- cannot be asked to notify somebody else, because a client that can write
-- into somebody else's notifications can write anything it likes there.
--
-- Nothing here notifies you about your own actions. You were present for
-- those, and the screen already said so.

create table if not exists notifications (
  id          uuid primary key default gen_random_uuid(),

  -- Who it is for.
  profile_id  uuid not null references profiles on delete cascade,
  created_at  timestamptz not null default now(),
  read_at     timestamptz,

  kind text not null
       check (kind in ('raced', 'friend_request', 'friend_accepted', 'challenged', 'live_invite', 'passed',
                         'challenge_taken', 'challenge_back')),

  -- Who caused it. The id can go — accounts get deleted — so the name is
  -- kept beside it: a notification that has forgotten who it was about is
  -- worse than no notification.
  actor       uuid references profiles on delete set null,
  actor_name  text not null default '',

  -- Only for 'raced'. The counts are stored rather than looked up, because
  -- the sets they came from are the other half of a duel that is over, and
  -- this row has to still make sense in a year.
  duel_id     uuid references duels on delete cascade,
  you_won     bool,
  your_reps   int,
  their_reps  int
);

-- Only for 'raced': what the duel did to the raced lifter's LP, so the card
-- they share from the notification can say it. Null for an unranked duel,
-- which moves nothing. Added after the table, so an existing one gains it.
alter table notifications add column if not exists lp_delta int;

-- Only for 'challenge_taken' and 'challenge_back' (challenge.sql): the code
-- of the challenge the notice opens. your_reps and their_reps are the owner's
-- count and the taker's, and you_won whether the owner's held.
alter table notifications add column if not exists challenge_code text;

-- For a project that already has the table from before 'challenged' and
-- 'live_invite' (live.sql) existed.
alter table notifications drop constraint if exists notifications_kind_check;
alter table notifications add constraint notifications_kind_check
  check (kind in ('raced', 'friend_request', 'friend_accepted', 'challenged', 'live_invite', 'passed',
                         'challenge_taken', 'challenge_back'));

-- Everything reads "mine, newest first", and the badge counts the unread.
create index if not exists notifications_for_profile_idx
  on notifications (profile_id, created_at desc);
create index if not exists notifications_unread_idx
  on notifications (profile_id) where read_at is null;
-- The foreign keys' own indexes, for deleting an account or a duel; see
-- sets_challenge_target_idx in schema.sql.
create index if not exists notifications_actor_idx
  on notifications (actor) where actor is not null;
create index if not exists notifications_duel_idx
  on notifications (duel_id) where duel_id is not null;

alter table notifications enable row level security;

-- Yours and nobody else's. There is deliberately no insert policy: every row
-- here is written by a trigger below, and a client that could insert one
-- could tell somebody they had been beaten by anyone it liked.
drop policy if exists "a lifter reads their own notifications" on notifications;
create policy "a lifter reads their own notifications"
  on notifications for select
  to authenticated
  using ((select auth.uid()) = profile_id);

drop policy if exists "a lifter clears their own notifications" on notifications;
create policy "a lifter clears their own notifications"
  on notifications for delete
  to authenticated
  using ((select auth.uid()) = profile_id);

-- ──────────────────────────── being raced ────────────────────────────────────

-- The defender finds out.
--
-- `settle_duel` inserts the duel, so this fires inside it. The challenger is
-- not told: they are the one who just watched it happen.
create or replace function notify_defender()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  challenger_name text;
  mine int;
  theirs int;
begin
  if not exists (
    select 1 from profiles
     where id = new.defender and notify_raced
  ) then
    return new;
  end if;

  select username into challenger_name from profiles where id = new.challenger;
  select reps into theirs from sets where id = new.challenger_set;
  select reps into mine   from sets where id = new.defender_set;

  insert into notifications (
    profile_id, kind, actor, actor_name,
    duel_id, you_won, your_reps, their_reps, lp_delta
  ) values (
    new.defender, 'raced', new.challenger, coalesce(challenger_name, ''),
    new.id, new.winner = new.defender, mine, theirs,
    case when new.ranked then new.lp_defender end
  );

  return new;
end;
$$;

drop trigger if exists duels_notify_defender on duels;
create trigger duels_notify_defender
  after insert on duels
  for each row execute function notify_defender();

-- ─────────────────────────── friend requests ─────────────────────────────────

-- Somebody asked. A request nobody is told about is a request that sits
-- unanswered forever, which is how the friends screen ends up looking broken.
create or replace function notify_friend_request()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  asker text;
begin
  -- Only a real invitation. A row that arrives already accepted came from
  -- somebody asking back, and that case is handled below.
  if new.accepted_at is not null then
    return new;
  end if;

  if not exists (
    select 1 from profiles
     where id = new.addressee and notify_friend_request
  ) then
    return new;
  end if;

  select username into asker from profiles where id = new.requester;
  insert into notifications (profile_id, kind, actor, actor_name)
  values (new.addressee, 'friend_request', new.requester, coalesce(asker, ''));
  return new;
end;
$$;

drop trigger if exists friendships_notify_request on friendships;
create trigger friendships_notify_request
  after insert on friendships
  for each row execute function notify_friend_request();

-- And they said yes.
create or replace function notify_friend_accepted()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  accepter text;
begin
  -- Only on the moment it is accepted, not on every later write to the row.
  if old.accepted_at is not null or new.accepted_at is null then
    return new;
  end if;

  if not exists (
    select 1 from profiles
     where id = new.requester and notify_friend_ok
  ) then
    return new;
  end if;

  select username into accepter from profiles where id = new.addressee;
  insert into notifications (profile_id, kind, actor, actor_name)
  values (new.requester, 'friend_accepted', new.addressee,
          coalesce(accepter, ''));
  return new;
end;
$$;

drop trigger if exists friendships_notify_accepted on friendships;
create trigger friendships_notify_accepted
  after update on friendships
  for each row execute function notify_friend_accepted();

-- ────────────────────────────── being challenged ──────────────────────────────

-- Somebody reserved a set naming this account — a rematch. Fires from `sets`
-- rather than `duels`: a challenge is not a duel yet, it is one set waiting
-- for the other half, which is exactly the moment the target has to be told.
create or replace function notify_challenged()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  challenger_name text;
begin
  if new.challenge_target is null then
    return new;
  end if;

  if not exists (
    select 1 from profiles
     where id = new.challenge_target and notify_challenged
  ) then
    return new;
  end if;

  -- Blocked either way round: the set is stored, find_targeted_set will
  -- never hand it over, and nobody is told — the one who sent it least of
  -- all, since a block is not announced.
  if exists (
    select 1 from blocks b
     where (b.blocker = new.challenge_target and b.blocked = new.profile_id)
        or (b.blocker = new.profile_id and b.blocked = new.challenge_target)
  ) then
    return new;
  end if;

  select username into challenger_name from profiles where id = new.profile_id;
  insert into notifications (profile_id, kind, actor, actor_name)
  values (new.challenge_target, 'challenged', new.profile_id,
          coalesce(challenger_name, ''));
  return new;
end;
$$;

drop trigger if exists sets_notify_challenged on sets;
create trigger sets_notify_challenged
  after insert on sets
  for each row execute function notify_challenged();

-- ──────────────────────────── being passed ────────────────────────────────────

-- A friend passed you on this week's board (the user's pick, 2026-11-09): the
-- one moment in a race worth hearing about while away. Only between friends,
-- where a place means something and the board is small enough to feel; never
-- the one this duel was against, who was told it was raced; nobody who has not
-- scored this week, for whom "passed" is not true. At most once a day for the
-- same friend and three a day in all, or a busy circle is a phone that never
-- stops buzzing. Muted with the races (notify_raced). Deferred to the end of
-- the duel's transaction, like season_points_add: a live duel's points are
-- final only then.
create or replace function notify_passed()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  d duels;
  since timestamptz := week_start(now());
  side record;
  friend record;
  now_points int;
  theirs int;
  passer text;
begin
  select * into d from duels where id = new.id;
  if d.id is null or not d.ranked then
    return null;
  end if;
  for side in
    select d.challenger as pid, coalesce(d.pts_challenger, 0) as gained,
           d.defender as other
    union all
    select d.defender, coalesce(d.pts_defender, 0), d.challenger
  loop
    continue when side.gained <= 0;
    now_points := week_points_of(side.pid, since);
    select username into passer from profiles where id = side.pid;
    for friend in
      select case when f.requester = side.pid then f.addressee
                  else f.requester end as fid
        from friendships f
       where f.accepted_at is not null
         and (f.requester = side.pid or f.addressee = side.pid)
    loop
      continue when friend.fid = side.other;
      continue when not exists (
        select 1 from profiles p
         where p.id = friend.fid and p.notify_raced and p.placements_done >= 5);
      theirs := week_points_of(friend.fid, since);
      -- Level or ahead before this duel, behind after it.
      continue when theirs <= 0
                 or theirs < now_points - side.gained
                 or theirs >= now_points;
      continue when exists (
        select 1 from blocks b
         where (b.blocker = friend.fid and b.blocked = side.pid)
            or (b.blocker = side.pid and b.blocked = friend.fid));
      continue when exists (
        select 1 from notifications n
         where n.profile_id = friend.fid and n.kind = 'passed'
           and n.actor = side.pid
           and n.created_at > now() - interval '20 hours');
      continue when (
        select count(*) from notifications n
         where n.profile_id = friend.fid and n.kind = 'passed'
           and n.created_at > now() - interval '24 hours') >= 3;
      insert into notifications (profile_id, kind, actor, actor_name)
      values (friend.fid, 'passed', side.pid, coalesce(passer, ''));
    end loop;
  end loop;
  return null;
end;
$$;

drop trigger if exists duels_notify_passed on duels;
create constraint trigger duels_notify_passed
  after insert on duels
  deferrable initially deferred
  for each row execute function notify_passed();

-- ──────────────────────────────── reading ────────────────────────────────────

-- Mine, newest first.
--
-- Dropped first: Postgres refuses `create or replace` when a table-returning
-- function's column set changes shape (adding `actor` and `lp_delta` did),
-- and fails with a "cannot change return type" error that names DROP as the
-- fix.
-- with_passed: an app that knows the notice of being passed asks for it; one
-- from before would show it as a race it cannot read. with_challenges, the
-- same for a challenge by link being taken or sent back.
drop function if exists my_notifications(int);
drop function if exists my_notifications(int, boolean);
drop function if exists my_notifications(int, boolean, boolean);
create or replace function my_notifications(
  limit_to int default 50,
  with_passed boolean default false,
  with_challenges boolean default false
)
returns table (
  id uuid,
  kind text,
  created_at timestamptz,
  unread boolean,
  actor uuid,
  actor_name text,
  you_won boolean,
  your_reps int,
  their_reps int,
  lp_delta int,
  challenge_code text
)
language sql
stable
set search_path = public
as $$
  select n.id, n.kind, n.created_at, n.read_at is null,
         n.actor, n.actor_name, n.you_won, n.your_reps, n.their_reps,
         n.lp_delta, n.challenge_code
    from notifications n
   where n.profile_id = auth.uid()
     and (with_passed or n.kind <> 'passed')
     and (with_challenges
          or n.kind not in ('challenge_taken', 'challenge_back'))
   order by n.created_at desc
   limit least(greatest(limit_to, 1), 200);
$$;

-- What the dot on the bell is counting.
drop function if exists unread_notifications();
drop function if exists unread_notifications(boolean);
drop function if exists unread_notifications(boolean, boolean);
create or replace function unread_notifications(
  with_passed boolean default false,
  with_challenges boolean default false
)
returns int
language sql
stable
set search_path = public
as $$
  select count(*)::int from notifications
   where profile_id = auth.uid() and read_at is null
     and (with_passed or kind <> 'passed')
     and (with_challenges
          or kind not in ('challenge_taken', 'challenge_back'));
$$;

-- Marks the lot as read, which is what opening the screen means.
--
-- A function rather than an update policy: the only thing anybody may change
-- about a notification is whether they have seen it, and a policy broad
-- enough to allow that is broad enough to let somebody rewrite what it says.
create or replace function read_notifications()
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  touched int;
begin
  update notifications set read_at = now()
   where profile_id = auth.uid() and read_at is null;
  get diagnostics touched = row_count;
  return touched;
end;
$$;

revoke all on function my_notifications(int, boolean, boolean) from public;
grant execute on function my_notifications(int, boolean, boolean) to authenticated;
revoke all on function unread_notifications(boolean, boolean) from public;
grant execute on function unread_notifications(boolean, boolean) to authenticated;
revoke all on function read_notifications() from public;
grant execute on function read_notifications() to authenticated;
