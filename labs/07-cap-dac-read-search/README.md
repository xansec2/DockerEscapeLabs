# Lab 07 — CAP_DAC_READ_SEARCH (the "Shocker" class)

## Scenario

You're in a container that looks locked down — not privileged, runs as a normal user for
most things — but it was granted `CAP_DAC_READ_SEARCH`. That capability bypasses file
*read* permission checks. On its own it sounds mild ("it can only read files"), which is
exactly why it gets added without much thought.

The catch: `CAP_DAC_READ_SEARCH` also unlocks `open_by_handle_at(2)`. With it you can
brute-force **file handles outside the container's mount namespace** and read arbitrary
files on the **host filesystem** — including `/etc/shadow`. This is the capability behind
the original **"Shocker"** proof-of-concept by Sebastian Krahmer.

Real-world parallels: over-broad capability sets copied from a blog post, or a tool that
genuinely needs to traverse/read files and gets handed a too-powerful cap.

## Your task

Read the host-only file `/flag-on-host.txt` (it is **root-readable only**, mode 600,
and does not exist inside the container image). Reading it proves you broke out of the
mount namespace.

## Success criterion

You print the contents of the host's `/flag-on-host.txt`.

## Build tools

The image ships `gcc` — you will likely need to write and compile a small C program.
Figuring out how `open_by_handle_at` is driven is the challenge.

## Start / stop

```bash
./start.sh
./stop.sh
```
