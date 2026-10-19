#!/usr/bin/env bash
# Puts a job's report on the promo-results branch, which a `git fetch` reads
# without signing in to GitHub: <sha7>/ for this commit, latest/ for the
# newest. Both jobs write here, so a push that loses the race is retried.
#
#   bash ci/publish_results.sh <folder of files>

set -u
from="$1"
git config user.name "ci"
git config user.email "ci@users.noreply.github.com"
work="$RUNNER_TEMP/promo-results"
for attempt in 1 2 3 4 5; do
  rm -rf "$work"
  git worktree prune
  if git fetch --depth 1 origin promo-results 2>/dev/null; then
    git worktree add -f "$work" FETCH_HEAD
    git -C "$work" checkout -B promo-results
  else
    git worktree add -f --detach "$work"
    git -C "$work" checkout --orphan promo-results
    git -C "$work" rm -rf -q . || true
  fi
  mkdir -p "$work/${GITHUB_SHA::7}" "$work/latest"
  cp "$from"/* "$work/${GITHUB_SHA::7}/"
  cp "$from"/* "$work/latest/"
  git -C "$work" add -A
  git -C "$work" commit -q -m "Promo results ${GITHUB_SHA::7}" || true
  if git -C "$work" push -q origin promo-results; then break; fi
  git worktree remove -f "$work" || true
  sleep $((attempt * 5))
done
