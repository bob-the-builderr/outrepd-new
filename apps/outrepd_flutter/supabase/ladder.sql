-- The ladder arithmetic, server side.
--
-- This is a twin of `lib/ranking.dart`, and twins drift. The app computes the
-- same numbers to show them before and after a round; the server computes them
-- to *apply* them, because a client that could apply its own LP could type
-- itself to the top of the board.
--
-- `test/ladder_vectors.json` is generated from the Dart implementation and
-- replayed against these functions (`supabase/ladder_test.sql`). If the two
-- ever disagree the test says which case and by how much — which is the only
-- way this stays honest, because nothing else in the system would notice.

-- ───────────────────────────── the shape of a rank ───────────────────────────

-- Nine tiers of five divisions. Divisions climb V → I, so a higher div_idx is
-- better, and LP runs 0..99 inside one.
create or replace function top_division() returns int
  language sql immutable set search_path = public as $$ select 4 $$;

-- Seven tiers, Iron to Master. It was nine: Mythic and Legend sat above
-- Master until the crest artwork settled at seven, and the app's own
-- `kTiers` is the other half of this number. They have to move together or
-- the server will hand out a rank the app cannot draw.
create or replace function top_tier() returns int
  language sql immutable set search_path = public as $$ select 6 $$;

-- The rung somebody is standing on, counted from the bottom, starting at 1.
create or replace function ladder_level(tier_idx int, div_idx int)
returns int
language sql immutable
set search_path = public
as $$
  select least(greatest(tier_idx, 0), top_tier()) * (top_division() + 1)
       + least(greatest(div_idx, 0), top_division())
       + 1;
$$;

-- ───────────────────────────── what a duel pays ──────────────────────────────

-- Exactly the gap in reps, signed by who actually won. `won` and the reps
-- normally agree; they can only split when somebody walks out while still
-- ahead, which stays a loss regardless of the count at the moment of
-- quitting — a loss must never pay a gain. No tier, no form, no cap
-- otherwise: a blowout is worth exactly what it was.
--
-- The first version took tiers and form as well. A different argument list
-- is a different function to Postgres, so `or replace` left that one behind
-- on a database the first installer was pasted into; it is dropped by name.
drop function if exists lp_for(boolean, int, int, int, int, boolean, boolean);
-- The rule since 2026-11-02 (the user's): a win is 25 and the gap in reps
-- on top, a loss 20 and the gap. Who it was against no longer counts.
create or replace function lp_for(won boolean, your_reps int, their_reps int)
returns int
language sql
immutable
set search_path = public
as $$
  select case when won then 25 + abs(your_reps - their_reps)
              else -(20 + abs(your_reps - their_reps)) end;
$$;

-- It was weighed by who it was against until 2026-11-02. Kept, with the
-- ranks ignored, for anything installed before that still calls it.
create or replace function lp_for(
  won boolean, your_reps int, their_reps int, your_level int, their_level int
)
returns int
language sql
immutable
set search_path = public
as $$
  select lp_for(won, your_reps, their_reps);
$$;

-- ───────────────────────── applying it to a rank ─────────────────────────────

-- Carries a change through as many promotions or demotions as it earns. The
-- floor is the bottom of [floor_tier]; settle_duel passes Iron, so nobody
-- falls below 1,000 and any tier above it can be lost (2026-11-02). Master I
-- has no top: its LP keeps counting past 99.
create or replace function apply_lp(
  from_tier int,
  from_div int,
  from_lp int,
  delta int,
  floor_tier int
)
returns table (tier_idx int, div_idx int, lp int)
language plpgsql
immutable
set search_path = public
as $$
declare
  t int := from_tier;
  d int := from_div;
  p int := from_lp + delta;
begin
  while p >= 100 loop
    if t >= top_tier() and d >= top_division() then
      -- Nothing above this to roll into: LP keeps counting instead.
      exit;
    end if;
    p := p - 100;
    if d < top_division() then
      d := d + 1;
    else
      t := t + 1;
      d := 0;
    end if;
  end loop;

  while p < 0 loop
    if d = 0 and t <= floor_tier then
      p := 0;
      exit;
    end if;
    p := p + 100;
    if d > 0 then
      d := d - 1;
    else
      t := t - 1;
      d := top_division();
    end if;
  end loop;

  return query select t, d, p;
end;
$$;

-- ───────────────────────────── where placements land ─────────────────────────

-- Everybody starts in the same place. `wins` stays in the signature so a
-- caller from before the change still finds the function.
create or replace function placement_rank(wins int)
returns table (tier_idx int, div_idx int, lp int)
language sql
immutable
set search_path = public
as $$
  -- The twin of `placementRank` in `lib/ranking.dart`. One duel places an
  -- account, and it lands at the bottom whatever the result: Iron V with no
  -- LP. A single result says nothing about a lifter, so it decides nothing
  -- but that the climb has begun. (Until 1.1.4 five duels placed an account
  -- anywhere from Iron III to Silver I by how many were won.)
  select 0, 0, 0;
$$;
