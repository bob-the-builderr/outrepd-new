# Website changes not published yet

The website is the separate repo `outrepd/outrepd` (Vercel, branch `main`
is live). A change here was made in a local clone and never pushed;
publishing it needs the user's yes.

- `ads-first-game.patch` — privacy and terms stop saying the first three
  games are free of ads (ads now come after every game from the first).
  Made on top of `main` at eefe1f7. Apply in a clone of `outrepd/outrepd`
  with `git am docs/site-pending/ads-first-game.patch`.

Still to write for the same release: the privacy page naming Unity
(LevelPlay) among the ad partners.
