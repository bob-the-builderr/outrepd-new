#!/bin/bash
# render.sh <page.html in this folder> <query> <out.png abs> <w> <h>
here="$(cd "$(dirname "$0")" && pwd -W)"
edge="/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
mkdir -p "$here/prof"
timeout 120 "$edge" --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files --force-device-scale-factor=1 --user-data-dir="$here/prof" --disk-cache-size=1 --window-size="$4,$5" --virtual-time-budget=8000 --screenshot="$3" "file:///$here/$1?$2" >/dev/null 2>&1
ls -la "$3" | awk '{print $5}'
