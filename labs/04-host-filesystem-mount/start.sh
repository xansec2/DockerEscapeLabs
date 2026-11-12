#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
FLAG="escape04-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo $RANDOM$RANDOM)"
echo "$FLAG" | sudo tee /flag-on-host.txt >/dev/null 2>&1 || echo "$FLAG" > /flag-on-host.txt
echo "[*] Host flag planted at /flag-on-host.txt"
docker build -q -t escapelab-04 . >/dev/null
echo "[*] Launching backup-agent with host root bind-mounted writable at /host."
docker rm -f backup-agent >/dev/null 2>&1 || true
docker run -it --rm --name backup-agent -v /:/host:rw escapelab-04 /bin/bash
