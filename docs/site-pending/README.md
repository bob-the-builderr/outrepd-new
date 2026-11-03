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

- `app-ads/` — **published 2026-11-03** (site main d00dba4): outrepd.com/app-ads.txt
  = `app-ads/app-ads.txt`, built by `node docs/site-pending/app-ads/build.js 697369`
  (697369 = the ironSource publisher id) from AdMob's line, Unity Ads' list as its
  dashboard gave it (`unity.txt`) and ironSource's published resellers
  (`ironsource-resellers.txt`). When Unity or ironSource change their lists,
  update the .txt, rebuild, and push the site (the user's yes each time).
  Served at https://www.outrepd.com/app-ads.txt (outrepd.com redirects there).
