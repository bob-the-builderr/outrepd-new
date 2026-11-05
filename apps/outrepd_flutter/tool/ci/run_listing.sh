#!/usr/bin/env bash
# Public for one App Store listing run (store-listing.yml), then private
# again whatever happened, and the answer printed from ci-builds.
#   bash apps/outrepd_flutter/tool/ci/run_listing.sh check 1.1.6
#   bash apps/outrepd_flutter/tool/ci/run_listing.sh push 1.1.6
GH="/c/Program Files/GitHub CLI/gh.exe"
R=bob-the-builderr/outrepd-new
MODE="${1:-check}"
VERSION="${2:-}"
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
before=$("$GH" run list -R $R --workflow store-listing.yml -L 1 --json databaseId -q '.[0].databaseId')
ok=""
for i in $(seq 1 24); do
  if "$GH" workflow run store-listing.yml -R $R --ref camera-rep-counter -f mode="$MODE" -f version="$VERSION" 2>/dev/null; then ok=1; break; fi
  sleep 5
done
[ -n "$ok" ] || { echo "dispatch failed"; exit 1; }
id=""
for i in $(seq 1 30); do
  id=$("$GH" run list -R $R --workflow store-listing.yml -L 1 --json databaseId -q '.[0].databaseId')
  [ -n "$id" ] && [ "$id" != "$before" ] && break
  id=""; sleep 5
done
echo "run $id"
[ -n "$id" ] || exit 1
while [ "$("$GH" run view $id -R $R --json status -q .status 2>/dev/null)" != "completed" ]; do
  [ "$(vis)" = "PUBLIC" ] || make PUBLIC
  sleep 15
done
"$GH" run view $id -R $R --json conclusion -q '"conclusion \(.conclusion)"'
git -C "$(dirname "$0")/../../../.." fetch -q origin ci-builds 2>/dev/null
git -C "$(dirname "$0")/../../../.." show origin/ci-builds:asc/listing.txt 2>/dev/null | tail -60
