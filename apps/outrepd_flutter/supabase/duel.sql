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

-- ───────────────────────────── finding somebody ──────────────────────────────

-- A stored set from somebody near your level that you have not faced.
--
-- Async on purpose: two people being free in the same minute is the hardest
-- thing to arrange in a fitness app, and it is not needed. You race their
-- minute, they find out they were raced.
create or replace function find_opponent_set(within_levels int default 6)
returns table (
  set_id uuid,
  profile_id uuid,
  username text,
  tier_idx int,
  div_idx int,
  reps int,
  rep_times int[]
)
language plpgsql
security definer
set search_path = public
as $$
declare
  me profiles;
begin
  -- Only a subscriber plays (see subscriptions.sql; off until switched on).
  perform require_pro();
  select * into me from profiles where id = auth.uid();
  if me is null then
    raise exception 'no profile for this account';
  end if;

  return query
  select s.id, p.id, p.username, p.tier_idx, p.div_idx, s.reps, s.rep_times
  from sets s
  join profiles p on p.id = s.profile_id
  where s.claimed_by is null
    and s.profile_id <> me.id
    -- Reserved for a rematch is not offered to the open pool — the whole
    -- point of naming a challenge_target is that only they can find it, with
    -- find_targeted_set below.
    and s.challenge_target is null
    -- Near your level, measured in rungs rather than tiers: the difference
    -- between the top and the bottom of one tier is five divisions, and
    -- matching "same tier" would pair those two.
    and abs(ladder_level(p.tier_idx, p.div_idx)
          - ladder_level(me.tier_idx, me.div_idx)) <= within_levels
    -- Not somebody you have already faced. A ladder that keeps pairing the
    -- same two people is a ladder of two.
    and not exists (
      select 1 from duels d
      where (d.challenger = me.id and d.defender = p.id)
         or (d.defender = me.id and d.challenger = p.id)
    )
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
    -- A block works whichever of the two is holding the phone, so both
    -- directions are checked. Neither is told which one it was.
    and not exists (
      select 1 from blocks b
      where (b.blocker = me.id and b.blocked = p.id)
         or (b.blocker = p.id and b.blocked = me.id)
    )
    -- A mute is one-directional and only ever checked from the muter's own
    -- side: it says "stop offering me them," not "stop offering them me."
    and not exists (
      select 1 from mutes m
      where m.muter = me.id and m.muted = p.id
    )
  -- Oldest first: a set that has been waiting is the one most likely to have
  -- been forgotten about, and its owner is owed a result.
  order by s.created_at
  limit 1;
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
create or replace function find_targeted_set(from_id uuid)
returns table (
  set_id uuid,
  profile_id uuid,
  username text,
  tier_idx int,
  div_idx int,
  reps int,
  rep_times int[]
)
language plpgsql
security definer
set search_path = public
as $$
begin
  -- Only a subscriber plays (see subscriptions.sql; off until switched on).
  perform require_pro();
  return query
  select s.id, p.id, p.username, p.tier_idx, p.div_idx, s.reps, s.rep_times
  from sets s
  join profiles p on p.id = s.profile_id
  where s.claimed_by is null
    and s.profile_id = from_id
    and s.challenge_target = auth.uid()
    -- A block still holds even over a challenge sent before it happened.
    and not exists (
      select 1 from blocks b
      where (b.blocker = auth.uid() and b.blocked = from_id)
         or (b.blocker = from_id and b.blocked = auth.uid())
    )
  order by s.created_at desc
  limit 1;
end;
$$;

-- ─────────────────────────────── placements ─────────────────────────────────

-- Where an account stands after a placement duel.
--
-- Nothing moves until the fifth one, and then the whole rank is set at once
-- from how many were won. A tier handed out after one duel is a tier decided
-- by one opponent.
-- The parameters are named `from_*` because the returned columns are called
-- `tier_idx`, `div_idx` and `lp`, and Postgres refuses a function whose
-- inputs and outputs share a name.
create or replace function place_after(
  done int, wins int, from_tier int, from_div int, from_lp int
)
returns table (tier_idx int, div_idx int, lp int)
language plpgsql
immutable
as $$
begin
  if done < 5 then
    -- Nothing moves until the fifth. The account stays exactly where it was.
    return query select from_tier, from_div, from_lp;
  else
    return query select * from placement_rank(wins);
  end if;
end;
$$;

-- ───────────────────────────── settling a duel ───────────────────────────────

-- Compares the caller's set against a stored one and moves both ranks.
--
-- The caller passes only their own set and the one they faced. Everything that
-- decides the outcome — the reps, who gave up, both tiers — is read from the
-- rows, never from arguments, because an argument is whatever the phone felt
-- like sending.
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
  placement_wins int
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

  -- Placements move no rank, because there is not one yet. Five duels decide
  -- where an account starts and nothing is paid until they are done — which
  -- is the whole point of them, and the app says so on screen.
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
    my_delta := lp_for(i_won, mine.reps, theirs.reps);
    select * into after from apply_lp(
      me.tier_idx, me.div_idx, me.lp, my_delta, me.peak_tier_idx
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
      them.tier_idx, them.div_idx, them.lp, their_delta, them.peak_tier_idx
    );
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
      placements_done = least(profiles.placements_done + 1, 5),
      placement_wins  = profiles.placement_wins
                        + (case when my_placing and i_won then 1 else 0 end),
      -- A placement is a real duel and its result is a real result, so the
      -- record counts it even though the rank does not move yet.
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
      placements_done = least(profiles.placements_done + 1, 5),
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
    winner, ranked, lp_challenger, lp_defender
  ) values (
    me.id, them.id, mine.id, theirs.id,
    case when i_won then me.id else them.id end,
    is_ranked, my_delta, their_delta
  ) returning id into d_id;

  update sets set claimed_by = d_id where id in (mine.id, theirs.id);

  perform set_config('outrepd.settling', 'off', true);

  -- Read back rather than tracked through the branches above: the update
  -- above may not even have run (a friend duel touches nothing), and this is
  -- correct either way — the row's current state, whatever wrote it last.
  select * into me_after from profiles where id = me.id;

  return query select d_id, i_won, my_delta,
                      after.tier_idx, after.div_idx, after.lp,
                      me_after.wins, me_after.losses, me_after.win_streak,
                      me_after.best_streak, me_after.placements_done,
                      me_after.placement_wins;
end;
$$;

revoke all on function settle_duel(uuid, uuid, boolean) from public;
grant execute on function settle_duel(uuid, uuid, boolean) to authenticated;
revoke all on function find_opponent_set(int) from public;
grant execute on function find_opponent_set(int) to authenticated;
revoke all on function find_targeted_set(uuid) from public;
grant execute on function find_targeted_set(uuid) to authenticated;
