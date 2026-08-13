#!/usr/bin/env bash
#
# Builds a test APK locally and drops it on the Desktop.
#
#   bash apps/mobile/build-apk.sh
#
# The first build compiles all the native C++ and takes a while; after that
# Gradle only rebuilds what changed, so JS-only edits land in a couple of
# minutes. If you add a dependency with native code, re-run
# `npx expo prebuild --platform android` first so the android/ project picks
# it up.
set -euo pipefail

export JAVA_HOME="/c/Users/MA/jdk17/jdk-17.0.20+8"
export ANDROID_HOME="/c/Android/Sdk"
export ANDROID_SDK_ROOT="/c/Android/Sdk"
export PATH="$JAVA_HOME/bin:$PATH"

# Enables the tester shortcuts (skip sign-in, skip paywall). Drop this line to
# build a normal, fully gated app.
export EXPO_PUBLIC_TEST_MODE=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/Desktop/OUTREPD-test.apk"
START=$SECONDS

cd "$SCRIPT_DIR/android"
./gradlew assembleRelease

cp "$SCRIPT_DIR/android/app/build/outputs/apk/release/app-release.apk" "$DEST"

echo
echo "APK ready: $DEST"
echo "Built in $(( (SECONDS - START) / 60 ))m $(( (SECONDS - START) % 60 ))s"
