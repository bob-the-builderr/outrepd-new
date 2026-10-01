-- OUTREPD — the people you know.
--
-- One table and four calls. A friendship is a single row rather than two
-- mirrored ones, because two rows can disagree: accept one and not the other
-- and the app has a friend who does not have you back.
--
-- The row is keyed on (requester, addressee) and read from both ends, so
-- "who asked" survives — it is the difference between an invitation waiting
-- on you and one waiting on them, and the screen has to say which.
--
-- What is deliberately NOT here:
--
--   * A friend cannot see anything they could not already see. Profiles were
--     public to signed-in lifters before this file existed; being friends
--     adds the head-to-head, which is read out of duels the two already
--     played against each other.
--   * No presence service. "Online" is `last_seen` within a few minutes,
--     written by the app when it opens. It costs one column and one update
--     instead of a socket per lifter, and the answer it gives — "around
--     recently" — is the one the screen actually needs.

-- ──────────────────────────────── last seen ──────────────────────────────────

-- When this account last had the app open.
--
-- Not guarded like the ladder columns: there is nothing to gain by lying
-- about it, and it is the one thing on a profile a client legitimately owns.
alter table profiles add column if not exists
  last_seen timestamptz not null default now();

-- ─────────────────────────────── friendships ─────────────────────────────────

create table if not exists friendships (
  requester   uuid not null references profiles on delete cascade,
  addressee   uuid not null references profiles on delete cascade,
  created_at  timestamptz not null default now(),

  -- Null while the request is still waiting. A status column would need a
  -- check constraint and could hold 'accepted' with no date; this cannot.
  accepted_at timestamptz,

  primary key (requester, addressee),

  -- Nobody is their own friend, and the ladder would have to decide what a
  -- duel against yourself pays.
  check (requester <> addressee)
);

-- Both directions get an index: every query here asks "who is this person to
-- me", and half of those arrive from the other end of the row.
create index if not exists friendships_addressee_idx
  on friendships (addressee, accepted_at);
create index if not exists friendships_requester_idx
  on friendships (requester, accepted_at);

alter table friendships enable row level security;

-- A row is visible to the two people in it and to nobody else. A friends
-- list is not public information, and who asked whom is less so.
drop policy if exists "a lifter reads their own friendships" on friendships;
create policy "a lifter reads their own friendships"
  on friendships for select
  to authenticated
  using (auth.uid() = requester or auth.uid() = addressee);

-- No insert and no update from the phone: asking goes through
-- request_friend_with and answering through answer_friend, both below. The
-- table used to take both directly, as long as the caller's own id was on
-- the row — which let a phone write a request that arrived already accepted,
-- skip the block check on the way, or, holding a request, rewrite who it was
-- from and become friends with somebody who never asked.
drop policy if exists "a lifter asks in their own name" on friendships;
drop policy if exists "only the asked may answer" on friendships;

-- Either side can end it, and either side can withdraw a request that has
-- not been answered.
drop policy if exists "either side may end it" on friendships;
create policy "either side may end it"
  on friendships for delete
  to authenticated
  using (auth.uid() = requester or auth.uid() = addressee);

-- ──────────────────────────────── asking ─────────────────────────────────────

-- Everything asking somebody shares once the target's id is known — only how
-- that id was found (by name, by code) differs between the two functions
-- below. Kept as one body so a rule about asking (blocked, already asked you,
-- already friends) is a rule in one place instead of two copies drifting
-- apart the next time either changes.
--
-- `security definer`, for one reason: it has to see a block made *against*
-- the caller, and the blocks policy deliberately shows a row only to whoever
-- made it. Every write below still names `auth.uid()` explicitly, so the
-- extra rights buy the check and nothing else.
create or replace function request_friend_with(them uuid)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  theirs friendships;
begin
  if them = auth.uid() then
    return 'that is you';
  end if;

  -- Blocked, either way round. The same answer as a name that does not
  -- exist, deliberately: telling somebody they have been blocked is the one
  -- thing a block is supposed not to do, and an error that says "blocked"
  -- tells them.
  if exists (
    select 1 from blocks b
    where (b.blocker = auth.uid() and b.blocked = them)
       or (b.blocker = them and b.blocked = auth.uid())
  ) then
    return 'no such lifter';
  end if;

  -- They already asked you. Asking back is the same thing as saying yes, and
  -- making somebody find the request screen to agree to what they just asked
  -- for is a worse app.
  --
  -- Tested with `found` rather than `theirs is not null`: on a composite,
  -- IS NOT NULL means *every* field is filled, and a pending row always has
  -- a null accepted_at — so the obvious spelling would silently miss exactly
  -- the case this branch exists for.
  select * into theirs from friendships
   where requester = them and addressee = auth.uid();
  if found then
    if theirs.accepted_at is null then
      update friendships set accepted_at = now()
       where requester = them and addressee = auth.uid();
    end if;
    return 'friends';
  end if;

  -- Already asked, or already friends: nothing new to send.
  if exists (
    select 1 from friendships
     where requester = auth.uid() and addressee = them
  ) then
    return 'asked';
  end if;

  -- Each request is a notice and a push on their phone. Withdrawn and sent
  -- again, it is another one, so how often is counted: a few times a day to
  -- any one lifter, and forty new people a day in all. Past that the answer
  -- reads the same as a request that went — nothing is sent.
  if not within_rate('friend_request_to', interval '1 day', 3, them)
     or not within_rate('friend_request', interval '1 day', 40) then
    return 'asked';
  end if;

  insert into friendships (requester, addressee)
  values (auth.uid(), them)
  on conflict (requester, addressee) do nothing;

  return 'asked';
end;
$$;

-- Send a friend request, by name.
--
-- By name because that is what somebody has: you know what your friend calls
-- themselves, not their uuid. Returns the state the pair ended up in, so the
-- app can tell "asked" from "you are now friends" without asking again.
create or replace function request_friend(their_name text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  them uuid;
begin
  -- Case-insensitive, as find_lifters is: usernames keep the case they were
  -- typed in, and nobody remembers whether a friend capitalised theirs.
  select id into them from profiles
   where lower(username) = lower(trim(their_name));
  if them is null then
    return 'no such lifter';
  end if;
  return request_friend_with(them);
end;
$$;

-- Send a friend request, by their #code instead of their name.
--
-- The code exists so adding somebody never requires the name shown on the
-- ladder — see the comment on the friend_code column in schema.sql. A
-- leading '#' is accepted and stripped rather than required, since the
-- client shows the code with one but the stored value never has it.
create or replace function request_friend_by_code(code text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  them uuid;
  cleaned text := trim(leading '#' from trim(code));
begin
  select id into them from profiles where friend_code = cleaned;
  if them is null then
    return 'no such lifter';
  end if;
  return request_friend_with(them);
end;
$$;

-- Answer a request that is waiting on you.
--
-- Declining deletes the row rather than marking it: a declined request that
-- lingers is a record of a small rejection kept on a server forever, and it
-- would also stop them ever asking again.
-- Security definer, since nothing on the phone may update the table itself;
-- every write here names the caller as the one who was asked.
create or replace function answer_friend(their_id uuid, accept boolean)
returns text
language plpgsql
security definer
set search_path = public
as $$
begin
  if accept then
    update friendships set accepted_at = now()
     where requester = their_id and addressee = auth.uid()
       and accepted_at is null;
    return case when found then 'friends' else 'nothing to answer' end;
  end if;

  delete from friendships
   where requester = their_id and addressee = auth.uid()
     and accepted_at is null;
  return 'declined';
end;
$$;

-- ──────────────────────────────── reading ────────────────────────────────────

-- Everybody this account is actually friends with, and what stands between
-- them.
--
-- The head-to-head is the reason a row is worth tapping. A rank says how good
-- somebody is in general; "0W 4L against you" is a score to settle. It is
-- counted out of ranked *and* friend duels, because a duel that happened
-- happened — the ladder ignores friend rooms, a grudge does not.
--
-- Dropped first: Postgres refuses `create or replace` when a table-returning
-- function's column set changes shape (adding avatar_url did), and fails
-- with a "cannot change return type" error that names DROP as the fix.
drop function if exists my_friends();
create or replace function my_friends()
returns table (
  id uuid,
  username text,
  tier_idx int,
  div_idx int,
  lp int,
  placements_done int,
  last_seen timestamptz,
  wins_vs_you int,
  losses_vs_you int,
  avatar_url text
)
language sql
stable
security definer
set search_path = public
as $$
  with mine as (
    select case when f.requester = auth.uid() then f.addressee
                else f.requester end as friend_id
      from friendships f
     where f.accepted_at is not null
       and (f.requester = auth.uid() or f.addressee = auth.uid())
  )
  select p.id,
         p.username,
         p.tier_idx,
         p.div_idx,
         p.lp,
         p.placements_done,
         p.last_seen,
         -- Duels are readable only by the two people in them, so this counts
         -- exactly the ones the caller was part of without needing to say so.
         coalesce(count(*) filter (where d.winner = p.id), 0)::int,
         coalesce(count(*) filter (where d.winner = auth.uid()), 0)::int,
         p.avatar_url
    from mine
    join profiles p on p.id = mine.friend_id
    left join duels d
      on (d.challenger = auth.uid() and d.defender = p.id)
      or (d.defender = auth.uid() and d.challenger = p.id)
   group by p.id, p.username, p.tier_idx, p.div_idx, p.lp,
            p.placements_done, p.last_seen, p.avatar_url
   order by p.last_seen desc;
$$;

-- Requests waiting on an answer from this account, oldest first — with
-- enough about whoever asked (photo, rank, best set, record) to decide on,
-- rather than a bare name.
--
-- Dropped first: adding columns changes the table it returns, which
-- `create or replace` refuses.
drop function if exists friend_requests();
create or replace function friend_requests()
returns table (
  id uuid,
  username text,
  tier_idx int,
  div_idx int,
  asked_at timestamptz,
  placements_done int,
  best_set int,
  wins int,
  losses int,
  avatar_url text
)
language sql
stable
security definer
set search_path = public
as $$
  select p.id, p.username, p.tier_idx, p.div_idx, f.created_at,
         p.placements_done, p.best_set, p.wins, p.losses, p.avatar_url
    from friendships f
    join profiles p on p.id = f.requester
   where f.addressee = auth.uid()
     and f.accepted_at is null
   order by f.created_at;
$$;

-- Usernames keep whoever's case they were typed in (see set_my_username), so
-- finding one by name is always a case-insensitive comparison. A plain index
-- on `username` cannot serve that — Postgres only uses a btree for LIKE-style
-- matching when the indexed expression matches the comparison byte-for-byte,
-- collation included. This is the expression find_lifters() below actually
-- compares against, so it is the one that keeps every search a fast prefix
-- lookup instead of a sequential scan once there are many accounts to scan.
create index if not exists profiles_username_prefix_idx
  on profiles (lower(username) text_pattern_ops);

-- Find somebody to add, by the start of their name.
--
-- Capped hard and never open-ended: this is the one call that hands back
-- people the caller has no relationship with, so it answers a specific
-- question ("is my friend on here under this name") rather than enumerating
-- the userbase. A blank query returns nothing at all.
--
-- See the comment on my_friends() above — same reason, same fix.
drop function if exists find_lifters(text, int);
create or replace function find_lifters(query text, limit_to int default 10)
returns table (
  id uuid,
  username text,
  tier_idx int,
  div_idx int,
  placements_done int,
  avatar_url text
)
language sql
stable
security definer
set search_path = public
as $$
  select p.id, p.username, p.tier_idx, p.div_idx, p.placements_done,
         p.avatar_url
    from profiles p
   where length(trim(query)) >= 2
     and p.id <> auth.uid()
     -- Same comparison as profiles_username_prefix_idx above, on purpose:
     -- ilike would read identically but plans as a sequential scan, because
     -- nothing ties it back to that index.
     and lower(p.username) like lower(trim(query)) || '%'
     -- Somebody blocked, in either direction, is simply not there. A search
     -- that still turns them up is a block that only half works.
     and not exists (
       select 1 from blocks b
       where (b.blocker = auth.uid() and b.blocked = p.id)
          or (b.blocker = p.id and b.blocked = auth.uid())
     )
   order by p.username
   limit least(greatest(limit_to, 1), 25);
$$;

-- ──────────────────────────────── blocking ───────────────────────────────────

-- Block somebody, and end whatever was between you.
--
-- The friendship goes with it. Staying friends with somebody you have just
-- blocked is a state nothing in the app could draw honestly, and it would
-- leave them on your friends list where they can see you are still there.
create or replace function block_lifter(their_id uuid)
returns text
language plpgsql
as $$
begin
  if their_id = auth.uid() then
    return 'that is you';
  end if;

  insert into blocks (blocker, blocked)
  values (auth.uid(), their_id)
  on conflict (blocker, blocked) do nothing;

  delete from friendships
   where (requester = auth.uid() and addressee = their_id)
      or (requester = their_id and addressee = auth.uid());

  return 'blocked';
end;
$$;

create or replace function unblock_lifter(their_id uuid)
returns text
language plpgsql
as $$
begin
  delete from blocks where blocker = auth.uid() and blocked = their_id;
  return 'unblocked';
end;
$$;

-- Who this account has blocked, newest first. Only ever their own list.
create or replace function my_blocks()
returns table (
  id uuid,
  username text,
  blocked_at timestamptz
)
language sql
stable
security definer
set search_path = public
as $$
  select p.id, p.username, b.created_at
    from blocks b
    join profiles p on p.id = b.blocked
   where b.blocker = auth.uid()
   order by b.created_at desc;
$$;

-- ───────────────────────────────── muting ────────────────────────────────────

-- Mute somebody. Nothing else changes: the friendship stands, the profile
-- stays visible, and they are not told — a block is the loud version of
-- this, and this is the one for somebody you are simply tired of racing.
create or replace function mute_lifter(their_id uuid)
returns text
language plpgsql
as $$
begin
  if their_id = auth.uid() then
    return 'that is you';
  end if;

  insert into mutes (muter, muted)
  values (auth.uid(), their_id)
  on conflict (muter, muted) do nothing;

  return 'muted';
end;
$$;

create or replace function unmute_lifter(their_id uuid)
returns text
language plpgsql
as $$
begin
  delete from mutes where muter = auth.uid() and muted = their_id;
  return 'unmuted';
end;
$$;

-- Who this account has muted, newest first. Only ever their own list.
create or replace function my_mutes()
returns table (
  id uuid,
  username text,
  muted_at timestamptz
)
language sql
stable
security definer
set search_path = public
as $$
  select p.id, p.username, m.created_at
    from mutes m
    join profiles p on p.id = m.muted
   where m.muter = auth.uid()
   order by m.created_at desc;
$$;

-- ──────────────────────────────── the board ──────────────────────────────────

-- The board, best first, with everybody who asked to be left off it left off.
--
-- A function rather than a query from the phone, because "show me on
-- leaderboards" has to hold even when the client does not feel like adding
-- the filter. Placed accounts only: a tier on an account still in placements
-- is a column with something in it, not a rank it earned.
--
-- See the comment on my_friends() above — same reason, same fix.
-- [in_tier_idx]/[in_div_idx] narrow the board to one rung of the ladder — the
-- "ranked within your tier" list, where everybody on it is already level
-- with everybody else, and lp is what is left to tell them apart.
drop function if exists leaderboard(text, int);
create or replace function leaderboard(
  in_country text default null,
  limit_to int default 100,
  in_tier_idx int default null,
  in_div_idx int default null
)
returns table (
  id uuid,
  username text,
  tier_idx int,
  div_idx int,
  lp int,
  wins int,
  losses int,
  avatar_url text
)
language sql
stable
security definer
set search_path = public
as $$
  select p.id, p.username, p.tier_idx, p.div_idx, p.lp, p.wins, p.losses,
         p.avatar_url
    from profiles p
   where p.placements_done >= 5
     and p.show_on_board
     and (in_country is null
          or (p.country = in_country and p.show_country))
     and (in_tier_idx is null or p.tier_idx = in_tier_idx)
     and (in_div_idx is null or p.div_idx = in_div_idx)
   order by p.tier_idx desc, p.div_idx desc, p.lp desc
   limit least(greatest(limit_to, 1), 500);
$$;

-- Where an account stands on that board, counting from 1, or null when it is
-- not on one. The same rules as above, so the number and the list can never
-- disagree about who is on it.
--
-- Takes whose place to compute rather than always asking about the caller,
-- so a profile card can show somebody else's position with the exact same
-- rules `my_board_place` uses for your own.
create or replace function board_place(for_id uuid, in_country text default null)
returns int
language sql
stable
security definer
set search_path = public
as $$
  select case
    when not exists (
      select 1 from profiles who
       where who.id = for_id
         and who.placements_done >= 5
         and who.show_on_board
         and (in_country is null
              or (who.country = in_country and who.show_country))
    ) then null
    else (
      select count(*)::int + 1
        from profiles p, profiles who
       where who.id = for_id
         and p.placements_done >= 5
         and p.show_on_board
         and (in_country is null
              or (p.country = in_country and p.show_country))
         and (p.tier_idx > who.tier_idx
           or (p.tier_idx = who.tier_idx and p.div_idx > who.div_idx)
           or (p.tier_idx = who.tier_idx and p.div_idx = who.div_idx
               and p.lp > who.lp))
    )
  end;
$$;

create or replace function my_board_place(in_country text default null)
returns int
language sql
stable
security definer
set search_path = public
as $$
  select board_place(auth.uid(), in_country);
$$;

-- ─────────────────────────────── a lifter's card ─────────────────────────────

-- Everything a profile card needs about somebody else, in one call rather
-- than the half-dozen a screen built from parts would need to make and then
-- hope agree with each other.
--
-- `security definer`, because the head-to-head reads both sides of a duel's
-- two sets — theirs as well as yours — and a set is normally readable only
-- by the lifter who did it. Every other function here works without that
-- because none of them needed to read a stranger's set; this is the first
-- that does.
--
-- See the comment on my_friends() above — same reason, same fix.
drop function if exists lifter_profile(uuid);
create or replace function lifter_profile(their_id uuid)
returns table (
  id uuid,
  username text,
  tier_idx int,
  div_idx int,
  lp int,
  placements_done int,
  total_reps int,
  best_set int,
  wins int,
  losses int,
  win_streak int,
  global_place int,
  country text,
  country_place int,
  is_friend bool,
  wins_vs_you int,
  losses_vs_you int,
  your_best_vs_them int,
  last_duel_at timestamptz,
  last_your_reps int,
  last_their_reps int,
  avatar_url text,
  title text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
begin
  if their_id = me then
    raise exception 'use your own profile screen for that';
  end if;

  return query
  with h2h as (
    select
      d.created_at,
      case when d.challenger = me then cs.reps else ds.reps end as your_reps,
      case when d.challenger = me then ds.reps else cs.reps end as their_reps,
      (d.winner = me)::int      as you_won,
      (d.winner = their_id)::int as they_won
    from duels d
    join sets cs on cs.id = d.challenger_set
    join sets ds on ds.id = d.defender_set
    where (d.challenger = me and d.defender = their_id)
       or (d.challenger = their_id and d.defender = me)
  ),
  last as (
    select * from h2h order by created_at desc limit 1
  )
  select
    p.id, p.username, p.tier_idx, p.div_idx, p.lp, p.placements_done,
    p.total_reps, p.best_set, p.wins, p.losses, p.win_streak,
    -- Their country only if they chose to show it: the setting says "show
    -- my country", and a card that showed it anyway would make it a lie.
    board_place(p.id, null),
    case when p.show_country then p.country end,
    case when p.country is null or not p.show_country then null
         else board_place(p.id, p.country) end,
    exists (
      select 1 from friendships f
       where f.accepted_at is not null
         and ((f.requester = me and f.addressee = their_id)
           or (f.requester = their_id and f.addressee = me))
    ),
    -- wins_vs_you/losses_vs_you keep the same meaning as my_friends() above:
    -- wins_vs_you is theirs, losses_vs_you is yours. Swapping these would
    -- read as somebody's record flipped on every profile that opens on it.
    (select coalesce(sum(they_won), 0) from h2h)::int,
    (select coalesce(sum(you_won), 0) from h2h)::int,
    (select max(your_reps) from h2h),
    (select created_at from last),
    (select your_reps from last),
    (select their_reps from last),
    p.avatar_url,
    p.title
  from profiles p
  where p.id = their_id;
end;
$$;

-- ───────────────────────────── the public card ───────────────────────────────

-- What a share card shows, for whoever a link reaches — the landing site's
-- /u/<username> page calls this signed out, which is the one place in the
-- app that has nobody signed in to check `to authenticated` against.
--
-- `security definer` for exactly that reason. Narrower than [lifter_profile]
-- on purpose: nothing about anybody else's relationship to this account, and
-- nothing that was not already true on the card the lifter chose to share.
--
-- See the comment on my_friends() above — same reason, same fix.
drop function if exists public_lifter_card(text);
create or replace function public_lifter_card(their_username text)
returns table (
  username text,
  tier_idx int,
  div_idx int,
  lp int,
  wins int,
  losses int,
  best_set int,
  win_streak int,
  global_place int,
  country text,
  country_place int,
  avatar_url text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  who profiles;
begin
  select * into who from profiles where profiles.username = their_username;
  if who is null then
    return;
  end if;

  return query
  select
    who.username, who.tier_idx, who.div_idx, who.lp, who.wins, who.losses,
    who.best_set, who.win_streak,
    board_place(who.id, null),
    case when who.show_country then who.country end,
    case when who.country is null or not who.show_country then null
         else board_place(who.id, who.country) end,
    who.avatar_url;
end;
$$;

revoke all on function request_friend_with(uuid) from public;
grant execute on function request_friend_with(uuid) to authenticated;
revoke all on function request_friend(text) from public;
grant execute on function request_friend(text) to authenticated;
revoke all on function request_friend_by_code(text) from public;
grant execute on function request_friend_by_code(text) to authenticated;
revoke all on function answer_friend(uuid, boolean) from public;
grant execute on function answer_friend(uuid, boolean) to authenticated;
revoke all on function my_friends() from public;
grant execute on function my_friends() to authenticated;
revoke all on function friend_requests() from public;
grant execute on function friend_requests() to authenticated;
revoke all on function find_lifters(text, int) from public;
grant execute on function find_lifters(text, int) to authenticated;
revoke all on function block_lifter(uuid) from public;
grant execute on function block_lifter(uuid) to authenticated;
revoke all on function unblock_lifter(uuid) from public;
grant execute on function unblock_lifter(uuid) to authenticated;
revoke all on function my_blocks() from public;
grant execute on function my_blocks() to authenticated;
revoke all on function leaderboard(text, int, int, int) from public;
grant execute on function leaderboard(text, int, int, int) to authenticated;
revoke all on function my_board_place(text) from public;
grant execute on function my_board_place(text) to authenticated;
revoke all on function board_place(uuid, text) from public;
grant execute on function board_place(uuid, text) to authenticated;
revoke all on function mute_lifter(uuid) from public;
grant execute on function mute_lifter(uuid) to authenticated;
revoke all on function unmute_lifter(uuid) from public;
grant execute on function unmute_lifter(uuid) to authenticated;
revoke all on function my_mutes() from public;
grant execute on function my_mutes() to authenticated;
revoke all on function lifter_profile(uuid) from public;
grant execute on function lifter_profile(uuid) to authenticated;
-- The one function in this file anon may call: it is what a share link is
-- for. Also granted to authenticated, since the app itself is signed in
-- when it renders your own card.
revoke all on function public_lifter_card(text) from public;
grant execute on function public_lifter_card(text) to anon, authenticated;
