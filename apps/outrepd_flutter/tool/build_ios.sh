#!/bin/bash
# Builds the App Store upload on a Mac. See docs/building.md, "آيفون".
#
#   bash tool/build_ios.sh
#
# Needs Xcode, CocoaPods, Flutter, supabase/keys.env (the same file the
# Windows script uses), and a signing team picked once in Xcode.
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -f supabase/keys.env ]; then
  echo "supabase/keys.env is missing. Copy it from the Windows machine." >&2
  exit 1
fi

git pull --ff-only
flutter pub get
(cd ios && pod install --repo-update)
flutter build ipa --release --no-tree-shake-icons \
  --dart-define-from-file=supabase/keys.env

echo
echo "Done. Opening the archive in Xcode: Distribute App -> App Store Connect."
open build/ios/archive/Runner.xcarchive
