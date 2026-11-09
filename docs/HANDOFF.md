# Where OUTREPD stands — 2026-11-05

Read with `CLAUDE.md` (how this machine works). Branch `camera-rep-counter`,
everything pushed to `bob-the-builderr/outrepd-new`.

## Versions

- **1.1.5** is live on Google Play and the App Store (since 2026-10-31).
- **1.1.6** (`1.1.6+1` in `pubspec.yaml` and `kAppVersion`): **the user sent it to both
  stores on 2026-11-05 (Android 319, iOS 334); the review results are not
  recorded yet.** Earlier builds: Android 290 / iOS 297 at 72fd3c0
  (2026-11-03). The user said the batch is done on 2026-11-04 and
  asked for new builds after a whole-app check; those builds carry
  everything below.
- **Since 72fd3c0:** the Match tab back to the big badge (beating, with
  embers; it takes the height the rest leaves; Find a match above today's
  goal; tier name at 20); the search is a face-off card whose seat flicks
  through drawn faces and lands on the opponent (lib/screens/vs_search.dart);
  Pro is asked about the signed-in account before it is offered (a
  subscriber was shown the offer at sign-up); the onboarding climb page as
  the picked design B2 (two cards).
- **After testing build 299 (2026-11-04):** the badge floats with its own
  edge glow (pick C, no embers); the week tile and the bell refresh when
  shown and on resume; your own name on Ranks opens your profile tab; Pro
  plans retry on error 10; shared links carry www and your own opens your
  profile; Adventure stars belong to the account; startup no longer waits
  on the network. **Counter (950ac83):** a phone swung in the hand no
  longer counts — a rep needs a hand seen on its point in 10% of its frames
  and a hand back on its point is not re-planted where it passed through
  (`tool/bench/` = a JS port that replays the 14 sets locally; khalifa-27-a
  now 27 of 28, flagged unsure). **Weak networks (b6b434d):** requests give
  up after 20 s, avatars decode at drawn size. **assetlinks.json** on
  www.outrepd.com now has the Play app-signing key 9A:8D:ED:… as well
  (website commit a0aaa74, user's yes) — re-test a shared link on a Play
  install.
- **2026-11-04/05, after that:** saved sets and rematches get the VS
  screen (VsKind: live / saved / rematch); the "Race it" screen is gone;
  cancelling a search no longer warns about LP; the onboarding 3-rep page
  uses the live DepthBar and counts only real push-ups (same tracker); the
  "Only full reps count" page redrawn (pick B); TypeOut no longer jitters
  (the caret is painted); launch shows the cached profile at once
  (`Backend.cachedMe`); the Match tab's week card is gone (Adventure takes
  the whole width). **Pro content** (all the user's picks, generated from
  the approved mockups by `tool/lifter/pro_parts.js` into
  `lib/lifter/pro_art.dart`): 4 hair + 4 hair colours, 4 beards, 4 mouths,
  3 marks, 5 eyes, 4 tops, 5 gear, 4 avatar backgrounds, 6 creature skins
  (own face, everything else worn over it), 6 ready-made characters (worn
  only as they are: choosing anything but the background takes one off),
  4 profile covers (13 in all). The free afro was redrawn above the ears.
  A free account can try Pro parts on but never keeps one
  (`UnlockState.keepOwned`). Screenshots: `pro_parts_1/2/3`,
  `covers_new_1/2`, `beards`, `vs_*`.
- **2026-11-09, rewarded videos (cfa9f20, green on CI run 42555196052: analyze clean, 780 tests, shots, server security + upgrade):** the user's pick A + B + C (design/mockups/2026-11-09/rewarded_*). LevelPlay rewarded ad units `LEVELPLAY_IOS_REWARDED` / `LEVELPLAY_ANDROID_REWARDED` (secrets added with the user's yes; both workflows write them into keys.env). lib/ads.dart: `rewardOffered` (Pro always; anybody else only while a video is loaded) and `watchForReward(afterMatch:)`; a video watched on a result screen skips that match's interstitial. **A** XpDoubleCard (lib/screens/rewarded.dart) on a won duel the server settled: `double_duel_xp` pays its XP again, once (xp_doubles), for the caller's own side of a duel under 30 minutes old. **B** StreakBackCard on home when `rewards.streakRestorable` (an ended streak, once per 7 days): the missed days are forgiven, and `streakSaved` is merged by rewards_merge. **C** a locked Pro part in the lifter maker opens a sheet (Get Pro / Wear it free for a day): `start_pro_trial` records `profiles.pro_trial` (a server-only column, guarded), the phone keeps it in lib/lifter/pro_trial.dart (UnlockState.owns), pro_looks shows everybody the replaced part again after 24 h (`lifter_as_seen`), and the app puts it back at launch. The sheet's title is the existing "A Pro look." (parts have no translated names). Screens: `rewarded_xp_offer`, `rewarded_xp_doubled`, `rewarded_streak`, `rewarded_pro_part`. **Server:** Desktop/outrepd-update-1.1.7-challenge.sql was rebuilt and now holds rivals + challenge + rewarded, as one paste.
- **2026-11-09, challenge by link (9b878ee + a39c1e0, green on CI run 42549631498: analyze clean, 754 tests, shots, server security + upgrade):** the user's pick B + C (design/mockups/2026-11-09/challenge_*). Share on the result screen is now **Challenge** (lib/screens/challenge.dart, ChallengeButton); a **Challenge a friend** card under Find a match sends the best minute (ChallengeHomeCard, shown when bestSet > 0 and there is a server). The link `outrepd.com/c/<code>` (six of `2-9a-hjkmnp-z`) opens ChallengeScreen: the owner's minute raced like a saved set (MatchMode.link, VsKind.challenge, "CHALLENGE · FRIENDLY"), one try each, open 7 days, friendly (no duel row, no rank/record/week points; the reps count toward today's goal as practice). After a try: ChallengeResultView with the board and "Challenge <name> back". The owner gets `challenge_taken` (push + notice, opens "Your challenge" with Take it back on each try that beat it); a send-back is `challenge_back`. Profile › Challenges lists them (MyChallengesScreen). Server: supabase/challenge.sql (challenges, challenge_takes; make_challenge, challenge_best, open_challenge, take_challenge, back_challenge, my_challenges, public_challenge_card for the website, granted to anon in lockdown.sql); notify.sql has the two kinds and `challenge_code`, hidden from older apps unless `with_challenges`. Screens: `challenge_home/open/result/yours/sheet/card_post/card_story`, `vs_challenge`. **Waiting on the user:** (1) paste **Desktop/outrepd-update-1.1.7-challenge.sql** — it is the whole install.sql and already holds the rivals patch, so the older outrepd-update-1.1.7-rivals.sql is not needed; after the paste copy it over tool/db/live/install.sql. (2) Deploy the `push` function from Desktop/outrepd-push-function.ts (has the challenge words). (3) **Website** (needs the user's yes, not pushed): `c/index.html`, `c/challenge.js`, `c/challenge.css`, a `/c/:code` rewrite in vercel.json and `/c/*` in .well-known/apple-app-site-association — prepared in docs/website/challenge/ (paths as in the outrepd/outrepd repo); without the AASA line an iPhone opens /c/ links in Safari, and without the page a phone with no app gets a 404. The app build must carry the AndroidManifest `/c/` line (in a39c1e0). The paste must come before the next store build: the app asks my_notifications(with_challenges).
- **2026-11-09, rivals (73189a8, green on CI run 42532525829: 702 tests, server security + upgrade):** a friend passing you on this week's board is a notice and a push (notify_passed, week_points_of; my_notifications/unread_notifications(with_passed) hide it from older apps); a local reminder 6 h before the week closes (Sunday 18:00 UTC). **Waiting on the user:** paste Desktop/outrepd-update-1.1.7-rivals.sql, then deploy the `push` edge function from Desktop/outrepd-push-function.ts; after the paste, copy the file over tool/db/live/install.sql.
- **2026-11-08, one face everywhere (b7267de, green on CI run 42430269628: analyze clean, 699 tests):** lib/face.dart decides every person's picture for every screen (boards, friends, profile, VS, search, fighters, match, result, invites, picking a friend, privacy lists, share card): worn lifter from its parts, else photo (small copy in small circles), else the name's lifter; Pro + lifter alive, out over the ring on boards. Looks.want batches lookups. Builds 324 / 338 were never released, so the next build stays **1.1.7** with new build numbers (App Store takes another build for an unreleased version); it carries all of this. (The server file was named outrepd-update-1.1.8.sql; it is already pasted.)
- **2026-11-08, after 1.1.7 (not in any build yet):** 77d6e02 green on CI (run 42426856506, 693 tests, server rehearsal ok): a 192 px copy of each photo (`<id>/thumb.jpg`, lib/photo_thumb.dart, the `image` package) drawn on boards, friend rows, requests and the result screen; measured on a real photo 82,594 B to 7,733 B (9.4%). Friends rows no longer use Image.network; friends + requests read in parallel; deleting an account also removes thumb and cover. **Server:** the user pasted Desktop/outrepd-update-1.1.8.sql on 2026-11-08 (storage rules take thumb.jpg); tool/db/live/install.sql is that file now. Store download is about 35 MB a phone (arm64), not the 126 MB universal APK; the ML Kit accurate model (5.7 MB) is likely unused but only removable after a phone test.
- **2026-11-07, builds:** version **1.1.7** (pubspec + kAppVersion, 221fbfa): **Android 324** (AAB/APK, upload key, LevelPlay + AdMob, Firebase) and **iOS 338** (uploaded to TestFlight), both green. No server change in 1.1.7. Left to the user: Play release of 324 with notes, App Store 1.1.7 version + What's New, pick 338, submit.
- **2026-11-07:** another player's profile rebuilt (pick A, design/mockups/2026-11-07): a name opens it straight, no quick card; and the Friends tab has Friends and Ranks (pick B): you among your friends by rating, with what you two have done against each other, worked out on the phone. **CI green at 7857c59** (run 42404164001: analyze clean, 690 tests, shots, server, APK); `lifter_free`, `lifter_pro`, `lifter_stranger` and `friends_ranks` match the mockups.
- **2026-11-07, photos:** a photo chosen now reaches everybody: a failed upload is sent again when the account is read (it was tried once), a photo chosen over a made lifter is marked `worn: false` in `profiles.lifter` so Pro rows, the profile and VS stop drawing the lifter over it, sign-out clears the photo, and a stuck photo download gives up after 20 s. No server change. A photo that failed before this build has no owner on record and is not sent: the person picks it again. Both sides need the new build. On the boards a Pro with no made lifter now has the name's lifter out over the ring (it sat in a plain circle); a Pro shown as Free to others means the server has no active row in `subscriptions` (revenuecat-webhook). Green on CI at 7857c59.
- **2026-11-05, late:** the Pro plans wait for the store's sign-in and fall back to Google Play / the App Store (f427d42); photos are kept on the phone and the card shows them at once (12c83c2); match share cards have no heading (00dc5bf); **a push-up on the knees is refused** (8c875fb: the straightest 3D knee reading over the last 0.6 s at the top under 100°; see the pose-detection-rules skill). Builds: **Android 317, iOS 330** at 8c875fb. **Website** (outrepd/outrepd, main 4ebeaab, the user's yes): /u/<name> is served by api/u.js with the lifter's own title and picture (api/og.js, 1200×630, crest.js + resvg), and the page's card shows rating instead of LP.
- **Night of 2026-11-05, last state:** website main 676397c is live (privacy names Unity LevelPlay, no "three free games" in privacy or terms; /u/<name> link previews by api/u.js + api/og.js). App Store 1.1.6: listing + What's New pushed 50/50, screenshots 10 per size present, ITSAppUsesNonExemptEncryption=false; **the user was submitting**: pick build 334, untick Sign-in required, paste docs/store/app-review-reply.md section 3 (also Desktop/mokhtar/OUTREPD-app-review-notes-1.1.6.txt), Submit; expedite form https://developer.apple.com/contact/app-store/?topic=expedite. Play: production release of 319 with the <en-US> notes from Desktop/mokhtar/OUTREPD-google-play-1.1.6.txt (warnings seen: AD_ID from an old closed-testing artifact, 3 devices: both harmless) and the new description to paste in Main store listing. Egypt prices being set by the user: weekly 20 EGP, yearly 100 EGP (App Store from Nov 7, price not preserved). Still open: tito must remake their lifter after updating (a reinstall had uploaded a test account's lifter); store shot 07-home is the old Match tab; RevenueCat restore behaviour unchecked; next: a website redesign after the weekly limit resets (2026-11-09).
- **Release 1.1.6 (2026-11-05, evening):** Play-installed builds show the plans (the sideloaded APKs failed in Google Play Billing: NETWORK_ERROR). Fixed after that: photos show the lifter after 0.5 s; Pro counts the server's word too; Android backup off and the kept lifter tied to its account (a reinstall had put a test account's lifter on tito); uploads cached 60 s at the storage CDN (it ignores ?v). **Android 319** (bea5ac0, AAB on Desktop/mokhtar) and **iOS 334** (9cdefb0). App Store 1.1.6 listing + What's New pushed and verified 50/50 (tool/ci/run_listing.sh). Left to the user: Play production release + description (Desktop/mokhtar/OUTREPD-google-play-1.1.6.txt), App Store: pick 334, submit. Internal testing has 318. Store shot 07-home still the old Match tab.
- **Earlier on 2026-11-03:** rank cards wear their tier (lib/tier_card_frame.dart,
  Match tab and profile); the card a name opens is a player card with a
  Pro look; new share cards (match and profile, story and post, Pro look).
- Store screenshots for 1.1.6 are in Desktop/mokhtar/OUTREPD 1.1.6 store
  screenshots; **07-home must be re-rendered** with the new Match tab
  (scratchpad makeA.js; the chip there was moved to the goal card).

## Server

The live Supabase project is on **1.1.6 + the four covers** since
2026-11-05: the user pasted `Desktop/outrepd-update-1.1.6-covers.sql`
(= `supabase/install.sql` as of 7ebd421) over the 1.1.6 paste of
2026-11-02, and `pg_get_constraintdef` on `profiles_cover_known` showed
all 13 scenes. `tool/db/live/install.sql` is that file.
`tool/db/upgrade_seed.sql` and `upgrade_check.sql` were written for the
1.1.5 → 1.1.6 paste; if the `server` job turns red, rewrite them for the
next upgrade.

The SQL editor's Save may refuse a file this big; Save only keeps the
query's text. Run is what applies it.

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

## After sending 1.1.6 (2026-11-05)

Done: `app-ads.txt` on outrepd.com (AdMob, Unity Ads, ironSource; see
`docs/site-pending/README.md`); ironSource Mobile and Unity Ads in AdMob's
European regulations ad partners; the privacy page names Unity LevelPlay;
the App Store listing and What's New in 50 languages; `store/aso/en.js` no
longer says LP or that a tier is kept.

Still open:

1. Not recorded anywhere: whether the App Store and Play privacy forms
   name Unity. Ask the user.
2. Confirm Play's Main store listing has the new description
   (`Desktop/mokhtar/OUTREPD-google-play-1.1.6.txt`).
3. AdMob had two European regulations messages published for the same two
   apps. The user was told to switch off "Untitled European regulations
   message" (25 Oct, English only) and keep "outrepd European regulations
   message" (29 Oct, 7 languages). Confirm it is off.
4. tito must remake their lifter after updating.
5. Store shot 07-home is still the old Match tab.
6. RevenueCat restore behaviour is unchecked.
7. On a real phone: the photo crop screen and changing the username are
   not recorded as tested.
8. Next: a website redesign once the weekly limit resets (2026-11-09).

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
- `outrepd-update-1.1.6-covers.sql` — the four covers; pasted 2026-11-05, live now.
- `OUTREPD-ui-cleanup/` — the direction B, Ranks and How-points mockups the
  user picked from.
