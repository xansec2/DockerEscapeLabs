# Lab 09 — Raw host device exposed

## Scenario

You're in a container that was handed the host's root **block device** via `--device`,
plus enough capability to use it. The intent was a "disk utility" or "backup" container —
something that runs `fsck`, images a disk, or reads partitions.

Once a container can read the raw block device backing the host filesystem, the container
filesystem boundary is irrelevant: the host's files are all right there on the device.

Real-world parallels: backup/imaging containers, storage management tools, anything given
`--device=/dev/sdX` so it can "see the disk."

## Your task

The host's `/flag-on-host.txt` is **root-only** and not in the container image. Recover
its contents through the exposed raw device.

## Success criterion

You print the host flag token, obtained via the block device the container was given.

## Start / stop

```bash
./start.sh     # detects the host root device and passes it through
./stop.sh
```

`start.sh` prints which host device it exposed. Work out how to turn raw device access
into reading a specific host file.
