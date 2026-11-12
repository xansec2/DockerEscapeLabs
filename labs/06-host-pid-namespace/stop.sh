#!/usr/bin/env bash
set -euo pipefail
docker rm -f pidhost-box >/dev/null 2>&1 || true
sudo rm -f /flag-on-host.txt 2>/dev/null || rm -f /flag-on-host.txt 2>/dev/null || true
echo "[*] Lab 06 stopped."
