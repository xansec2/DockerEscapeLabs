#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
FLAG="escape10-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo $RANDOM$RANDOM)"
if command -v sudo >/dev/null 2>&1; then
  echo "$FLAG" | sudo tee /flag-on-host.txt >/dev/null; sudo chmod 600 /flag-on-host.txt
else
  echo "$FLAG" > /flag-on-host.txt; chmod 600 /flag-on-host.txt || true
fi
echo "[*] Host flag planted at /flag-on-host.txt (root-only)"
docker build -q -t escapelab-10 . >/dev/null
echo "[*] Launching profiler container: --pid=host + CAP_SYS_PTRACE."
echo "    (YAMA ptrace_scope on the host can block cross-process ptrace; if attaches are"
echo "     denied, check: sysctl kernel.yama.ptrace_scope)"
docker rm -f ptrace-box >/dev/null 2>&1 || true
docker run -it --rm --name ptrace-box \
  --pid=host --cap-add=SYS_PTRACE --security-opt apparmor=unconfined --security-opt seccomp=unconfined \
  escapelab-10 /bin/bash
