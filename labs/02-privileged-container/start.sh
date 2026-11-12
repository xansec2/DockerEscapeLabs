#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
FLAG="escape02-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo $RANDOM$RANDOM)"
echo "$FLAG" | sudo tee /flag-on-host.txt >/dev/null 2>&1 || echo "$FLAG" > /flag-on-host.txt
echo "[*] Host flag planted at /flag-on-host.txt"
docker build -q -t escapelab-02 . >/dev/null
echo "[*] Launching PRIVILEGED container. Dropping you in as root."
docker rm -f priv-box >/dev/null 2>&1 || true
docker run -it --rm --name priv-box --privileged escapelab-02 /bin/bash
