#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
FLAG="escape09-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo $RANDOM$RANDOM)"
if command -v sudo >/dev/null 2>&1; then
  echo "$FLAG" | sudo tee /flag-on-host.txt >/dev/null; sudo chmod 600 /flag-on-host.txt
  sync; sudo sync
else
  echo "$FLAG" > /flag-on-host.txt; chmod 600 /flag-on-host.txt || true; sync
fi
echo "[*] Host flag planted at /flag-on-host.txt (root-only) and synced to disk."

DEV=$(findmnt -no SOURCE / 2>/dev/null || true)
if [ -z "${DEV:-}" ] || [ ! -b "$DEV" ]; then
  echo "[!] Could not auto-detect a block device for / (got: '${DEV:-none}')."
  echo "    Your root may be on LVM/overlay/btrfs subvol. Inspect with: findmnt / ; lsblk"
  echo "    Then edit start.sh to pass the correct --device, and re-run."
  exit 1
fi
echo "[*] Host root device detected: $DEV  (exposing this to the container)"
docker build -q -t escapelab-09 . >/dev/null
docker rm -f device-box >/dev/null 2>&1 || true
docker run -it --rm --name device-box \
  --device="$DEV" --cap-add=SYS_ADMIN --security-opt apparmor=unconfined \
  -e HOST_DEV="$DEV" \
  escapelab-09 /bin/bash
