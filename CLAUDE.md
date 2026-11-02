# OUTREPD — read this first

OUTREPD is a push-up duel app: Flutter in `apps/outrepd_flutter`, Supabase
behind it, the website in the separate repo `outrepd/outrepd` (Vercel).
Where things stand right now, and what is left: **`docs/HANDOFF.md`**.
Claude's memory on this laptop
(`~/.claude/projects/C--Users-MA-Desktop-anything/memory/`) holds the longer
history and the user's picks.

Talk to the user in Egyptian Arabic, questions and their options included.

## How this machine works

- **No Flutter, no Postgres, no Python here.** Dart is edited by hand;
  analyze, tests, screenshots, the server test and the builds all run on
  GitHub Actions.
- **The repo `bob-the-builderr/outrepd-new` is private, and Actions only run
  while it is public** (billing). `bash apps/outrepd_flutter/tool/ci/run_android.sh <sha7>`
  makes it public, pushes `camera-rep-counter`, waits for the run, prints
  the failures and makes it private again whatever happened. Run it in the
  background; a run takes about 20 minutes. iOS builds only with `[ios]` in
  the commit message, or `tool/ci/run_ios.sh` (dispatch). The user has
  allowed the public/private flip for CI.
- **Results** land on the `ci-results` branch:
  `git fetch origin ci-results`, then
  `git show origin/ci-results:latest/summary.txt` (also `analyze.txt`,
  `test.txt`, `server.txt`, `screens/<name>.png`). Builds: `ci-builds`.
- `gh` is at `/c/Program Files/GitHub CLI/gh.exe`, logged in.
- **Server:** edit `apps/outrepd_flutter/supabase/*.sql`, then rebuild
  `supabase/install.sql` with `node tool/build_install.js` (run from
  `apps/outrepd_flutter`; byte-for-byte what `tool/build_install.py`
  writes). Add checks to `tool/db/security_test.sql`. The live project only
  changes when the user pastes a file into the Supabase SQL editor: copy
  `install.sql` to `Desktop/outrepd-update-<version>.sql` for them.
  `tool/db/live/install.sql` is what is live now; CI rehearses every paste
  over it (`tool/db/upgrade_seed.sql`, `upgrade_check.sql`). After the user
  pastes, replace it with the pasted file.
- Rank ladder test vectors: `node tool/ladder_vectors.js`.
- **Strings:** 13 languages. A new key goes into every `lib/l10n/app_*.arb`
  and, by hand, into `lib/l10n/app_localizations.dart` and every
  `app_localizations_<code>.dart` (no `flutter gen-l10n` here).
- Code with `$` or backticks: write a node script to a file and run it;
  inline shell mangles them.
- **Mockups:** HTML at real phone size (412×915) beside the built CI
  screenshot, rendered with headless Chrome:
  `"/c/Program Files/Google/Chrome/Application/chrome.exe" --headless=new --disable-gpu --hide-scrollbars --user-data-dir=<dir> --force-device-scale-factor=1 --virtual-time-budget=6000 --window-size=1000,1130 --screenshot=out.png file:///<page>.html`.
  A file URL drops `?query` and `#hash`, so make one page per option.
  Examples in `design/mockups/2026-11-02`. Previews:
  `tool/dev/serve-site.js`, `tool/dev/serve-mock.js`.

## The user's standing rules

- Any visual change: a mockup and the user's pick before writing code.
  Everything else: work to the end without asking.
- Commit locally. No store builds until the user says the batch is done.
- Never touch the bottom tab bar (`lib/app_bottom_nav.dart`) or its
  colours.
- Website pushes, GitHub secrets, store or console changes: an explicit yes
  each time. Never create accounts.
- Store and website copy must match what the code in `lib/` does.
