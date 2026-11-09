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
  -- division, and past 99 in Master I, which has nothing above it. Shown as
  -- one number, the rating: 1,000 + 500 a tier + 100 a division + LP
  -- (2026-11-02). `top_tier()` in ladder.sql is the same number of tiers.
  tier_idx      int  not null default 0 check (tier_idx between 0 and 6),
  div_idx       int  not null default 0 check (div_idx  between 0 and 4),
  lp            int  not null default 0 check (lp >= 0),

  -- The highest tier ever held. It used to be a floor nobody could fall
  -- through; since 2026-11-02 a rank can fall a tier like any other rung,
  -- and this is only what Your climb ticks off.
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
-- A friend asking to go live (live.sql). The invite itself still arrives in
-- the app; this is only whether it buzzes the phone.
alter table profiles add column if not exists notify_live_invite bool not null
  default true;
alter table profiles add column if not exists avatar_url text;
-- The parts of the lifter this account made (lib/lifter/catalog.dart,
-- Lifter.toJson): ids and colours, so another phone can edit it. Its picture
-- is the PNG uploaded as avatar_url. A few hundred bytes; the cap keeps it
-- from becoming somewhere to keep anything else.
alter table profiles add column if not exists lifter jsonb
  constraint profiles_lifter_small
  check (lifter is null or pg_column_size(lifter) <= 2048);
-- A Pro part worn for a day after a rewarded video (rewarded.sql,
-- start_pro_trial): which, what it replaced, and until when. Written by the
-- server only.
alter table profiles add column if not exists pro_trial jsonb;
-- The cover over a Pro profile: one of the moving scenes the app draws
-- (lib/lifter/covers.dart), or this account's own photo at <id>/cover.jpg.
-- Shown only while the account is Pro (pro_looks in account.sql), so a lapsed
-- subscription keeps its choice for when it comes back.
alter table profiles add column if not exists cover text;
-- Dropped and made again, so a database that already has the column takes a
-- new scene too (four in 1.1.6's second round: fireworks, fight night,
-- orbit, the champion's podium).
alter table profiles drop constraint if exists profiles_cover_known;
alter table profiles add constraint profiles_cover_known
  check (cover is null
    or cover in ('neon_city', 'iron_gym', 'rooftop_sunset', 'stadium_lights', 'silver_peaks', 'bronze_dunes', 'volcano', 'palm_beach', 'winter_city', 'fireworks', 'fight_night', 'orbit', 'champion_podium')
    or cover ~ ('^https://[A-Za-z0-9.-]+/storage/v1/object/public/avatars/'
                || id::text || '/cover\.jpg(\?v=[0-9]+)?$'));
alter table profiles add column if not exists username_changed_at timestamptz;
-- When this lifter last chose a country themselves (set_my_country). Null
-- until then: the phone's own region fills the column in, and that is not a
-- choice anybody made.
alter table profiles add column if not exists country_changed_at timestamptz;
-- Experience: one for every rep of every set, twenty for every match won, and
-- nothing for a match lost (count_reps_of_set below; xp_for_duel, live.sql).
-- Never lower than before a match.
alter table profiles add column if not exists xp int not null default 0;

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
-- LP went to 99 everywhere until the rating (2026-11-02) let Master I keep
-- climbing. 6 and 4 are top_tier() and top_division(), which ladder.sql
-- defines after this file.
alter table profiles drop constraint if exists profiles_lp_check;
alter table profiles add constraint profiles_lp_check
  check (lp >= 0 and (lp <= 99 or (tier_idx = 6 and div_idx = 4)));

-- The board reads this constantly, and always in the same order.
create index if not exists profiles_ladder_idx
  on profiles (tier_idx desc, div_idx desc, lp desc);

-- ──────────────────────────────── friend code ─────────────────────────────────

-- A short number that names an account the way a username does, without
-- being one. Usernames are already unique, so this is not for telling two
-- lifters apart — it is for adding one without having to hand over the name
-- shown on the ladder to do it.
-- Security definer because it has to see every code already taken, and a
-- lifter can only read their own row.
create or replace function generate_friend_code()
returns text
language plpgsql
security definer
set search_path = public
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
-- Set when the set was lifted in a live match (live.sql). It already has its
-- opponent, so it is never offered to the open pool.
alter table sets add column if not exists live_match uuid;
-- A practice minute: nobody on the other side, and nobody ever will be. Stored
-- for what it adds to the totals and to experience, never offered to the pool
-- or raced.
alter table sets add column if not exists practice boolean not null default false;

create index if not exists sets_open_idx
  on sets (profile_id, created_at desc)
  where claimed_by is null;

-- Every foreign key has an index on the side that points. Deleting an
-- account deletes or clears each row that points at it, and with no index
-- Postgres reads the whole table to find them — once for every row the
-- deletion reaches, which for a set is every duel there has ever been.
-- Partial where the column may be empty: an equality implies not null, so
-- the lookup still uses it, and the empty rows cost nothing to keep.
create index if not exists sets_challenge_target_idx
  on sets (challenge_target) where challenge_target is not null;

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
    best_set   = greatest(best_set, new.reps),
    xp         = xp + new.reps
  where id = new.profile_id;
  perform set_config('outrepd.settling', 'off', true);
  return new;
end;
$$;

drop trigger if exists sets_count_reps on sets;
create trigger sets_count_reps
  after insert on sets
  for each row execute function count_reps_of_set();

-- What a minute can hold. Nobody does a push-up in under 0.3 seconds — the
-- counter itself waits 0.35 between reps — and no set the app records runs
-- past a minute and a bit. A count beyond either is not a set anybody lifted,
-- and LP is paid in reps. NOT VALID: it holds every set from here on and
-- leaves rows already stored alone.
alter table sets drop constraint if exists sets_reps_fit_the_time;
alter table sets add constraint sets_reps_fit_the_time
  check (reps * 300 <= duration_ms + 1000
         and reps_camera * 300 <= duration_ms + 1000
         and duration_ms <= 75000) not valid;

-- A set the phone sends itself. The phone says what was lifted; everything
-- else about the row is the server's to decide:
--
--   * when it was stored — "oldest first" decides whose set the pool hands
--     out next, and a date the client chose would jump the queue;
--   * that nobody has raced it yet, and that it was not part of a live match
--     — those are written by settle_duel and live.sql, never sent;
--   * who a challenge may name: a friend, or somebody this account has
--     already raced. A challenge is a notice and a push on the other phone,
--     and a stranger picked out of a search is not somebody to send one to.
--
-- And how often. A set is a minute of push-ups, so a phone sending them
-- seconds apart is not lifting them, and every set adds to the totals on the
-- profile and every challenge buzzes somebody's phone.
--
-- Runs as the caller, not as the definer: sets written by settle_duel's and
-- live.sql's own functions arrive as the database owner and pass untouched.
create or replace function guard_new_set()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if current_user not in ('authenticated', 'anon') then
    return new;
  end if;

  new.created_at := now();
  new.claimed_by := null;
  new.live_match := null;

  if exists (
    select 1 from sets s
     where s.profile_id = new.profile_id
       and s.created_at > now() - interval '8 seconds'
  ) or (
    select count(*) from sets s
     where s.profile_id = new.profile_id
       and s.created_at > now() - interval '1 hour'
  ) >= 40 then
    raise exception 'sets are arriving faster than anybody lifts them';
  end if;

  if new.practice and new.challenge_target is not null then
    raise exception 'a practice set challenges nobody';
  end if;

  if new.challenge_target is not null then
    if new.challenge_target = new.profile_id then
      raise exception 'cannot challenge yourself';
    end if;
    -- Both are read through the caller's own rows, which is all a lifter
    -- can see of either table: their own friendships and their own duels.
    if not exists (
      select 1 from friendships f
       where f.accepted_at is not null
         and ((f.requester = new.profile_id and f.addressee = new.challenge_target)
           or (f.addressee = new.profile_id and f.requester = new.challenge_target))
    ) and not exists (
      select 1 from duels d
       where (d.challenger = new.profile_id and d.defender = new.challenge_target)
          or (d.defender = new.profile_id and d.challenger = new.challenge_target)
    ) then
      raise exception 'a challenge goes to a friend or a past opponent';
    end if;
    if (
      select count(*) from sets s
       where s.profile_id = new.profile_id
         and s.challenge_target is not null
         and s.created_at > now() - interval '1 day'
    ) >= 15 or (
      select count(*) from sets s
       where s.profile_id = new.profile_id
         and s.challenge_target = new.challenge_target
         and s.created_at > now() - interval '1 day'
    ) >= 3 then
      raise exception 'that is enough challenges for today';
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists sets_guard_new on sets;
create trigger sets_guard_new
  before insert on sets
  for each row execute function guard_new_set();

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

-- What the duel added to each side's week and month on the boards
-- (seasons.sql): 5 a win, 10 for every third win in a row, 2 off for a loss,
-- nothing past the twentieth ranked duel of the day. Null on a duel from
-- before the rule (2026-11-02) until seasons.sql works it out.
alter table duels add column if not exists pts_challenger int;
alter table duels add column if not exists pts_defender int;

create index if not exists duels_for_profile_idx
  on duels (challenger, created_at desc);
create index if not exists duels_against_profile_idx
  on duels (defender, created_at desc);
-- The foreign keys' own indexes; see sets_challenge_target_idx.
create index if not exists duels_challenger_set_idx on duels (challenger_set);
create index if not exists duels_defender_set_idx on duels (defender_set);
create index if not exists duels_winner_idx
  on duels (winner) where winner is not null;

-- ───────────────────────────── row level security ────────────────────────────

alter table profiles enable row level security;
alter table sets     enable row level security;
alter table duels    enable row level security;

-- Every policy in this project reads the caller as `(select auth.uid())`,
-- never a bare `auth.uid()`. The bare call is evaluated once per row the
-- query looks at; inside a select, Postgres works it out once per query and
-- reuses it. Same answer either way, and on a table the size `sets` and
-- `duels` will reach, the difference is the difference. Supabase's
-- performance advisor flags the bare form (auth_rls_initplan).

-- A lifter reads their own row, and only their own. Everybody else is seen
-- through the functions that draw the board, a friends list or a profile
-- card, each of which hands back the columns that screen shows and keeps the
-- rest — when somebody was last online, a country they asked to hide, the
-- notices they turned off, whether they asked to be left off the boards.
-- Every row used to be readable whole by anyone signed in, which a guest
-- account is, and which made each of those settings a request rather than a
-- rule.
drop policy if exists "profiles are public to signed-in lifters" on profiles;
drop policy if exists "a lifter reads their own profile" on profiles;
create policy "a lifter reads their own profile"
  on profiles for select
  to authenticated
  using ((select auth.uid()) = id);

drop policy if exists "a lifter creates their own profile" on profiles;
create policy "a lifter creates their own profile"
  on profiles for insert
  to authenticated
  with check ((select auth.uid()) = id);

-- The only columns a lifter may change about themselves are the ones that are
-- about them rather than about their standing. The ladder columns are locked
-- by the trigger below, because a column list in a policy cannot express
-- "these may change and those may not".
drop policy if exists "a lifter edits their own profile" on profiles;
create policy "a lifter edits their own profile"
  on profiles for update
  to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

create or replace function guard_ladder_columns()
returns trigger
language plpgsql
set search_path = public
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

    -- The country decides which country board somebody is on, and a board
    -- for a small country is one a lifter could move onto to top it. Once
    -- there it changes through set_my_country and its fourteen days. An
    -- empty one is still filled in from the phone, as it always has been.
    if (new.country is distinct from old.country
        or new.country_changed_at is distinct from old.country_changed_at)
       and old.country is not null
       and current_setting('outrepd.recountry', true) is distinct from 'on' then
      raise exception 'a country changes through set_my_country only';
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
  or new.best_set        is distinct from old.best_set
  or new.xp              is distinct from old.xp then
    raise exception 'rank and record are settled by the server, not the client';
  end if;

  -- A code that a lifter could rewrite is a code somebody could hand out,
  -- have declined, and then mint a fresh one to try again under. It is
  -- assigned once, the same way an id is.
  if new.friend_code is distinct from old.friend_code then
    raise exception 'friend_code is assigned by the server, not the client';
  end if;

  -- A day with a Pro part is given after its video, by start_pro_trial; a
  -- phone writing its own would be a Pro part for ever.
  if new.pro_trial is distinct from old.pro_trial then
    raise exception 'pro_trial is given by the server, not the client';
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
set search_path = public
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
set search_path = public
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
  new.xp              := 0;
  new.pro_trial       := null;
  new.friend_code     := generate_friend_code();
  new.username_changed_at := null;
  new.avatar_url      := null;
  new.title           := null;
  new.created_at      := now();

  -- Renamed rather than refused: refusing would leave a brand-new lifter
  -- with no account and no idea why. The one rename is still theirs to spend.
  --
  -- The same letters set_my_username allows, plus the underscore the app's
  -- own first name for a guest has in it. Anything else is a name nobody
  -- could type into a search — or one built to look like somebody else's
  -- out of characters that only resemble theirs.
  if username_not_allowed(new.username)
     or new.username !~ '^[A-Za-z0-9_]{2,20}$' then
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
-- Only a subscriber writes one (has_pro, in subscriptions.sql — always true
-- until enforcement is switched on there).
drop policy if exists "a lifter writes their own sets" on sets;
create policy "a lifter writes their own sets"
  on sets for insert
  to authenticated
  with check ((select auth.uid()) = profile_id and has_pro((select auth.uid())));

drop policy if exists "a lifter reads their own sets" on sets;
create policy "a lifter reads their own sets"
  on sets for select
  to authenticated
  using ((select auth.uid()) = profile_id);

-- Duels are readable by the two people in them, and by nobody else.
drop policy if exists "a lifter reads their own duels" on duels;
create policy "a lifter reads their own duels"
  on duels for select
  to authenticated
  using ((select auth.uid()) = challenger or (select auth.uid()) = defender);

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
  using ((select auth.uid()) = blocker);

drop policy if exists "a lifter blocks in their own name" on blocks;
create policy "a lifter blocks in their own name"
  on blocks for insert
  to authenticated
  with check ((select auth.uid()) = blocker);

drop policy if exists "a lifter unblocks their own" on blocks;
create policy "a lifter unblocks their own"
  on blocks for delete
  to authenticated
  using ((select auth.uid()) = blocker);

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
  using ((select auth.uid()) = muter);

drop policy if exists "a lifter mutes in their own name" on mutes;
create policy "a lifter mutes in their own name"
  on mutes for insert
  to authenticated
  with check ((select auth.uid()) = muter);

drop policy if exists "a lifter unmutes their own" on mutes;
create policy "a lifter unmutes their own"
  on mutes for delete
  to authenticated
  using ((select auth.uid()) = muter);

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
create index if not exists reports_reporter_idx on reports (reporter);

alter table reports enable row level security;

drop policy if exists "a lifter files their own reports" on reports;
create policy "a lifter files their own reports"
  on reports for insert
  to authenticated
  with check ((select auth.uid()) = reporter);

-- Each report emails whoever answers them (functions/report-alert), so an
-- account that files them in a loop fills an inbox. Past ten a day, or a
-- second one about the same account the same day, the report is quietly not
-- stored: the reporter sees it go through, and the inbox sees nothing new.
-- Runs as the caller, who can see nothing of this table, so the counting
-- goes through count_my_reports below.
create or replace function count_my_reports(about uuid)
returns table (today int, about_them int)
language sql
stable
security definer
set search_path = public
as $$
  select count(*)::int,
         (count(*) filter (where r.reported = about))::int
    from reports r
   where r.reporter = auth.uid()
     and r.created_at > now() - interval '1 day';
$$;

revoke all on function count_my_reports(uuid) from public, anon;
grant execute on function count_my_reports(uuid) to authenticated;

create or replace function guard_new_report()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  counted record;
begin
  if current_user not in ('authenticated', 'anon') then
    return new;
  end if;
  new.created_at := now();
  -- Set by report-alert once it has emailed about this report (push.sql).
  -- A report that arrived already marked would never be emailed about.
  new.alerted_at := null;
  select * into counted from count_my_reports(new.reported);
  if counted.today >= 10 or counted.about_them >= 1 then
    return null;
  end if;
  return new;
end;
$$;

drop trigger if exists reports_guard_new on reports;
create trigger reports_guard_new
  before insert on reports
  for each row execute function guard_new_report();

-- Deliberately no select policy. Filing a report does not entitle anybody to
-- read reports, including their own — there is nothing useful in reading it
-- back, and a readable pile is one more thing to leak.

-- ─────────────────────────────── how often ─────────────────────────────────────

-- Things a lifter does that land on somebody else's phone or in somebody's
-- inbox — a friend request, a live invite, an emailed export — and so must
-- not be repeatable without end. One row each time one goes through; nothing
-- reads or writes this table but within_rate below.
create table if not exists rate_events (
  profile_id uuid not null references profiles on delete cascade,
  kind       text not null,
  target     uuid,
  at         timestamptz not null default now()
);

-- A key of its own. Nothing looks a row up by it; it is there because
-- Postgres replication and Supabase's realtime need one on every table, and
-- deleting old rows is cheaper with one.
alter table rate_events
  add column if not exists id bigint generated always as identity primary key;

create index if not exists rate_events_idx
  on rate_events (profile_id, kind, at desc);

alter table rate_events enable row level security;

-- Whether the caller may do [what] once more: fewer than [most] in the last
-- [per] — counted toward [toward] alone when one is given. Counts this one
-- if so. Only the server's own functions call it; nothing a phone can reach.
create or replace function within_rate(
  what text,
  per interval,
  most int,
  toward uuid default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  used int;
begin
  if auth.uid() is null then
    return false;
  end if;
  delete from rate_events
   where profile_id = auth.uid() and at < now() - interval '2 days';
  select count(*) into used from rate_events
   where profile_id = auth.uid()
     and kind = what
     and at > now() - per
     and (toward is null or target = toward);
  if used >= most then
    return false;
  end if;
  insert into rate_events (profile_id, kind, target)
  values (auth.uid(), what, toward);
  return true;
end;
$$;

revoke all on function within_rate(text, interval, int, uuid)
  from public, anon, authenticated;

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

-- Drawn from the bucket's public address, which serves any photo to anybody
-- holding its link without asking the policies at all. What a policy here
-- controls is listing the bucket through the API — every account with a
-- photo, by id — so it reaches the lifter's own file and nothing else. The
-- upload replaces that file in place, and replacing needs to see it.
drop policy if exists "avatars are public to read" on storage.objects;
drop policy if exists "a lifter sees their own avatar file" on storage.objects;
create policy "a lifter sees their own avatar file"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'avatars'
    and name in ((select auth.uid())::text || '/photo.jpg',
                 (select auth.uid())::text || '/thumb.jpg',
                 (select auth.uid())::text || '/cover.jpg')
  );

-- Three files per account, at the paths the app writes: `<id>/photo.jpg`,
-- its small copy for the boards `<id>/thumb.jpg` (lib/photo_thumb.dart), and
-- for a Pro profile's own cover `<id>/cover.jpg`.
-- The folder alone was the rule before, which let an account fill its folder
-- with as many public files as it liked, under any names — free hosting on
-- this project's bill and its domain.
drop policy if exists "a lifter uploads their own avatar" on storage.objects;
create policy "a lifter uploads their own avatar"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'avatars'
    and name in ((select auth.uid())::text || '/photo.jpg',
                 (select auth.uid())::text || '/thumb.jpg',
                 (select auth.uid())::text || '/cover.jpg')
  );

drop policy if exists "a lifter replaces their own avatar" on storage.objects;
create policy "a lifter replaces their own avatar"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'avatars'
    and name in ((select auth.uid())::text || '/photo.jpg',
                 (select auth.uid())::text || '/thumb.jpg',
                 (select auth.uid())::text || '/cover.jpg')
  )
  with check (
    bucket_id = 'avatars'
    and name in ((select auth.uid())::text || '/photo.jpg',
                 (select auth.uid())::text || '/thumb.jpg',
                 (select auth.uid())::text || '/cover.jpg')
  );

drop policy if exists "a lifter deletes their own avatar" on storage.objects;
create policy "a lifter deletes their own avatar"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );
