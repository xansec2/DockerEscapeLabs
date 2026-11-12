#!/usr/bin/env bash
set -euo pipefail
docker rm -f backup-agent >/dev/null 2>&1 || true
sudo rm -f /flag-on-host.txt 2>/dev/null || rm -f /flag-on-host.txt 2>/dev/null || true
echo "[*] Lab 04 stopped. (If you planted anything on the host during the lab, clean it up or restore your VM snapshot.)"
