# Where OUTREPD stands — 2026-11-03

Read with `CLAUDE.md` (how this machine works). Branch `camera-rep-counter`,
everything pushed to `bob-the-builderr/outrepd-new`; the last CI run
(093b17d) was green on every job.

## Versions

- **1.1.5** is live on Google Play and the App Store (since 2026-10-31).
- **1.1.6** (`1.1.6+1` in `pubspec.yaml` and `kAppVersion`) was built once:
  Android 273 / iOS 278 at a56f2a3, uploaded, not submitted for review.
  That build has the name fix (`rememberUsername`), last month's winners,
  remove/crop profile photo, the rating system, the live-match HUD "B",
  the simple depth bar, and LevelPlay ads with AdMob behind it.
- **Since that build** (in no store build yet): the clean "direction B"
  look on home, friends, settings, ranks and profile; Ranks simplified
  (one strip Week · Month · Overall, Your Tier removed, "How points work"
  sheet, podium in tier frames); Ranks among friends; the home tiles
  growing with large text. The next build is one CI run with `[ios]` in
  the commit message, **only when the user says the batch is done**.

## Server

The live Supabase project is on **1.1.6** since 2026-11-02: the user pasted
`Desktop/outrepd-update-1.1.6.sql` (= `supabase/install.sql` as of 23f889f).
An anon probe finds `friends_board`, `friends_leaderboard`,
`last_month_winners` there. `tool/db/live/install.sql` is that file.
`tool/db/upgrade_seed.sql` and `upgrade_check.sql` were written for the
1.1.5 → 1.1.6 paste; if the `server` job turns red, rewrite them for the
next upgrade.

## What the user picked (do not undo)

- **Rating:** starts at 1,000; 100 a division, 500 a tier; a win is +25
  plus the rep gap, a loss −20 minus the gap; floor 1,000 only (a tier can
  be lost). **Week/month boards:** win +5, loss −2, the third win in a row
  +10 (then the streak restarts), nothing after 20 ranked duels in a day.
- **Look "direction B" (simple and clean):** title case page titles 28
  w700, section labels 14 w600 muted, cards `#1A1918` radius 16 without
  borders, lists grouped one card per section with hairlines, secondary
  buttons filled `#262421`. The bottom tab bar stays exactly as it is.
- **Ranks:** pick A (one strip), Friends beside World/Country in the
  button by the title (pick B), "How points work" at the far right of the
  line (pick A), your own row outlined cream inside every board.
- **Live match:** HUD "B" (giant numbers, clock ring, red flag to stop);
  depth bar = a plain bar, down to the bottom and back up counts a rep.
  The user rejected many fancier bars — do not propose them again.
- **Ads:** after every game from the first; Pro offered every 5 games;
  Pro removes ads. LevelPlay first, AdMob when LevelPlay has none.
  Seven taps on the version in Settings opens LevelPlay's test suite.

## Left before 1.1.6 is submitted

1. LevelPlay's `app-ads.txt` lines on outrepd.com (from the LevelPlay
   dashboard; site push needs the user's yes).
2. AdMob → Privacy & messaging → the GDPR message: add Unity and ironSource
   as ad partners (the user does it).
3. Privacy page and the App Store / Play privacy forms: name Unity. The
   unpublished site change in `docs/site-pending/` belongs with this.
4. **Store description in 50 languages is wrong now** (`apps/outrepd_flutter/store/aso/en.js`,
   `app_langs.js`): it says LP, "beat a higher rank and you earn more LP"
   and "once you reach a tier, you keep it". Plus What's New for 1.1.6.
   The user said "not now" on 2026-11-02 — do it before submission.
5. On a real phone: the photo crop screen (native, no CI screenshot can
   show it) and changing the username.

## Ads setup on the dashboards (2026-11-03, in progress, the user's side)

- LevelPlay: both apps there with the keys built into 1.1.6, "Live in
  store", COPPA "Not directed"; the iOS interstitial ad unit
  (s1m7x1s18dr5m929) is active with **one network, ironSource Ads**.
- **Unity Ads was not set up.** LevelPlay's bidder auto-setup does not work
  with the new Unity dashboard, so it is manual: on cloud.unity.com →
  Monetization the user added both apps (child-directed: No) and is making
  an **Interstitial, Bidding** placement for each. Then in LevelPlay →
  Networks → Unity Ads: API key + Organization core ID (+ the service
  account's Key ID/Secret, roles LevelPlay Automation + Ads Publisher
  Automation), and per app the Game ID and Placement ID. Done when each
  app's ad unit shows Networks: 2. No new build needed: the Unity Ads
  adapter is already in 1.1.6.
- **Rewarded ads: later** (the user, 2026-11-03). Pays the most and people
  choose it; the reward must not touch ranked (ideas: continue a lost
  Adventure level, double XP next match, skip the next forced ad). Mock
  up first. Banner ads: advised against (little money, breaks the clean
  look, would crowd the tab bar).

## Optional, only if the user asks (mock up first)

The other screens are still in the old look: after-match, Adventure map,
another lifter's profile, settings sub-pages, the "Bring a friend" card on
Friends. The lifter-character catalog mockup on the Desktop is still
waiting for the user's OK.

## Files on the Desktop

- `outrepd-update-1.1.6.sql` — the server update that is now live.
- `OUTREPD-ui-cleanup/` — the direction B, Ranks and How-points mockups the
  user picked from.
