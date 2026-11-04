# Where OUTREPD stands — 2026-11-04

Read with `CLAUDE.md` (how this machine works). Branch `camera-rep-counter`,
everything pushed to `bob-the-builderr/outrepd-new`.

## Versions

- **1.1.5** is live on Google Play and the App Store (since 2026-10-31).
- **1.1.6** (`1.1.6+1` in `pubspec.yaml` and `kAppVersion`): built several
  times, uploaded, not submitted for review. Android 290 / iOS 297 at
  72fd3c0 (2026-11-03). The user said the batch is done on 2026-11-04 and
  asked for new builds after a whole-app check; those builds carry
  everything below.
- **Since 72fd3c0:** the Match tab back to the big badge (beating, with
  embers; it takes the height the rest leaves; Find a match above today's
  goal; tier name at 20); the search is a face-off card whose seat flicks
  through drawn faces and lands on the opponent (lib/screens/vs_search.dart);
  Pro is asked about the signed-in account before it is offered (a
  subscriber was shown the offer at sign-up); the onboarding climb page as
  the picked design B2 (two cards).
- **Earlier on 2026-11-03:** rank cards wear their tier (lib/tier_card_frame.dart,
  Match tab and profile); the card a name opens is a player card with a
  Pro look; new share cards (match and profile, story and post, Pro look).
- Store screenshots for 1.1.6 are in Desktop/mokhtar/OUTREPD 1.1.6 store
  screenshots; **07-home must be re-rendered** with the new Match tab
  (scratchpad makeA.js; the chip there was moved to the goal card).

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

1. ~~app-ads.txt~~ — done 2026-11-03: outrepd.com/app-ads.txt has AdMob,
   Unity Ads and ironSource (see `docs/site-pending/README.md`).
2. ~~AdMob GDPR ad partners~~ — checked 2026-11-03: ironSource Mobile and
   Unity Ads were already in the European regulations ad partners. Two
   European regulations messages were published for the same two apps;
   the user was told to switch off "Untitled European regulations message"
   (25 Oct, English only) and keep "outrepd European regulations message"
   (29 Oct, 7 languages) — check it is off.
3. Privacy page and the App Store / Play privacy forms: name Unity. The
   unpublished site change in `docs/site-pending/` belongs with this.
4. **Store description in 50 languages is wrong now** (`apps/outrepd_flutter/store/aso/en.js`,
   `app_langs.js`): it says LP, "beat a higher rank and you earn more LP"
   and "once you reach a tier, you keep it". Plus What's New for 1.1.6.
   The user said "not now" on 2026-11-02 — do it before submission.
5. On a real phone: the photo crop screen (native, no CI screenshot can
   show it) and changing the username.

## Ads setup on the dashboards (2026-11-03)

**Done:** Unity Ads is set up in LevelPlay and both interstitial ad units
show **Networks: 2** (ironSource Ads + Unity Ads): iOS s1m7x1s18dr5m929
with BP_Interstitial_iOS, Android f8y710tdcpfcz5i8 with
BP_Interstitial_Android. Unity Game IDs: iOS 800421449, Android
800421448, one instance each, All Countries. How it was set up:

- LevelPlay: both apps there with the keys built into 1.1.6, "Live in
  store", COPPA "Not directed"; the iOS interstitial ad unit
  (s1m7x1s18dr5m929) was active with one network, ironSource Ads.
- Unity Ads was set up by hand (LevelPlay's bidder auto-setup does not work
  with the new Unity dashboard): on cloud.unity.com → Monetization the user
  added both apps (child-directed: No) and an Interstitial, Bidding
  placement for each. Then in LevelPlay →
  Networks → Unity Ads: API key + Organization core ID (+ the service
  account's Key ID/Secret, roles LevelPlay Automation + Ads Publisher
  Automation), and per app the Game ID and Placement ID. Done when each
  app's ad unit shows Networks: 2. iOS on Unity: Game ID 800421449,
  placement BP_Interstitial_iOS; Organization core ID 11270732318333 (the
  Stats API key is the user's, kept out of the repo). No new build needed: the Unity Ads
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
