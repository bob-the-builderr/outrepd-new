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

# ML Kit in the shrunk APK: R8 renames it like the rest, and a class it needs
# but only names from native code or by reflection would kill the first match,
# not the launch. So the app is opened again with the extra that has it run
# the pose detector once on a photo it carries (lib/launch_self_test.dart).
adb shell am force-stop "$pkg"
adb logcat -c
adb shell am start -n "$pkg/.MainActivity" --ez outrepd.selftest true > /dev/null 2>&1
line=""
for i in $(seq 1 45); do
  sleep 2
  line=$(adb logcat -d | grep -m1 "OUTREPD-SELFTEST" || true)
  [ -n "$line" ] && break
done
adb logcat -d > launch/selftest.txt
adb exec-out screencap -p > launch/selftest.png
if grep -A1 "FATAL EXCEPTION" launch/selftest.txt | grep -q "Process: $pkg"; then
  echo "::error::The release APK crashed running the pose detector"
  grep -A60 "FATAL EXCEPTION" launch/selftest.txt | head -120
  exit 1
fi
if [ -z "$line" ]; then
  echo "::error::The pose check never answered in 90 s"
  grep -iE "flutter|mlkit|AndroidRuntime" launch/selftest.txt | tail -80
  exit 1
fi
if echo "$line" | grep -q "pose failed"; then
  echo "::error::ML Kit failed in the release APK"
  grep -A40 "OUTREPD-SELFTEST" launch/selftest.txt | head -60
  exit 1
fi
if echo "$line" | grep -q "poses=0"; then
  echo "::warning::ML Kit ran but found nobody in the photo: $line"
fi
echo "ML Kit ran in the release APK: ${line#*OUTREPD-SELFTEST }"
