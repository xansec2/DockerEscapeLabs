#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
echo "[*] Building & starting the lab (victim daemon + attacker box)..."
docker compose up -d --build
echo "[*] Planting the flag inside the vulnerable-daemon (your target 'host')..."
FLAG="escape03-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo $RANDOM$RANDOM)"
# wait for dind to be ready, then write the flag into its filesystem
for i in $(seq 1 30); do
  if docker compose exec -T vulnerable-daemon sh -c 'echo ok' >/dev/null 2>&1; then break; fi
  sleep 1
done
docker compose exec -T vulnerable-daemon sh -c "echo '$FLAG' > /flag-on-host.txt"
echo "[*] Target is up. The exposed API is at tcp://vulnerable-daemon:2375"
echo "[*] Dropping you into the attacker box."
docker compose exec attacker /bin/bash
