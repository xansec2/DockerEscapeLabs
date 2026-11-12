# Lab 05 — CAP_SYS_ADMIN and the cgroup release_agent

## Scenario

You're in a container that is **not** `--privileged`, but was started with
`--cap-add=SYS_ADMIN` and with its confinement relaxed (`--security-opt
apparmor=unconfined`). Someone added "just one capability" to make a build or
filesystem-manipulation tool work.

`CAP_SYS_ADMIN` is the "new root" — an enormous grab-bag of privileged operations,
including mounting filesystems. One classic abuse is the **cgroup v1 `release_agent`**
technique (popularised by Felix Wilhelm): you mount a cgroup controller, set a
`release_agent` that points at a script on a filesystem the host can see, and trigger it
so the **host kernel** executes your script as root.

Real-world parallels: build containers and CI jobs that get handed extra capabilities,
and container runtimes/tools that request `SYS_ADMIN` for convenience.

## ⚠️ Host requirement: cgroup v1

The classic `release_agent` path needs a **cgroup v1** hierarchy. Modern distros
(including a fresh Ubuntu/Debian) default to **cgroup v2**, where this specific trick
doesn't work as-is. To practice the canonical technique, boot your lab VM with cgroup v1:

Add to the kernel cmdline (e.g. in `/etc/default/grub`, `GRUB_CMDLINE_LINUX`):

```
systemd.unified_cgroup_hierarchy=0
```

then `sudo update-grub && sudo reboot`. Confirm with:

```bash
stat -fc %T /sys/fs/cgroup    # "tmpfs" => v1 available; "cgroup2fs" => pure v2
```

`start.sh` warns you if it detects pure cgroup v2. (On v2, the equivalent escape uses a
different primitive — a worthwhile second challenge once you've done the v1 version.)

## Your task

Use `CAP_SYS_ADMIN` to run code as **root on the host** and read `/flag-on-host.txt`.

## Success criterion

The host's `/flag-on-host.txt` contents end up somewhere you can read them from the
container (e.g. your host-run script copies the flag out).

## Start / stop

```bash
./start.sh
./stop.sh
```
