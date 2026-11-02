#!/usr/bin/env bash
# Public for the app's Android run (analyze, tests, APK), then private again
# whatever happened.
#   bash apps/outrepd_flutter/tool/ci/run_android.sh <sha7 of HEAD>
GH="/c/Program Files/GitHub CLI/gh.exe"
R=bob-the-builderr/outrepd-new
sha="$1"
vis() { "$GH" repo view $R --json visibility -q .visibility 2>/dev/null; }
make() {
  for i in $(seq 1 60); do
    [ "$(vis)" = "$1" ] && return 0
    "$GH" repo edit $R --visibility "$(echo "$1" | tr A-Z a-z)" --accept-visibility-change-consequences 2>/dev/null
    sleep 5
  done
  return 1
}
trap 'make PRIVATE; echo "visibility: $(vis)"' EXIT
make PUBLIC || { echo "could not make public"; exit 1; }
pushed=""
for i in $(seq 1 36); do
  if git -C /c/Users/MA/Desktop/anything push -q origin camera-rep-counter 2>/dev/null; then pushed=1; break; fi
  sleep 5
done
[ -n "$pushed" ] || { echo "push failed"; exit 1; }
echo "pushed"
id=""
for i in $(seq 1 30); do
  id=$("$GH" run list -R $R --workflow android-apk.yml -L 3 --json databaseId,headSha -q ".[] | select(.headSha|startswith(\"$sha\")) | .databaseId" | head -1)
  [ -n "$id" ] && break
  sleep 5
done
echo "run $id"
[ -n "$id" ] || exit 1
while [ "$("$GH" run view $id -R $R --json status -q .status)" != "completed" ]; do
  [ "$(vis)" = "PUBLIC" ] || make PUBLIC
  sleep 30
done
"$GH" run view $id -R $R --json conclusion,number,jobs -q '"conclusion \(.conclusion) #\(.number)", (.jobs[] | "  \(.name) \(.conclusion)")'
"$GH" run view $id -R $R --log-failed 2>&1 | sed -E 's/^[a-z-]+\t[^\t]+\t[0-9TZ:.-]+ //' | grep -E " • |issues found|No issues|\[E\]|Expected:|Actual:|Which:|EXCEPTION|══|Some tests failed|All tests passed" | head -60
