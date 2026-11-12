#!/usr/bin/env bash
# Public for one server-at-scale run (scale.yml), then private again
# whatever happened, and the answer printed from ci-builds.
#   bash apps/outrepd_flutter/tool/ci/run_scale.sh            # 100000 lifters, 2 cores, 2g
#   bash apps/outrepd_flutter/tool/ci/run_scale.sh 100000 4 8g
# The commit to test must already be pushed (see the push below).
GH="/c/Program Files/GitHub CLI/gh.exe"
R=bob-the-builderr/outrepd-new
LIFTERS="${1:-100000}"
CPUS="${2:-2}"
MEMORY="${3:-2g}"
TOP="$(dirname "$0")/../../../.."
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
git -C "$TOP" push -q origin camera-rep-counter 2>&1 | tail -2
before=$("$GH" run list -R $R --workflow scale.yml -L 1 --json databaseId -q '.[0].databaseId' 2>/dev/null)
ok=""
for i in $(seq 1 24); do
  if "$GH" workflow run scale.yml -R $R --ref camera-rep-counter \
      -f lifters="$LIFTERS" -f cpus="$CPUS" -f memory="$MEMORY" 2>/dev/null; then ok=1; break; fi
  sleep 5
done
[ -n "$ok" ] || { echo "dispatch failed"; exit 1; }
id=""
for i in $(seq 1 30); do
  id=$("$GH" run list -R $R --workflow scale.yml -L 1 --json databaseId -q '.[0].databaseId')
  [ -n "$id" ] && [ "$id" != "$before" ] && break
  id=""; sleep 5
done
echo "run $id"
[ -n "$id" ] || exit 1
while [ "$("$GH" run view $id -R $R --json status -q .status 2>/dev/null)" != "completed" ]; do
  [ "$(vis)" = "PUBLIC" ] || make PUBLIC
  sleep 20
done
"$GH" run view $id -R $R --json conclusion,jobs -q '"conclusion \(.conclusion)", (.jobs[].steps[] | select(.conclusion != "success" and .conclusion != "skipped") | "  step \(.name): \(.conclusion)")'
git -C "$TOP" fetch -q origin ci-builds 2>/dev/null
git -C "$TOP" show "origin/ci-builds:scale/$LIFTERS.txt" 2>/dev/null | head -c 20000
