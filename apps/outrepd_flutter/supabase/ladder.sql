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
  language sql immutable as $$ select 4 $$;

-- Seven tiers, Iron to Master. It was nine: Mythic and Legend sat above
-- Master until the crest artwork settled at seven, and the app's own
-- `kTiers` is the other half of this number. They have to move together or
-- the server will hand out a rank the app cannot draw.
create or replace function top_tier() returns int
  language sql immutable as $$ select 6 $$;

-- The rung somebody is standing on, counted from the bottom, starting at 1.
create or replace function ladder_level(tier_idx int, div_idx int)
returns int
language sql immutable
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
create or replace function lp_for(won boolean, your_reps int, their_reps int)
returns int
language sql
immutable
as $$
  select case when won then abs(your_reps - their_reps)
              else -abs(your_reps - their_reps) end;
$$;

-- ───────────────────────── applying it to a rank ─────────────────────────────

-- Carries a change through as many promotions or demotions as it earns, and
-- holds the floor: a tier once reached cannot be lost.
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
as $$
declare
  t int := from_tier;
  d int := from_div;
  p int := from_lp + delta;
begin
  while p >= 100 loop
    if t >= top_tier() and d >= top_division() then
      -- Nothing above this. LP stops rather than rolling over into a tier that
      -- does not exist.
      p := 99;
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

-- Wins decide it and nothing else. Margin would let somebody buy a start by
-- picking soft opponents, and five duels is far too small a sample to read
-- anything finer than "how often did they win".
create or replace function placement_rank(wins int)
returns table (tier_idx int, div_idx int, lp int)
language sql
immutable
as $$
  -- The twin of the table in `lib/ranking.dart`. Re-spaced when the ladder
  -- went from nine tiers to seven: a clean sweep used to land at Gold IV,
  -- which is the middle of seven, and placements are not meant to hand
  -- anybody the middle of the app on their first afternoon.
  select * from (values
    (0, 2, 0),  -- no wins     → Iron III
    (0, 4, 0),  -- one in five → Iron I
    (1, 2, 0),  -- two         → Bronze III
    (1, 4, 0),  -- three       → Bronze I
    (2, 2, 0),  -- four        → Silver III
    (2, 4, 0)   -- all five    → Silver I
  ) as ladder(tier_idx, div_idx, lp)
  offset least(greatest(wins, 0), 5) limit 1;
$$;
