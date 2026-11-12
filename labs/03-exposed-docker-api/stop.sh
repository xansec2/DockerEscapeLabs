#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
docker compose down -v >/dev/null 2>&1 || true
echo "[*] Lab 03 stopped."
