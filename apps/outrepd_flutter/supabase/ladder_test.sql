-- Replays `supabase/ladder_vectors.json` through the SQL ladder.
--
-- The vectors are generated from `lib/ranking.dart`, so this asks one
-- question: does the server compute the same LP the app just showed somebody?
-- If it does not, the app is telling lifters one number and giving them
-- another, and nothing else in the system would ever notice.
--
-- Run it against a project after applying `ladder.sql`:
--
--   psql "$DATABASE_URL" -v vectors="$(cat supabase/ladder_vectors.json)" \
--        -f supabase/ladder_test.sql
--
-- It prints the disagreements and raises if there are any, so it can sit in
-- CI without anybody having to read the output.

\set ON_ERROR_STOP on

create temporary table vectors (data jsonb);
insert into vectors values (:'vectors'::jsonb);

-- Called only when a comparison found rows, so reaching it is the failure.
create or replace function raise_disagreement(what text, n bigint)
returns text
language plpgsql
as $$
begin
  raise exception '% disagrees with the app on % case(s)', what, n;
end;
$$;

-- ── what a duel pays ─────────────────────────────────────────────────────────

with cases as (
  select * from vectors, jsonb_to_recordset(data -> 'lp_for') as c(
    won boolean, your_tier int, their_tier int,
    your_reps int, their_reps int, clean boolean, surrendered boolean,
    result int, tier_gap int, margin int, form int, total int
  )
),
computed as (
  select c.*, f.result as got_result, f.tier_gap as got_tier_gap,
         f.margin as got_margin, f.form as got_form, f.total as got_total
  from cases c,
  lateral lp_for(c.won, c.your_tier, c.their_tier,
                 c.your_reps, c.their_reps, c.clean, c.surrendered) f
)
select
  case when count(*) = 0 then 'lp_for: agrees on every case'
  else
    (raise_disagreement('lp_for', count(*)))
  end
from computed
where (result, tier_gap, margin, form, total)
   is distinct from
      (got_result, got_tier_gap, got_margin, got_form, got_total);

-- ── applying it to a rank ────────────────────────────────────────────────────

with cases as (
  select * from vectors, jsonb_to_recordset(data -> 'apply_lp') as c(
    from_tier int, from_div int, from_lp int, delta int, floor_tier int,
    tier_idx int, div_idx int, lp int
  )
),
computed as (
  select c.*, a.tier_idx as got_tier, a.div_idx as got_div, a.lp as got_lp
  from cases c,
  lateral apply_lp(c.from_tier, c.from_div, c.from_lp, c.delta, c.floor_tier) a
)
select
  case when count(*) = 0 then 'apply_lp: agrees on every case'
  else (raise_disagreement('apply_lp', count(*)))
  end
from computed
where (tier_idx, div_idx, lp) is distinct from (got_tier, got_div, got_lp);

-- ── the level, and where placements land ─────────────────────────────────────

with cases as (
  select * from vectors, jsonb_to_recordset(data -> 'ladder_level') as c(
    tier_idx int, div_idx int, level int
  )
)
select
  case when count(*) = 0 then 'ladder_level: agrees on every rung'
  else (raise_disagreement('ladder_level', count(*)))
  end
from cases
where level is distinct from ladder_level(tier_idx, div_idx);

with cases as (
  select * from vectors, jsonb_to_recordset(data -> 'placement_rank') as c(
    wins int, tier_idx int, div_idx int, lp int
  )
),
computed as (
  select c.*, p.tier_idx as got_tier, p.div_idx as got_div, p.lp as got_lp
  from cases c, lateral placement_rank(c.wins) p
)
select
  case when count(*) = 0 then 'placement_rank: agrees on every outcome'
  else (raise_disagreement('placement_rank', count(*)))
  end
from computed
where (tier_idx, div_idx, lp) is distinct from (got_tier, got_div, got_lp);
