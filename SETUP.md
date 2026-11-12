# Setup & Isolation

## Why isolation matters here

Every one of these labs, when solved, gives you **root on the Docker host**. That is the
whole point — you are practicing breaking *out* of the container *onto* the host. So the
"host" must be a machine you are happy to have fully compromised and then throw away.

**Do not run these labs on:**
- your daily workstation,
- your main Omarchy/Arch install,
- a server running anything else you care about,
- any shared or production system.

**Do run them inside a throwaway VM** dedicated to this practice.

## Recommended environment

A disposable Linux VM with Docker installed. Any of:

- **libvirt/KVM** (`virt-manager`) — fits your Arch setup natively.
- **VirtualBox / VMware** — fine too.
- A cheap cloud instance you destroy afterwards (spin up, practice, terminate).

Suggested guest: Ubuntu 22.04/24.04 Server or Debian 12. These give you **cgroup v1
compatibility options** and widely available kernel headers, which matter for labs 05
and 08. A snapshot right after setup lets you roll back after an escape.

### Quick VM provisioning

```bash
# On the guest VM, as a user with sudo:
sudo apt-get update
sudo apt-get install -y docker.io git build-essential
sudo usermod -aG docker "$USER"   # log out / back in so `docker` works without sudo
```

Then copy this folder into the VM (git clone, scp, or a shared folder) and start a lab.

### Take a snapshot

Before your first escape, snapshot the VM. After you pop the host, restore the snapshot
to get a clean slate for the next lab. This is faster than cleaning up and guarantees no
leftover backdoors from one lab bleed into the next.

## Host prerequisites per lab

Most labs work on any modern Docker host. Two have kernel/host dependencies:

| Lab | Requirement | Notes |
|-----|-------------|-------|
| 05 (release_agent) | **cgroup v1** available | Modern distros default to cgroup v2. See the lab README for how to boot with `systemd.unified_cgroup_hierarchy=0`, or use the alternative in SOLUTION.md. |
| 08 (SYS_MODULE) | **Matching kernel headers** in the build image | The lab builds a module against the *container's* headers; it must match the *host* kernel. The README explains how to align them. |

Everything else (socket, privileged, API, host mounts, host PID, DAC_READ, device,
ptrace) works on a stock cgroup-v2 Ubuntu/Debian host.

## Networking note (lab 03)

Lab 03 deliberately exposes the Docker API on `tcp://0.0.0.0:2375`. Keep the VM on a
**host-only / NAT network**, not bridged onto your LAN, so you don't expose an
unauthenticated root-equivalent API to your network while practicing.

## Teardown

Each lab has a `./stop.sh`. To nuke everything the labs created:

```bash
docker ps -aq | xargs -r docker rm -f
docker network prune -f
docker volume prune -f
```

(Run that only on the dedicated VM — it removes *all* containers on that host.)
