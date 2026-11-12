# Lab 08 — CAP_SYS_MODULE (loading kernel modules)

## Scenario

You're in a container granted `CAP_SYS_MODULE`. This capability lets a process load and
unload **kernel modules**. A kernel module runs in ring 0 on the host — there is no
container boundary left once your code is in the kernel.

Real-world parallels: networking / firewall / VPN sidecars that want to load `iptables`
or tunnel modules, and "just add SYS_MODULE so modprobe works" fixes.

## ⚠️ This is the advanced, kernel-dependent lab

A kernel module must be compiled against headers that **match the running host kernel**.
That's the main friction. `start.sh` mounts the host's `/lib/modules` and `/usr/src`
read-only into the container so you can build against the real kernel. For that to work:

```bash
# on the host VM, install headers for the CURRENT kernel:
sudo apt-get install -y linux-headers-$(uname -r) build-essential
```

If `/lib/modules/$(uname -r)/build` doesn't exist on the host, module builds won't link.
Prefer a mainstream Ubuntu/Debian kernel here rather than a bleeding-edge custom one.

## Your task

Load a kernel module that causes the **host** to execute your code as root. Demonstrate
it by having the host reveal `/flag-on-host.txt` (root-only) somewhere you can read it,
or by any unambiguous host-root action you can prove.

## Success criterion

Evidence of root code execution on the host triggered from inside the container
(e.g. the root-only flag ends up in a world-readable path on the host, created by your
module).

## Build tools

The image ships `build-essential` and the kernel build tree is mounted from the host.
Writing the module and its Makefile — and choosing how a module triggers userspace — is
the challenge.

## Start / stop

```bash
./start.sh
./stop.sh
```
