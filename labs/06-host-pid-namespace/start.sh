#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
FLAG="escape06-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo $RANDOM$RANDOM)"
echo "$FLAG" | sudo tee /flag-on-host.txt >/dev/null 2>&1 || echo "$FLAG" > /flag-on-host.txt
echo "[*] Host flag planted at /flag-on-host.txt"
docker build -q -t escapelab-06 . >/dev/null
echo "[*] Launching container with --pid=host (and SYS_ADMIN/SYS_PTRACE to make the"
echo "    namespace-entry path reachable, as a real monitoring agent often has)."
docker rm -f pidhost-box >/dev/null 2>&1 || true
docker run -it --rm --name pidhost-box \
  --pid=host --cap-add=SYS_ADMIN --cap-add=SYS_PTRACE --security-opt apparmor=unconfined \
  escapelab-06 /bin/bash
