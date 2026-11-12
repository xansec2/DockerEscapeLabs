#!/usr/bin/env bash
set -euo pipefail
docker rm -f sysmodule-box >/dev/null 2>&1 || true
sudo rm -f /flag-on-host.txt 2>/dev/null || rm -f /flag-on-host.txt 2>/dev/null || true
echo "[*] Lab 08 stopped. If you loaded a module, confirm it's unloaded or restore your snapshot."
