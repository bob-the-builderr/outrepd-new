# The server at scale

Never run against the real project: these write made-up
accounts and a timing function into whatever database they are given.

On a scratch Postgres with the stand-ins and the installer already in it
(the same three steps as CI's server job: `tool/db/stubs.sql`, then
`supabase/install.sql`):

1. `seed.sql` — `psql -v n=100000` lifters (10,000 when n is not given),
   twenty sets each, a duel per two claimed sets (this week's too), friends,
   notices, live matches, challenge links, a live queue nobody cleaned up,
   the month totals, and the months before closed with their awards.
2. `bench.sql` — every call the app makes, as a signed-in lifter, averaged
   over twenty runs.
3. `season_test.sql` — the month's running totals (`season_points`) against
   the duels they come from: a raced set, a live match, an unranked duel,
   an account deleted. Every line should end in 0.
4. `load/` — pgbench scripts: the app's mix of calls from many phones at
   once (`setup.sql` first; `-D n=<lifters>`).

On CI: `.github/workflows/scale.yml` does all four on a Postgres held to a
Supabase compute size (2 cores and 2 GB by default) and lists the heaviest
statements; `bash tool/ci/run_scale.sh 100000` runs it and prints
`ci-builds:scale/100000.txt`.

What it found on 2026-10-14, and what changed:

| Call | Before | After |
|---|---|---|
| `find_opponent_set` | 267 ms | 7 ms |
| `my_month_place` | 225 ms | 13 ms |
| `month_board` | 82 ms | 25 ms |
| `live_online` (every 3 s while searching) | 11 ms | 0.8 ms |

Everything else was already under 25 ms.
