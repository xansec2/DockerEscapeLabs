#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
FLAG="escape08-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo $RANDOM$RANDOM)"
if command -v sudo >/dev/null 2>&1; then
  echo "$FLAG" | sudo tee /flag-on-host.txt >/dev/null; sudo chmod 600 /flag-on-host.txt
else
  echo "$FLAG" > /flag-on-host.txt; chmod 600 /flag-on-host.txt || true
fi
echo "[*] Host flag planted at /flag-on-host.txt (root-only)"
if [ ! -d "/lib/modules/$(uname -r)/build" ]; then
  echo "[!] /lib/modules/$(uname -r)/build missing on host. Install linux-headers-$(uname -r)"
  echo "    and build-essential first, or module builds will fail. (See README.)"
fi
docker build -q -t escapelab-08 . >/dev/null
echo "[*] Launching container with CAP_SYS_MODULE and the host kernel tree mounted RO."
docker rm -f sysmodule-box >/dev/null 2>&1 || true
docker run -it --rm --name sysmodule-box \
  --cap-add=SYS_MODULE \
  -v /lib/modules:/lib/modules:ro -v /usr/src:/usr/src:ro \
  escapelab-08 /bin/bash
