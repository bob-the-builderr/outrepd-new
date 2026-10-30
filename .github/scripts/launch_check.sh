#!/usr/bin/env bash
# Installs the release APK on the running emulator, opens it and fails if it
# crashes, or is not running, 30 seconds later. The R8 shrinker can remove a
# class that is only looked up by name, and the app then dies before its first
# frame: no Dart test can see that, only opening the real APK can.
# Leaves the log and a screenshot in launch/.
#   bash launch_check.sh <apk>
set -u
apk="$1"
pkg=com.outrepd.outrepd
mkdir -p launch
if ! adb install -r "$apk" > launch/install.txt 2>&1; then
  cat launch/install.txt
  echo "::error::The release APK would not install"
  exit 1
fi
adb logcat -c
adb shell monkey -p "$pkg" -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1
sleep 30
adb logcat -d > launch/logcat.txt
adb exec-out screencap -p > launch/screen.png
pid=$(adb shell pidof "$pkg" | tr -d '\r')
# Only this app's own crashes: the emulator's system apps crash on their own.
if grep -A1 "FATAL EXCEPTION" launch/logcat.txt | grep -q "Process: $pkg"; then
  echo "::error::The release APK crashed on launch"
  grep -A60 "FATAL EXCEPTION" launch/logcat.txt | head -120
  exit 1
fi
if [ -z "$pid" ]; then
  echo "::error::The app is not running 30 s after it was opened"
  grep -i "$pkg\|AndroidRuntime" launch/logcat.txt | tail -80
  exit 1
fi
echo "Opened, still running as pid $pid 30 s later, no crash."
