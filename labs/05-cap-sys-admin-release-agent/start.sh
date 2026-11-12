#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
FLAG="escape05-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo $RANDOM$RANDOM)"
echo "$FLAG" | sudo tee /flag-on-host.txt >/dev/null 2>&1 || echo "$FLAG" > /flag-on-host.txt
echo "[*] Host flag planted at /flag-on-host.txt"
CGTYPE=$(stat -fc %T /sys/fs/cgroup 2>/dev/null || echo unknown)
if [ "$CGTYPE" = "cgroup2fs" ]; then
  echo "[!] WARNING: host is pure cgroup v2 ($CGTYPE). The classic release_agent trick"
  echo "    will not work as-is. See README for booting with cgroup v1."
fi
docker build -q -t escapelab-05 . >/dev/null
echo "[*] Launching container with CAP_SYS_ADMIN and AppArmor unconfined."
docker rm -f sysadmin-box >/dev/null 2>&1 || true
docker run -it --rm --name sysadmin-box \
  --cap-add=SYS_ADMIN --security-opt apparmor=unconfined \
  escapelab-05 /bin/bash
