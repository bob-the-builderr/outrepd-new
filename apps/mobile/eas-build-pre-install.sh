#!/usr/bin/env bash
echo "=== EAS pre-install diagnostics ==="
echo "PWD: $(pwd)"
echo "--- files in build dir ---"
ls -la
echo "--- lockfile present? ---"
if [ -f package-lock.json ]; then
  echo "package-lock.json EXISTS (size: $(wc -c < package-lock.json) bytes)"
  echo "removing it so npm install runs instead of npm ci"
  rm -f package-lock.json
  echo "removed. still present? $([ -f package-lock.json ] && echo yes || echo no)"
else
  echo "package-lock.json NOT present"
fi
echo "=== end diagnostics ==="
