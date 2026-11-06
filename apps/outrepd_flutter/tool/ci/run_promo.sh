#!/usr/bin/env bash
# Public for one promo CI run, then private again whatever happened.
#   bash apps/outrepd_flutter/tool/ci/run_promo.sh <sha7>  (the promo copy in Desktop/mokhtar/OUTREPD-promo)
# A visibility change takes a while on GitHub: until it lands, git answers
# "repository is disabled" and a second change is refused (422), so both
# are retried.
GH="/c/Program Files/GitHub CLI/gh.exe"
R=bob-the-builderr/outrepd-new
sha="$1"
private() {
  for i in $(seq 1 60); do
    "$GH" repo edit $R --visibility private --accept-visibility-change-consequences 2>/dev/null && break
    sleep 5
  done
  echo "visibility: $("$GH" repo view $R --json visibility -q .visibility)"
}
trap private EXIT
"$GH" repo edit $R --visibility public --accept-visibility-change-consequences || exit 1
pushed=""
for i in $(seq 1 36); do
  if git -C /c/Users/MA/Desktop/mokhtar/OUTREPD-promo push -q origin promo 2>/dev/null; then pushed=1; break; fi
  sleep 5
done
[ -n "$pushed" ] || { echo "push failed"; exit 1; }
echo "pushed"
id=""
for i in $(seq 1 30); do
  id=$("$GH" run list -R $R --branch promo -L 3 --json databaseId,headSha -q ".[] | select(.headSha|startswith(\"$sha\")) | .databaseId" | head -1)
  [ -n "$id" ] && break
  sleep 5
done
echo "run $id"
[ -n "$id" ] || exit 1
"$GH" run watch "$id" -R $R --exit-status --interval 20 > /dev/null 2>&1
echo "exit $?"
"$GH" run view "$id" -R $R --log-failed 2>&1 | sed -E 's/^[a-z]+\t[A-Za-z]+\t[0-9TZ:.-]+ //' | grep -E " • |issues found|No issues|^[0-9:]+ \+[0-9]+.*(\[E\]|-[0-9]+:)|Expected:|Actual:|Which:|EXCEPTION|══|Some tests failed|All tests passed" | head -80
