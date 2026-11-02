-- Finding an opponent, and settling with them.
--
-- The whole async duel is two calls: `find_opponent_set` hands you somebody
-- else's minute to race, and `settle_duel` compares yours against it and moves
-- both ranks. Nothing else writes to the ladder.
--
-- Both are `security definer`, which is what lets them write columns the
-- caller is forbidden to touch. That makes them the attack surface: every
-- argument is treated as hostile, and the caller's identity comes from
-- `auth.uid()` rather than from anything they passed in.

-- ─────────────────────────────── what was offered ───────────────────────────────

-- Which stored set was handed to whom, and how. settle_duel only settles a
-- set against the one it was raced against, and this is how it knows: the
-- pool's rules — near your level, never the same two twice, blocks, mutes,
-- who agreed to be challenged — are all decided in the two find_ functions,
-- and a set id the phone simply names went around every one of them. With
-- nothing but an id, a second account could store sets of nothing and be
-- beaten by the first over and over, for as much LP as anybody liked.
create table if not exists set_offers (
  set_id      uuid not null references sets on delete cascade,
  offered_to  uuid not null references profiles on delete cascade,
  offered_at  timestamptz not null default now(),
  -- Handed out by find_targeted_set: a rematch, which never moves a rank.
  targeted    boolean not null default false,
  primary key (set_id, offered_to)
);

alter table set_offers enable row level security;

-- The primary key leads with the set; deleting an account looks rows up by
-- whom they were offered to.
create index if not exists set_offers_offered_to_idx on set_offers (offered_to);

-- ───────────────────────────── finding somebody ──────────────────────────────

-- The open pool in the order find_opponent_set hands it out, oldest first:
-- exactly the sets it may offer, so it reads them in order and stops at the
-- first one that suits.
create index if not exists sets_pool_idx
  on sets (created_at)
  where claimed_by is null and challenge_target is null and live_match is null;

-- A stored set from somebody near your level that you have not faced.
--
-- Async on purpose: two people being free in the same minute is the hardest
-- thing to arrange in a fitness app, and it is not needed. You race their
-- minute, they find out they were raced.
-- Dropped first: the picture was added to what it returns.
drop function if exists find_opponent_set(int);
create or replace function find_opponent_set(within_levels int default 6)
returns table (
  set_id uuid,
  profile_id uuid,
  username text,
  tier_idx int,
  div_idx int,
  reps int,
  rep_times int[],
  avatar_url text,
  xp int
)
language plpgsql
security definer
set search_path = public
as $$
declare
  me profiles;
  my_level int;
  kept_apart uuid[];
  found_set record;
begin
  -- Only a subscriber plays (see subscriptions.sql; off until switched on).
  perform require_pro();
  select * into me from profiles where id = auth.uid();
  if me is null then
    raise exception 'no profile for this account';
  end if;
  my_level := ladder_level(me.tier_idx, me.div_idx);

  -- Everybody this account may not be handed, gathered once from its own
  -- rows. Asked of each candidate in turn instead, as this used to be, it
  -- read every duel of every lifter near this level before choosing one:
  -- slower with each lifter who joined, and nearly a second at ten thousand.
  --   * Not somebody already faced. A ladder that keeps pairing the same two
  --     people is a ladder of two.
  --   * A block works whichever of the two is holding the phone, so both
  --     directions count. Neither is told which one it was.
  --   * A mute is one-directional and only ever counts from the muter's own
  --     side: it says "stop offering me them," not "stop offering them me."
  kept_apart := array(
    select d.defender from duels d where d.challenger = me.id
    union select d.challenger from duels d where d.defender = me.id
    union select b.blocked from blocks b where b.blocker = me.id
    union select b.blocker from blocks b where b.blocked = me.id
    union select m.muted from mutes m where m.muter = me.id
  );

  -- The pool oldest first (sets_pool_idx), stopping at the first set whose
  -- lifter passes, so the cost is the sets read before a match rather than
  -- everybody on the ladder.
  select s.id as set_id, p.id as profile_id, p.username, p.tier_idx,
         p.div_idx, s.reps, s.rep_times, p.avatar_url, p.xp
    into found_set
  from sets s
  join profiles p on p.id = s.profile_id
  where s.claimed_by is null
    and s.profile_id <> me.id
    -- Reserved for a rematch is not offered to the open pool — the whole
    -- point of naming a challenge_target is that only they can find it, with
    -- find_targeted_set below.
    and s.challenge_target is null
    -- Lifted live against somebody already (live.sql): it is settled against
    -- them, not left for the pool.
    and s.live_match is null
    -- Practice was lifted against nobody, and is not for racing.
    and not s.practice
    -- Near your level, measured in rungs rather than tiers: the difference
    -- between the top and the bottom of one tier is five divisions, and
    -- matching "same tier" would pair those two.
    and abs(ladder_level(p.tier_idx, p.div_idx) - my_level) <= within_levels
    and s.profile_id <> all (kept_apart)
    -- Whoever they said may challenge them. Enforced where the pairing is
    -- decided rather than on the phone, because a preference the client can
    -- skip is a preference in name only.
    and (
      p.challengeable = 'everyone'
      or (p.challengeable = 'friends' and exists (
            select 1 from friendships f
            where f.accepted_at is not null
              and ((f.requester = me.id and f.addressee = p.id)
                or (f.addressee = me.id and f.requester = p.id))
          ))
    )
  -- Oldest first: a set that has been waiting is the one most likely to have
  -- been forgotten about, and its owner is owed a result.
  order by s.created_at
  limit 1;

  if not found then
    return;
  end if;

  -- Written down, so settle_duel can tell this set was handed out here. The
  -- conflict is named by its constraint: `set_id` is also one of this
  -- function's output columns, and plpgsql reads a bare one as ambiguous.
  -- Offers a day old were never raced, and go.
  delete from set_offers o
   where o.offered_to = me.id and o.offered_at < now() - interval '1 day';
  insert into set_offers (set_id, offered_to, targeted)
  values (found_set.set_id, me.id, false)
  on conflict on constraint set_offers_pkey do update
    set offered_at = now(), targeted = false;

  return query select found_set.set_id, found_set.profile_id,
                      found_set.username, found_set.tier_idx,
                      found_set.div_idx, found_set.reps, found_set.rep_times,
                      found_set.avatar_url, found_set.xp;
end;
$$;

-- A specific lifter's reserved set, for a rematch.
--
-- The counterpart to `find_opponent_set` above: that one hands out anybody's
-- unraced minute at random, this one hands out exactly the one minute
-- [from_id] reserved for the caller by naming them in `challenge_target`.
-- Nothing about level or "not already faced" applies — a rematch is by
-- definition the same two people again, which is the one thing the open pool
-- refuses to pair.
drop function if exists find_targeted_set(uuid);
create or replace function find_targeted_set(from_id uuid)
returns table (
  set_id uuid,
  profile_id uuid,
  username text,
  tier_idx int,
  div_idx int,
  reps int,
  rep_times int[],
  avatar_url text,
  xp int
)
language plpgsql
security definer
set search_path = public
as $$
declare
  found_set record;
begin
  -- Only a subscriber plays (see subscriptions.sql; off until switched on).
  perform require_pro();
  select s.id as set_id, p.id as profile_id, p.username, p.tier_idx,
         p.div_idx, s.reps, s.rep_times, p.avatar_url, p.xp
    into found_set
  from sets s
  join profiles p on p.id = s.profile_id
  where s.claimed_by is null
    and s.profile_id = from_id
    and s.challenge_target = auth.uid()
    and not s.practice
    -- A block still holds even over a challenge sent before it happened.
    and not exists (
      select 1 from blocks b
      where (b.blocker = auth.uid() and b.blocked = from_id)
         or (b.blocker = from_id and b.blocked = auth.uid())
    )
  order by s.created_at desc
  limit 1;

  if not found then
    return;
  end if;

  -- A rematch: settle_duel will settle it, and will not let it move a rank.
  insert into set_offers (set_id, offered_to, targeted)
  values (found_set.set_id, auth.uid(), true)
  on conflict on constraint set_offers_pkey do update
    set offered_at = now(), targeted = true;

  return query select found_set.set_id, found_set.profile_id,
                      found_set.username, found_set.tier_idx,
                      found_set.div_idx, found_set.reps, found_set.rep_times,
                      found_set.avatar_url, found_set.xp;
end;
$$;

-- ─────────────────────────────── placements ─────────────────────────────────

-- Where an account stands after its placement duel.
--
-- One ranked duel places an account, and placement_rank puts everybody at
-- Iron V whatever the result. `done` is how many have been played counting
-- this one, so it is always at least one here; the guard is for a caller
-- that asks before any.
-- The parameters are named `from_*` because the returned columns are called
-- `tier_idx`, `div_idx` and `lp`, and Postgres refuses a function whose
-- inputs and outputs share a name.
create or replace function place_after(
  done int, wins int, from_tier int, from_div int, from_lp int
)
returns table (tier_idx int, div_idx int, lp int)
language plpgsql
immutable
set search_path = public
as $$
begin
  if done < 1 then
    return query select from_tier, from_div, from_lp;
  else
    return query select * from placement_rank(wins);
  end if;
end;
$$;

-- Accounts caught part-way through the old five placements when one became
-- enough: they have played their placement, so they are placed — Iron V, no
-- LP, and marked done the way every placed account is.
do $$
begin
  perform set_config('outrepd.settling', 'on', true);
  update profiles
     set placements_done = 5, tier_idx = 0, div_idx = 0, lp = 0
   where placements_done between 1 and 4;
  perform set_config('outrepd.settling', 'off', true);
end $$;

-- ───────────────────────────── settling a duel ───────────────────────────────

-- Compares the caller's set against a stored one and moves both ranks.
--
-- The caller passes only their own set and the one they faced. Everything that
-- decides the outcome — the reps, who gave up, both tiers — is read from the
-- rows, never from arguments, because an argument is whatever the phone felt
-- like sending.
--
-- Dropped first: a function's result columns cannot change in place, and
-- `was_ranked` was added after the others.
drop function if exists settle_duel(uuid, uuid, boolean);
-- The two-argument one from before `ranked` existed. A new argument makes a
-- second function beside the old rather than replacing it, and the old one
-- stayed on the live database, callable, without the checks added since —
-- found on 2026-10-15 by comparing the live schema with this file. No app
-- that shipped calls it: every one sends `ranked`.
drop function if exists settle_duel(uuid, uuid);
create or replace function settle_duel(
  my_set uuid,
  their_set uuid,
  ranked boolean default true
)
returns table (
  duel_id uuid,
  won boolean,
  lp_delta int,
  tier_idx int,
  div_idx int,
  lp int,
  -- The record and the placements, read back off the row this same call just
  -- wrote. The app used to be trusted to derive these locally from the same
  -- rules — win/loss, the streak, the five placement duels — and two copies
  -- of a rule is two rules. Returning them is cheaper than that ever going
  -- wrong.
  wins int,
  losses int,
  win_streak int,
  best_streak int,
  placements_done int,
  placement_wins int,
  -- Whether it moved the ladder after all. The phone asks for ranked; the
  -- rules above can still make it friendly — a rematch, a third duel in a
  -- day with the same lifter — and the result screen has to say which.
  was_ranked boolean
)
language plpgsql
security definer
set search_path = public
as $$
declare
  mine sets;
  theirs sets;
  me profiles;
  them profiles;
  me_after profiles;
  i_won boolean;
  after record;
  their_after record;
  d_id uuid;
  is_ranked boolean := coalesce(ranked, true);
  my_placing boolean;
  their_placing boolean;
  my_delta int;
  their_delta int;
  my_pts int;
  their_pts int;
  offer set_offers;
begin
  -- Only a subscriber plays (see subscriptions.sql; off until switched on).
  perform require_pro();
  select * into mine   from sets where id = my_set    for update;
  select * into theirs from sets where id = their_set for update;

  if mine is null or theirs is null then
    raise exception 'set not found';
  end if;
  if mine.profile_id <> auth.uid() then
    raise exception 'that is not your set';
  end if;
  if mine.claimed_by is not null or theirs.claimed_by is not null then
    -- A set is faced once. Without this, replaying the same pair of ids is
    -- free LP for whoever calls it twice.
    raise exception 'one of these sets has already been played';
  end if;
  if mine.profile_id = theirs.profile_id then
    raise exception 'cannot duel yourself';
  end if;
  if mine.practice or theirs.practice then
    raise exception 'a practice set is not raced';
  end if;

  -- How the two sets met decides whether they may be settled at all, and
  -- whether the result moves a rank. Not the `ranked` the phone sends: that
  -- is only ever allowed to make a duel *less* than what it was.
  if mine.live_match is not null or theirs.live_match is not null then
    -- Lifted against each other on camera. Only live.sql writes live_match,
    -- and it writes the same one into both sets of a match.
    if mine.live_match is distinct from theirs.live_match then
      raise exception 'these sets were not raced against each other';
    end if;
    select lm.ranked into is_ranked
      from live_matches lm where lm.id = mine.live_match;
    is_ranked := coalesce(is_ranked, false);
  else
    -- Raced from the pool or from a challenge: their set has to be one the
    -- find_ functions handed this account, recently, and this account's set
    -- the one lifted after it.
    select * into offer from set_offers o
     where o.set_id = theirs.id
       and o.offered_to = auth.uid()
       and o.offered_at > now() - interval '2 hours';
    if not found then
      raise exception 'that set was never handed to you';
    end if;
    if mine.created_at < offer.offered_at then
      raise exception 'your set has to be the one lifted against theirs';
    end if;
    -- A rematch never moves a rank: two people who can arrange rematches
    -- between themselves could otherwise arrange each other's LP.
    if offer.targeted then
      is_ranked := false;
    end if;
  end if;

  -- No cap on how often the same two can pay each other. There were two a
  -- day; but two people the search pairs are a match like any other, and a
  -- friend's match is friendly from the start, so every ranked one counts.

  select * into me   from profiles where id = mine.profile_id   for update;
  select * into them from profiles where id = theirs.profile_id for update;

  -- Walking out is a loss whatever the count said at the moment you left.
  i_won := case
             when mine.gave_up   then false
             when theirs.gave_up then true
             else mine.reps >= theirs.reps
           end;

  -- The guard on profiles lets these two updates through, and only these.
  perform set_config('outrepd.settling', 'on', true);

  -- An account's first ranked duel places it: no LP is paid on it, and
  -- whatever the result it starts at Iron V (place_after). A placed account
  -- is marked with placements_done = 5, not 1 — five is what every check on
  -- the server reads as placed, and what an app from before one duel was
  -- enough reads that way too.
  my_placing    := is_ranked and me.placements_done   < 5;
  their_placing := is_ranked and them.placements_done < 5;

  if not is_ranked then
    -- A friend room is a real duel and not a rung. It moves nothing: not the
    -- ladder, not the placements, not the win record the ladder is built on.
    my_delta := 0;
    their_delta := 0;
    select me.tier_idx, me.div_idx, me.lp into after;
    select them.tier_idx, them.div_idx, them.lp into their_after;
  elsif my_placing then
    my_delta := 0;
    select * into after from place_after(
      me.placements_done + 1,
      me.placement_wins + (case when i_won then 1 else 0 end),
      me.tier_idx, me.div_idx, me.lp
    );
  else
    -- Floored at the bottom of Iron, not at the best tier ever held
    -- (2026-11-02).
    my_delta := lp_for(i_won, mine.reps, theirs.reps);
    select * into after from apply_lp(
      me.tier_idx, me.div_idx, me.lp, my_delta, 0
    );
  end if;

  if is_ranked and their_placing then
    their_delta := 0;
    select * into their_after from place_after(
      them.placements_done + 1,
      them.placement_wins + (case when i_won then 0 else 1 end),
      them.tier_idx, them.div_idx, them.lp
    );
  elsif is_ranked then
    their_delta := lp_for(not i_won, theirs.reps, mine.reps);
    select * into their_after from apply_lp(
      them.tier_idx, them.div_idx, them.lp, their_delta, 0
    );
  end if;

  -- What it adds to each side's week and month on the boards, from the
  -- streaks as they stand before it.
  if is_ranked then
    my_pts := board_points(i_won, me.win_streak, me.id);
    their_pts := board_points(not i_won, them.win_streak, them.id);
  end if;

  -- Everything below writes the ladder, and an unranked duel writes none of
  -- it. It is recorded in `duels` and that is all.
  if is_ranked then

    -- Every bare column read below is qualified as `profiles.col` rather than
    -- `col`. RETURNS TABLE above declares output columns of these same names
    -- (wins, losses, win_streak, best_streak, placements_done,
    -- placement_wins), which plpgsql turns into variables of those exact
    -- names in scope for the rest of the function — so an unqualified read
    -- here is genuinely ambiguous between "the column this statement is
    -- updating" and "the output this function will return". The assignment
    -- targets (the name left of each `=`) never need this: SET's target list
    -- can only ever mean the column.
    update profiles set
      tier_idx = after.tier_idx,
      div_idx  = after.div_idx,
      lp       = after.lp,
      peak_tier_idx = greatest(peak_tier_idx, after.tier_idx),
      -- Every ranked duel leaves an account placed: it was already, or this
      -- was its placement.
      placements_done = 5,
      placement_wins  = profiles.placement_wins
                        + (case when my_placing and i_won then 1 else 0 end),
      -- A placement is a real duel and its result is a real result, so the
      -- record counts it even though it pays no LP.
      wins        = profiles.wins   + (case when i_won then 1 else 0 end),
      losses      = profiles.losses + (case when i_won then 0 else 1 end),
      win_streak  = case when i_won then profiles.win_streak + 1 else 0 end,
      best_streak = greatest(profiles.best_streak,
                             case when i_won then profiles.win_streak + 1 else 0 end),
      -- Reps were counted when the set was stored, by the trigger on `sets`.
      updated_at = now()
    where id = me.id;

    update profiles set
      tier_idx = their_after.tier_idx,
      div_idx  = their_after.div_idx,
      lp       = their_after.lp,
      peak_tier_idx = greatest(peak_tier_idx, their_after.tier_idx),
      placements_done = 5,
      placement_wins  = profiles.placement_wins
                        + (case when their_placing and not i_won then 1 else 0 end),
      wins        = profiles.wins   + (case when i_won then 0 else 1 end),
      losses      = profiles.losses + (case when i_won then 1 else 0 end),
      win_streak  = case when i_won then 0 else profiles.win_streak + 1 end,
      best_streak = greatest(profiles.best_streak,
                             case when i_won then 0 else profiles.win_streak + 1 end)
      -- Their reps were counted when their set was stored, not again here.
    where id = them.id;
  end if;

  insert into duels (
    challenger, defender, challenger_set, defender_set,
    winner, ranked, lp_challenger, lp_defender, pts_challenger, pts_defender
  ) values (
    me.id, them.id, mine.id, theirs.id,
    case when i_won then me.id else them.id end,
    is_ranked, my_delta, their_delta, coalesce(my_pts, 0), coalesce(their_pts, 0)
  ) returning id into d_id;

  update sets set claimed_by = d_id where id in (mine.id, theirs.id);
  delete from set_offers o where o.set_id in (mine.id, theirs.id);

  perform set_config('outrepd.settling', 'off', true);

  -- Read back rather than tracked through the branches above: the update
  -- above may not even have run (a friend duel touches nothing), and this is
  -- correct either way — the row's current state, whatever wrote it last.
  select * into me_after from profiles where id = me.id;

  return query select d_id, i_won, my_delta,
                      after.tier_idx, after.div_idx, after.lp,
                      me_after.wins, me_after.losses, me_after.win_streak,
                      me_after.best_streak, me_after.placements_done,
                      me_after.placement_wins, is_ranked;
end;
$$;

-- ──────────────────────────────── the history ────────────────────────────────

-- The caller's duels, newest first, from the caller's side: what the phone's
-- history is made of. The phone writes down what it watches happen, but not
-- everything does: a set raced while its owner was away happens on the other
-- phone, a live result can land after its screen was closed, and a result
-- can be settled here and its answer lost on the way back. Each of those
-- moved the rank and reached nobody's history. Fifty, the length of the
-- history the phone keeps.
--
-- `raced_while_away` marks the first kind: the only duels a phone that kept
-- its own history before this existed never wrote down.
drop function if exists my_raced_sets();
create or replace function my_duels()
returns table (
  duel_id uuid,
  played_at timestamptz,
  opponent_name text,
  opponent_tier int,
  you_won boolean,
  your_reps int,
  their_reps int,
  lp_delta int,
  raced_while_away boolean
)
language sql
stable
security definer
set search_path = public
as $$
  -- Each side read from its own index and cut at fifty before the two are
  -- put together, so a lifter with thousands of duels costs a hundred rows.
  with mine as (
    (select d.* from duels d where d.challenger = auth.uid()
      order by d.created_at desc limit 50)
    union all
    (select d.* from duels d where d.defender = auth.uid()
      order by d.created_at desc limit 50)
  )
  select d.id, d.created_at, p.username, p.tier_idx,
         coalesce(d.winner = auth.uid(), false),
         case when d.challenger = auth.uid() then cs.reps else ds.reps end,
         case when d.challenger = auth.uid() then ds.reps else cs.reps end,
         case when d.challenger = auth.uid() then d.lp_challenger
              else d.lp_defender end,
         d.defender = auth.uid() and ds.live_match is null
    from mine d
    join sets cs on cs.id = d.challenger_set
    join sets ds on ds.id = d.defender_set
    join profiles p on p.id = case when d.challenger = auth.uid()
                                   then d.defender else d.challenger end
   order by d.created_at desc
   limit 50;
$$;

revoke all on function my_duels() from public, anon;
grant execute on function my_duels() to authenticated;

revoke all on function settle_duel(uuid, uuid, boolean) from public;
grant execute on function settle_duel(uuid, uuid, boolean) to authenticated;
revoke all on function find_opponent_set(int) from public;
grant execute on function find_opponent_set(int) to authenticated;
revoke all on function find_targeted_set(uuid) from public;
grant execute on function find_targeted_set(uuid) to authenticated;
