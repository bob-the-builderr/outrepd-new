#!/usr/bin/env bash
# One public window for a release: push camera-rep-counter (its HEAD commit
# message must say [ios]), wait for the Android run and the iOS run of that
# commit, and, when a listing mode is given, push the App Store listing in
# the same window. Private again whatever happened.
#   bash apps/outrepd_flutter/tool/ci/run_release.sh <sha7 of HEAD> [listing mode] [version]
#   bash apps/outrepd_flutter/tool/ci/run_release.sh 526625f create 1.1.7
GH="/c/Program Files/GitHub CLI/gh.exe"
R=bob-the-builderr/outrepd-new
sha="$1"; MODE="$2"; VERSION="$3"
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
runof() {
  for i in $(seq 1 40); do
    id=$("$GH" run list -R $R --workflow "$1" -L 5 --json databaseId,headSha,event -q ".[] | select(.event==\"push\") | select(.headSha|startswith(\"$sha\")) | .databaseId" | head -1)
    [ -n "$id" ] && { echo "$id"; return 0; }
    sleep 5
  done
}
A=$(runof android-apk.yml); I=$(runof ios.yml)
echo "android run $A, ios run $I"
L=""
if [ -n "$MODE" ]; then
  before=$("$GH" run list -R $R --workflow store-listing.yml -L 1 --json databaseId -q '.[0].databaseId')
  for i in $(seq 1 24); do
    "$GH" workflow run store-listing.yml -R $R --ref camera-rep-counter -f mode="$MODE" -f version="$VERSION" 2>/dev/null && break
    sleep 5
  done
  for i in $(seq 1 30); do
    L=$("$GH" run list -R $R --workflow store-listing.yml -L 1 --json databaseId -q '.[0].databaseId')
    [ -n "$L" ] && [ "$L" != "$before" ] && break
    L=""; sleep 5
  done
  echo "listing run $L"
fi
for id in $A $I $L; do
  while [ "$("$GH" run view $id -R $R --json status -q .status 2>/dev/null)" != "completed" ]; do
    [ "$(vis)" = "PUBLIC" ] || make PUBLIC
    sleep 30
  done
done
for id in $A $I $L; do
  "$GH" run view $id -R $R --json workflowName,conclusion,number,jobs -q '"\(.workflowName) #\(.number) build \(.number + 100): \(.conclusion)", (.jobs[] | "  \(.name) \(.conclusion)")'
done
[ -n "$A" ] && "$GH" run view $A -R $R --log-failed 2>&1 | sed -E 's/^[a-z-]+\t[^\t]+\t[0-9TZ:.-]+ //' | grep -E " • |issues found|\[E\]|Expected:|Actual:|EXCEPTION|Some tests failed" | head -40
[ -n "$I" ] && "$GH" run view $I -R $R --log 2>&1 | sed -E 's/^[a-z]+\t[^\t]+\t[0-9TZ:.-]+ //' | grep -E "^(uploaded|signed|upload note|build) " | grep -v echo | tail -5
