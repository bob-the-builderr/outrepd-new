# The server at ten thousand lifters

Never run against the real project: these write ten thousand made-up
accounts and a timing function into whatever database they are given.

On a scratch Postgres with the stand-ins and the installer already in it
(the same three steps as CI's server job: `tool/db/stubs.sql`, then
`supabase/install.sql`):

1. `seed.sql` — 10,000 lifters, 200,000 sets, ~85,000 duels, friends,
   notices, live matches, and a live queue nobody cleaned up (≈150 MB).
2. `bench.sql` — every call the app makes, as a signed-in lifter, averaged
   over twenty runs.
3. `season_test.sql` — the month's running totals (`season_points`) against
   the duels they come from: a raced set, a live match, an unranked duel,
   an account deleted. Every line should end in 0.

What it found on 2026-10-14, and what changed:

| Call | Before | After |
|---|---|---|
| `find_opponent_set` | 267 ms | 7 ms |
| `my_month_place` | 225 ms | 13 ms |
| `month_board` | 82 ms | 25 ms |
| `live_online` (every 3 s while searching) | 11 ms | 0.8 ms |

Everything else was already under 25 ms.
