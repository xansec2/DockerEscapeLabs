#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
FLAG="escape07-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo $RANDOM$RANDOM)"
# root-only readable on the host
if command -v sudo >/dev/null 2>&1; then
  echo "$FLAG" | sudo tee /flag-on-host.txt >/dev/null
  sudo chmod 600 /flag-on-host.txt; sudo chown root:root /flag-on-host.txt
else
  echo "$FLAG" > /flag-on-host.txt; chmod 600 /flag-on-host.txt || true
fi
echo "[*] Host flag planted at /flag-on-host.txt (root-only, mode 600)"
docker build -q -t escapelab-07 . >/dev/null
echo "[*] Launching container with ONLY CAP_DAC_READ_SEARCH added."
docker rm -f dacread-box >/dev/null 2>&1 || true
docker run -it --rm --name dacread-box \
  --cap-add=DAC_READ_SEARCH --security-opt apparmor=unconfined \
  escapelab-07 /bin/bash
