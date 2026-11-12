#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

FLAG="escape01-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo $RANDOM$RANDOM)"
# Plant the flag on the HOST (outside the container's own image).
echo "$FLAG" | sudo tee /flag-on-host.txt >/dev/null 2>&1 || echo "$FLAG" > /flag-on-host.txt
echo "[*] Host flag planted at /flag-on-host.txt"

echo "[*] Building image..."
docker build -q -t escapelab-01 . >/dev/null

echo "[*] Launching ci-runner with the Docker socket mounted (the misconfiguration)."
echo "[*] You'll drop in as the unprivileged 'builder' user."
docker rm -f ci-runner >/dev/null 2>&1 || true
docker run -it --rm --name ci-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u builder \
  escapelab-01 /bin/bash
