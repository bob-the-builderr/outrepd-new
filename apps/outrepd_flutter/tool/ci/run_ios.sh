#!/usr/bin/env bash
# Public for one dispatched iOS build of camera-rep-counter, then private
# again whatever happened. bash apps/outrepd_flutter/tool/ci/run_ios.sh
GH="/c/Program Files/GitHub CLI/gh.exe"
R=bob-the-builderr/outrepd-new
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
before=$("$GH" run list -R $R --workflow ios.yml -L 1 --json databaseId -q '.[0].databaseId')
ok=""
for i in $(seq 1 24); do
  if "$GH" workflow run ios.yml -R $R --ref camera-rep-counter 2>/dev/null; then ok=1; break; fi
  sleep 5
done
[ -n "$ok" ] || { echo "dispatch failed"; exit 1; }
id=""
for i in $(seq 1 30); do
  id=$("$GH" run list -R $R --workflow ios.yml -L 1 --json databaseId,event -q '.[0] | select(.event=="workflow_dispatch") | .databaseId')
  [ -n "$id" ] && [ "$id" != "$before" ] && break
  id=""; sleep 5
done
echo "run $id"
[ -n "$id" ] || exit 1
while [ "$("$GH" run view $id -R $R --json status -q .status)" != "completed" ]; do
  [ "$(vis)" = "PUBLIC" ] || make PUBLIC
  sleep 30
done
"$GH" run view $id -R $R --json conclusion,number,headSha -q '"conclusion \(.conclusion) #\(.number) build \(.number + 100) at \(.headSha[:7])"'
"$GH" run view $id -R $R --log 2>&1 | sed -E 's/^[a-z]+\t[^\t]+\t[0-9TZ:.-]+ //' | grep -E "^(uploaded|signed|upload note|build) " | grep -v echo | tail -5
