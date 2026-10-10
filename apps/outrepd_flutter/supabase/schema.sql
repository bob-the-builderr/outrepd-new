-- OUTREPD — the smallest schema that makes a duel real.
--
-- Three tables. A profile is who somebody is on the ladder; a set is one
-- minute of push-ups with the evidence behind the count; a duel is two sets
-- compared. Everything else the app shows — history, the board, the accuracy
-- record — is a query over these.
--
-- Two rules run through the whole file, and both exist because the client is
-- a phone in somebody else's hands:
--
--   1. **Nobody writes their own rank.** Not the tier, not the LP, not the
--      win count. Those columns are written by `settle_duel` and by nothing
--      else. A client that could write them could type itself to the top.
--   2. **A score carries its evidence.** Every set stores what the camera
--      counted *and* what the lifter confirmed, because today the lifter has
--      the last word and one day a server may need to check. Evidence cannot
--      be added to matches that are already over, so it is stored from the
--      first row.

-- ─────────────────────────────── profiles ────────────────────────────────────

create table if not exists profiles (
  id            uuid primary key references auth.users on delete cascade,
  username      text not null unique
                check (char_length(username) between 2 and 20),
  -- Null until `set_my_username` has been called once. Every account gets
  -- exactly one rename, and this is what `set_my_username` checks to know
  -- whether that one has already been spent.
  username_changed_at timestamptz,
  -- Points into the `avatars` storage bucket. Null means the drawn initial
  -- every screen already falls back to, not a broken image.
  avatar_url    text,
  country       text,
  created_at    timestamptz not null default now(),

  -- The ladder. Seven tiers of five divisions; LP runs 0..99 inside a
  -- division. `top_tier()` in ladder.sql is the same number.
  tier_idx      int  not null default 0 check (tier_idx between 0 and 6),
  div_idx       int  not null default 0 check (div_idx  between 0 and 4),
  lp            int  not null default 0 check (lp between 0 and 99),

  -- The floor: the highest tier ever held. A tier once reached is kept, so a
  -- losing streak can cost divisions and never the tier itself.
  peak_tier_idx int  not null default 0 check (peak_tier_idx between 0 and 6),

  -- Placements. Until these are done there is no rank at all, which is the
  -- point of them.
  placements_done int not null default 0 check (placements_done between 0 and 5),
  placement_wins  int not null default 0 check (placement_wins  between 0 and 5),

  wins          int not null default 0 check (wins   >= 0),
  losses        int not null default 0 check (losses >= 0),
  win_streak    int not null default 0 check (win_streak  >= 0),
  best_streak   int not null default 0 check (best_streak >= 0),

  total_reps    int not null default 0 check (total_reps >= 0),
  best_set      int not null default 0 check (best_set   >= 0),

  -- ── what this lifter has asked for ──────────────────────────────────────
  --
  -- Preferences, not ladder state, so the guard below leaves them alone: a
  -- client may write these and only these about itself.

  -- Who may be handed this account's stored sets to race.
  challengeable text not null default 'everyone'
                check (challengeable in ('everyone', 'friends', 'nobody')),

  -- Whether to appear on the boards at all, and whether the country board is
  -- one of them. Enforced in `leaderboard()` rather than filtered on the
  -- phone, because a preference a client can skip is not a preference.
  show_on_board bool not null default true,
  show_country  bool not null default true,

  -- Which of the three things that actually happen are worth being told
  -- about. Checked by the triggers in notify.sql, so a notice somebody said
  -- they did not want is never written down in the first place.
  notify_raced          bool not null default true,
  notify_friend_request bool not null default true,
  notify_friend_ok      bool not null default true,
  notify_challenged     bool not null default true,

  updated_at    timestamptz not null default now()
);

-- For a project created before the preferences above existed.
alter table profiles add column if not exists challengeable text not null
  default 'everyone';
alter table profiles drop constraint if exists profiles_challengeable_check;
alter table profiles add constraint profiles_challengeable_check
  check (challengeable in ('everyone', 'friends', 'nobody'));
alter table profiles add column if not exists show_on_board bool not null
  default true;
alter table profiles add column if not exists show_country bool not null
  default true;
alter table profiles add column if not exists notify_raced bool not null
  default true;
alter table profiles add column if not exists notify_friend_request bool
  not null default true;
alter table profiles add column if not exists notify_friend_ok bool not null
  default true;
alter table profiles add column if not exists notify_challenged bool not null
  default true;
alter table profiles add column if not exists avatar_url text;
alter table profiles add column if not exists username_changed_at timestamptz;

-- The title this lifter wears beside their name, by its id in the app's list
-- (`first_blood`). Titles are earned on the phone, so all the server can check
-- is that it looks like an id; null is wearing nothing.
alter table profiles add column if not exists title text;
alter table profiles drop constraint if exists profiles_title_check;
alter table profiles add constraint profiles_title_check
  check (title is null or title ~ '^[a-z0-9_]{1,40}$');

comment on column profiles.lp is
  'Written by settle_duel only. The client cannot move its own rank.';

-- For a project created when the ladder had nine tiers.
--
-- `create table if not exists` above does nothing to a table that already
-- exists, so the narrower checks have to be applied by hand. Any account
-- sitting on a rung that no longer exists comes down to Master first — there
-- is nowhere else for it to be, and a row that violates its own constraint
-- cannot be written again by anything.
--
-- The guard trigger refuses writes to these columns, including this one, so
-- it is opened for the length of the transaction exactly the way settle_duel
-- does it.
do $$
begin
  perform set_config('outrepd.settling', 'on', true);
  update profiles
     set tier_idx      = least(tier_idx, 6),
         peak_tier_idx = least(peak_tier_idx, 6)
   where tier_idx > 6 or peak_tier_idx > 6;
  perform set_config('outrepd.settling', 'off', true);
end $$;

alter table profiles drop constraint if exists profiles_tier_idx_check;
alter table profiles add constraint profiles_tier_idx_check
  check (tier_idx between 0 and 6);
alter table profiles drop constraint if exists profiles_peak_tier_idx_check;
alter table profiles add constraint profiles_peak_tier_idx_check
  check (peak_tier_idx between 0 and 6);

-- The board reads this constantly, and always in the same order.
create index if not exists profiles_ladder_idx
  on profiles (tier_idx desc, div_idx desc, lp desc);

-- ──────────────────────────────── friend code ─────────────────────────────────

-- A short number that names an account the way a username does, without
-- being one. Usernames are already unique, so this is not for telling two
-- lifters apart — it is for adding one without having to hand over the name
-- shown on the ladder to do it.
create or replace function generate_friend_code()
returns text
language plpgsql
as $$
declare
  candidate text;
begin
  loop
    candidate := lpad(floor(random() * 1000000)::int::text, 6, '0');
    exit when not exists (
      select 1 from profiles where friend_code = candidate
    );
  end loop;
  return candidate;
end;
$$;

alter table profiles add column if not exists friend_code text unique;

-- Backfills any row from before this column existed, one at a time — an
-- ordinary multi-row UPDATE would hand every row the same snapshot of "codes
-- already taken" and could mint the same candidate for two rows in one go,
-- which the unique constraint would then simply refuse outright. A loop asks
-- fresh each time, the same reason settle_duel never batches a ladder change.
--
-- Guarded like the tier migration above: the guard trigger below refuses any
-- write to this column once it exists, and on a project where this has
-- already run once, it does.
do $$
declare
  r record;
begin
  perform set_config('outrepd.settling', 'on', true);
  for r in select id from profiles where friend_code is null loop
    update profiles set friend_code = generate_friend_code() where id = r.id;
  end loop;
  perform set_config('outrepd.settling', 'off', true);
end $$;

alter table profiles alter column friend_code set not null;
alter table profiles alter column friend_code set default generate_friend_code();

-- ──────────────────────────────── sets ───────────────────────────────────────

create table if not exists sets (
  id            uuid primary key default gen_random_uuid(),
  profile_id    uuid not null references profiles on delete cascade,
  created_at    timestamptz not null default now(),

  -- The two numbers, kept apart on purpose.
  --
  -- `reps_camera` is what the counter scored. `reps` is what the lifter
  -- confirmed, and it is the one that plays. Storing only the second would
  -- throw away the only measurement of the counter this project will ever
  -- have; storing only the first would mean the app had overruled somebody
  -- about their own set.
  reps          int  not null check (reps between 0 and 300),
  reps_camera   int  not null check (reps_camera between 0 and 300),

  -- How far a typical rep travelled against this lifter's own deepest, and
  -- whether the counter's three signals agreed. Both come out of the counter
  -- and both feed the LP.
  depth         real not null default 0 check (depth between 0 and 1),
  confident     bool not null default false,

  duration_ms   int  not null check (duration_ms > 0),

  -- Set when the lifter walked out mid-round. A duel that ends this way is a
  -- loss whatever the count said at the moment they left.
  gave_up       bool not null default false,

  -- When each rep landed, in milliseconds from the start of the set.
  --
  -- This is what lets an opponent's bar move at their own pace instead of
  -- their total spread evenly across the minute. Evenly is a lie — nobody is
  -- metronomic, and the last ten seconds of a minute of push-ups are nothing
  -- like the first — and racing a lie feels like racing a progress bar.
  --
  -- Small: a hundred reps is a hundred integers, a few hundred bytes. The
  -- pose recording it is read from is nine hundred kilobytes, which is why
  -- that one is not always kept and this one always is.
  rep_times     int[] not null default '{}'
                check (array_length(rep_times, 1) is null
                       or array_length(rep_times, 1) <= 300),

  -- The pose recording, when there is one. Deliberately not always: a minute
  -- of frames is about 900 KB, so the free tier holds roughly a thousand of
  -- them. Uploaded when the counter was unsure, or when the lifter offers it.
  recording_path text,

  -- Which duel consumed this set, if any. A set is faced once.
  claimed_by    uuid,

  -- Set only for a rematch: this set is not for the open pool, it is
  -- reserved for exactly this one lifter to find with `find_targeted_set`.
  -- Null is the ordinary case and means "anyone find_opponent_set matches".
  challenge_target uuid references profiles on delete set null
);

-- For a project that already has the table from an earlier paste.
alter table sets add column if not exists rep_times int[] not null default '{}';
alter table sets add column if not exists challenge_target uuid
  references profiles on delete set null;

create index if not exists sets_open_idx
  on sets (profile_id, created_at desc)
  where claimed_by is null;

-- Reps are counted when the set is stored, not when it is raced.
--
-- A set is push-ups somebody did. Counting them at settle time meant the
-- challenger's reps landed and the defender's never did — their set was raced
-- *by* somebody, and nothing ever added it to their own total.
create or replace function count_reps_of_set()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  perform set_config('outrepd.settling', 'on', true);
  update profiles set
    total_reps = total_reps + new.reps,
    best_set   = greatest(best_set, new.reps)
  where id = new.profile_id;
  perform set_config('outrepd.settling', 'off', true);
  return new;
end;
$$;

drop trigger if exists sets_count_reps on sets;
create trigger sets_count_reps
  after insert on sets
  for each row execute function count_reps_of_set();

-- ──────────────────────────────── duels ──────────────────────────────────────

create table if not exists duels (
  id            uuid primary key default gen_random_uuid(),
  created_at    timestamptz not null default now(),

  challenger    uuid not null references profiles on delete cascade,
  defender      uuid not null references profiles on delete cascade,
  challenger_set uuid not null references sets on delete cascade,
  defender_set   uuid not null references sets on delete cascade,

  -- Null on a draw, which the reps allow and the ladder has to survive.
  winner        uuid references profiles on delete set null,

  -- A friend room is a real duel and not a rung. Unranked duels are recorded
  -- and pay nothing: not LP, not the win record the ladder is built on.
  ranked        bool not null default true,

  lp_challenger int not null default 0,
  lp_defender   int not null default 0,

  check (challenger <> defender)
);

create index if not exists duels_for_profile_idx
  on duels (challenger, created_at desc);
create index if not exists duels_against_profile_idx
  on duels (defender, created_at desc);

-- ───────────────────────────── row level security ────────────────────────────

alter table profiles enable row level security;
alter table sets     enable row level security;
alter table duels    enable row level security;

-- Anyone signed in can read any profile: that is what a leaderboard is.
drop policy if exists "profiles are public to signed-in lifters" on profiles;
create policy "profiles are public to signed-in lifters"
  on profiles for select
  to authenticated
  using (true);

drop policy if exists "a lifter creates their own profile" on profiles;
create policy "a lifter creates their own profile"
  on profiles for insert
  to authenticated
  with check (auth.uid() = id);

-- The only columns a lifter may change about themselves are the ones that are
-- about them rather than about their standing. The ladder columns are locked
-- by the trigger below, because a column list in a policy cannot express
-- "these may change and those may not".
drop policy if exists "a lifter edits their own profile" on profiles;
create policy "a lifter edits their own profile"
  on profiles for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

create or replace function guard_ladder_columns()
returns trigger
language plpgsql
as $$
begin
  -- What other lifters see, and so what a client must not write around the
  -- rules for: a name that skipped set_my_username's checks and its one
  -- rename, or a picture loaded from some other server, which would learn
  -- the address of everybody who opened a board. The dashboard and the
  -- service key are not a client, so a moderator can still rename somebody.
  if current_user in ('authenticated', 'anon') then
    if (new.username is distinct from old.username
        or new.username_changed_at is distinct from old.username_changed_at)
       and current_setting('outrepd.renaming', true) is distinct from 'on' then
      raise exception 'a username changes through set_my_username only';
    end if;

    if new.avatar_url is distinct from old.avatar_url
       and new.avatar_url is not null
       and new.avatar_url !~ (
         '^https://[A-Za-z0-9.-]+/storage/v1/object/public/avatars/'
         || new.id::text || '/photo\.jpg(\?v=[0-9]+)?$') then
      raise exception 'avatar_url must be this account''s own uploaded photo';
    end if;
  end if;

  -- settle_duel runs as the definer and sets this for the length of its
  -- transaction. Anything else touching these columns is a client trying to
  -- write its own rank.
  if current_setting('outrepd.settling', true) = 'on' then
    return new;
  end if;

  if new.tier_idx        is distinct from old.tier_idx
  or new.div_idx         is distinct from old.div_idx
  or new.lp              is distinct from old.lp
  or new.peak_tier_idx   is distinct from old.peak_tier_idx
  or new.wins            is distinct from old.wins
  or new.losses          is distinct from old.losses
  or new.win_streak      is distinct from old.win_streak
  or new.best_streak     is distinct from old.best_streak
  or new.placements_done is distinct from old.placements_done
  or new.placement_wins  is distinct from old.placement_wins
  or new.total_reps      is distinct from old.total_reps
  or new.best_set        is distinct from old.best_set then
    raise exception 'rank and record are settled by the server, not the client';
  end if;

  -- A code that a lifter could rewrite is a code somebody could hand out,
  -- have declined, and then mint a fresh one to try again under. It is
  -- assigned once, the same way an id is.
  if new.friend_code is distinct from old.friend_code then
    raise exception 'friend_code is assigned by the server, not the client';
  end if;

  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists profiles_guard_ladder on profiles;
create trigger profiles_guard_ladder
  before update on profiles
  for each row execute function guard_ladder_columns();

-- Names nobody gets to wear on a board. The stores ask an app with names that
-- strangers see for a way to keep abuse from being posted at all, not only a
-- way to report it afterwards.
--
-- Whole words that are abuse in any name they appear in, in English and in the
-- Egyptian and Gulf spellings that turn up in Latin letters, plus the names
-- that would pass for the app itself. Short fragments that are also inside
-- ordinary words ("anal" in "analyst", "cock" in "peacock") are left out on
-- purpose: refusing somebody's real name is worse than missing a rare one,
-- and reports catch what this does not. Digits that stand in for letters are
-- read as those letters first, so "b1tch" is "bitch".
create or replace function username_not_allowed(name text)
returns boolean
language sql
immutable
as $$
  select translate(lower(coalesce(name, '')), '013457@$', 'oieastas')
      ~ ('(fuck|cunt|nigg|faggot|whore|slut|bitch|pussy|porn|'
         'dildo|penis|vagina|hitler|retard|motherf|'
         'sharmoot|sharmout|sharmuta|kosom|kossom|kusom|kosomak|khawal|'
         'metnak|mitnak|'
         'outrepd|admin|moderator|official)')
    or lower(coalesce(name, '')) ~ '(شرموط|متناك|كسم|عرص|منيوك)';
$$;

-- A profile starts where everybody starts. The update guard above keeps a
-- client from writing its own rank, but nothing stopped the first insert
-- from arriving already a Master with a thousand wins, or with a name or a
-- picture the rules above would have refused.
create or replace function guard_new_profile()
returns trigger
language plpgsql
as $$
begin
  if current_user not in ('authenticated', 'anon') then
    return new;
  end if;

  new.tier_idx        := 0;
  new.div_idx         := 0;
  new.lp              := 0;
  new.peak_tier_idx   := 0;
  new.placements_done := 0;
  new.placement_wins  := 0;
  new.wins            := 0;
  new.losses          := 0;
  new.win_streak      := 0;
  new.best_streak     := 0;
  new.total_reps      := 0;
  new.best_set        := 0;
  new.friend_code     := generate_friend_code();
  new.username_changed_at := null;
  new.avatar_url      := null;
  new.title           := null;
  new.created_at      := now();

  -- Renamed rather than refused: refusing would leave a brand-new lifter
  -- with no account and no idea why. The one rename is still theirs to spend.
  if username_not_allowed(new.username) then
    new.username := 'lifter' || substr(replace(new.id::text, '-', ''), 1, 6);
  end if;
  return new;
end;
$$;

drop trigger if exists profiles_guard_new on profiles;
create trigger profiles_guard_new
  before insert on profiles
  for each row execute function guard_new_profile();

-- A set belongs to the lifter who did it. They may write it once and read
-- their own; everyone can read a set that a duel has already joined them to.
drop policy if exists "a lifter writes their own sets" on sets;
create policy "a lifter writes their own sets"
  on sets for insert
  to authenticated
  with check (auth.uid() = profile_id);

drop policy if exists "a lifter reads their own sets" on sets;
create policy "a lifter reads their own sets"
  on sets for select
  to authenticated
  using (auth.uid() = profile_id);

-- Duels are readable by the two people in them, and by nobody else.
drop policy if exists "a lifter reads their own duels" on duels;
create policy "a lifter reads their own duels"
  on duels for select
  to authenticated
  using (auth.uid() = challenger or auth.uid() = defender);

-- Nothing inserts into duels directly. settle_duel does it, as the definer.

-- ──────────────────────────────── blocks ─────────────────────────────────────

-- Somebody you want nothing further to do with.
--
-- One row, one direction: you blocked them. It is read from both ends
-- wherever it is enforced, because blocking has to work whichever of the two
-- opens the app — but only one of you gets to undo it, and they are not told
-- it happened.
create table if not exists blocks (
  blocker    uuid not null references profiles on delete cascade,
  blocked    uuid not null references profiles on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker, blocked),
  check (blocker <> blocked)
);

create index if not exists blocks_blocked_idx on blocks (blocked);

alter table blocks enable row level security;

-- Only the blocker sees the row. Showing it to the blocked person would
-- tell them, which is the one thing a block must not do.
drop policy if exists "a lifter reads their own blocks" on blocks;
create policy "a lifter reads their own blocks"
  on blocks for select
  to authenticated
  using (auth.uid() = blocker);

drop policy if exists "a lifter blocks in their own name" on blocks;
create policy "a lifter blocks in their own name"
  on blocks for insert
  to authenticated
  with check (auth.uid() = blocker);

drop policy if exists "a lifter unblocks their own" on blocks;
create policy "a lifter unblocks their own"
  on blocks for delete
  to authenticated
  using (auth.uid() = blocker);

-- ──────────────────────────────────── mutes ───────────────────────────────────

-- Somebody whose stored sets you would rather not be offered.
--
-- Lighter than a block: it says nothing to the friendship, the profile is
-- still visible, and they are never told. One row, one direction, checked
-- only from the muter's own side — muting somebody stops them turning up as
-- an opponent for you; it says nothing about whether your own sets still
-- turn up for them.
create table if not exists mutes (
  muter      uuid not null references profiles on delete cascade,
  muted      uuid not null references profiles on delete cascade,
  created_at timestamptz not null default now(),
  primary key (muter, muted),
  check (muter <> muted)
);

create index if not exists mutes_muted_idx on mutes (muted);

alter table mutes enable row level security;

-- Only the muter sees the row, same as a block: it must not be a way to find
-- out somebody muted you.
drop policy if exists "a lifter reads their own mutes" on mutes;
create policy "a lifter reads their own mutes"
  on mutes for select
  to authenticated
  using (auth.uid() = muter);

drop policy if exists "a lifter mutes in their own name" on mutes;
create policy "a lifter mutes in their own name"
  on mutes for insert
  to authenticated
  with check (auth.uid() = muter);

drop policy if exists "a lifter unmutes their own" on mutes;
create policy "a lifter unmutes their own"
  on mutes for delete
  to authenticated
  using (auth.uid() = muter);

-- ──────────────────────────────── reports ────────────────────────────────────

-- Somebody saying something is wrong.
--
-- Write-only from the app's side: a reporter may file one and can never read
-- the pile back, because the pile is about other people. Nothing in the app
-- reads this table at all — it is read by whoever is looking at reports, in
-- the dashboard.
create table if not exists reports (
  id          uuid primary key default gen_random_uuid(),
  reporter    uuid not null references profiles on delete cascade,
  reported    uuid references profiles on delete set null,
  created_at  timestamptz not null default now(),

  reason text not null
         check (reason in ('cheating', 'harassment', 'content',
                           'impersonation', 'other')),

  -- Optional, and capped: a free text box with no limit is a free text box
  -- somebody will paste a novel into.
  details text not null default '' check (char_length(details) <= 1000)
);

create index if not exists reports_reported_idx
  on reports (reported, created_at desc);

alter table reports enable row level security;

drop policy if exists "a lifter files their own reports" on reports;
create policy "a lifter files their own reports"
  on reports for insert
  to authenticated
  with check (auth.uid() = reporter);

-- Deliberately no select policy. Filing a report does not entitle anybody to
-- read reports, including their own — there is nothing useful in reading it
-- back, and a readable pile is one more thing to leak.

-- ──────────────────────────────── avatars ─────────────────────────────────────

-- The photo behind `profiles.avatar_url`.
--
-- Public read, because an avatar is drawn on everyone else's screen too — the
-- leaderboard, a stranger's profile, a shared card. Public storage is not
-- public data: nothing here is a photo unless a lifter chose to upload one,
-- and the path convention below is what keeps one account from overwriting
-- another's.
--
-- Path convention: `<account id>/photo`. `storage.foldername(name)` splits
-- that on `/`, so its first element is the id a write has to match.
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- A photo, and a small one: the phone sends an 800-pixel JPEG. Without this
-- the public bucket would host anything any account cared to put in it.
update storage.buckets
   set file_size_limit = 5242880,
       allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp']
 where id = 'avatars';

drop policy if exists "avatars are public to read" on storage.objects;
create policy "avatars are public to read"
  on storage.objects for select
  using (bucket_id = 'avatars');

drop policy if exists "a lifter uploads their own avatar" on storage.objects;
create policy "a lifter uploads their own avatar"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "a lifter replaces their own avatar" on storage.objects;
create policy "a lifter replaces their own avatar"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "a lifter deletes their own avatar" on storage.objects;
create policy "a lifter deletes their own avatar"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- ─────────────────────────────── rate limits ─────────────────────────────────

-- How often one account may do the things that cost something when done
-- thousands of times: an email sent, a stranger asked, a row written.
--
-- Kept here, in the database, because a limit in the app is a limit only on
-- people who use the app. Anybody can talk to this server without it, with
-- the public key every copy of the app carries; these checks run whichever
-- way the request arrives.
--
-- One row per action taken. Old rows for the same account and action are
-- cleared on the next call, so the table holds roughly one window's worth.
-- Named so it cannot collide with anything else in the project: an earlier
-- version called it rate_events, and a project already had an unrelated
-- table by that name, which `if not exists` then silently kept.
create table if not exists rate_limit_hits (
  profile_id uuid not null references profiles on delete cascade,
  action     text not null,
  at         timestamptz not null default now()
);

create index if not exists rate_limit_hits_idx
  on rate_limit_hits (profile_id, action, at desc);

-- No policies at all: only the functions below, running as their owner,
-- ever read or write it.
alter table rate_limit_hits enable row level security;

-- Records one use of `act` by the calling account, or refuses it with HTTP
-- 429 when `max_count` uses already fall inside `per`.
--
-- PT429 is how PostgREST is told which HTTP status to answer with; the app
-- reads the message, 'rate_limited'. Calls with no signed-in account (the
-- dashboard, the service key, other server functions) are never limited.
create or replace function take_rate(act text, max_count int, per interval)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
  recent int;
begin
  if me is null then
    return;
  end if;

  delete from rate_limit_hits r
   where r.profile_id = me and r.action = act and r.at < now() - per;

  select count(*) into recent
    from rate_limit_hits r
   where r.profile_id = me and r.action = act;

  if recent >= max_count then
    raise exception 'rate_limited'
      using errcode = 'PT429', detail = act;
  end if;

  insert into rate_limit_hits (profile_id, action) values (me, act);
end;
$$;

-- Not callable from the app. The triggers and functions that use it run as
-- their owner, which is what lets them.
revoke all on function take_rate(text, int, interval) from public, anon, authenticated;

-- Reports. Each one emails whoever answers them (report-alert), so a loop
-- filing reports is a loop sending email. Five an hour is more than anybody
-- with a real complaint files; twenty a day stops a slow drip as well.
create or replace function limit_reports()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  perform take_rate('report_hour', 5, interval '1 hour');
  perform take_rate('report_day', 20, interval '1 day');
  return new;
end;
$$;

drop trigger if exists reports_rate_limit on reports;
create trigger reports_rate_limit
  before insert on reports
  for each row execute function limit_reports();

-- Sets. A set is a minute of push-ups, so a person cannot honestly store more
-- than about fifty an hour; forty leaves room and stops a script filling the
-- table and the opponent pool. A set naming somebody is a challenge, which
-- also sends them a notice, so those get a daily cap of their own.
create or replace function limit_sets()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  perform take_rate('set', 40, interval '1 hour');
  if new.challenge_target is not null then
    perform take_rate('challenge', 20, interval '1 day');
  end if;
  return new;
end;
$$;

drop trigger if exists sets_rate_limit on sets;
create trigger sets_rate_limit
  before insert on sets
  for each row execute function limit_sets();

-- Emailing yourself your data. It sends a real email through Resend to
-- whatever address is typed, so it is the most expensive thing an account
-- can do and the easiest to aim at somebody else's inbox. Twice a day covers
-- a typo in the address; the edge function asks this before it sends.
create or replace function claim_data_export()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'not signed in';
  end if;
  perform take_rate('data_export', 2, interval '1 day');
end;
$$;

revoke all on function claim_data_export() from public;
grant execute on function claim_data_export() to authenticated;
