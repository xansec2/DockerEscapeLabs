#!/usr/bin/env bash
# Top-level helper: safety check + lab index.
set -euo pipefail

cat <<'BANNER'
============================================================
 Docker Escape Labs
 These labs break container isolation. A solved lab = root
 on THIS host. Run only inside a disposable VM you own.
============================================================
BANNER

if ! command -v docker >/dev/null 2>&1; then
  echo "[!] docker not found. Install it first (see SETUP.md)." >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "[!] cannot talk to the Docker daemon. Is it running? Are you in the docker group?" >&2
  exit 1
fi

echo "[*] Docker looks healthy. Available labs:"
echo
for d in labs/*/; do
  name=$(basename "$d")
  desc=$(sed -n 's/^# //p' "$d/README.md" | head -1)
  printf "  %-34s %s\n" "$name" "$desc"
done
echo
echo "Start one with:  cd labs/<name> && cat README.md && ./start.sh"
