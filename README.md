# Docker Escape Labs

A set of **10 intentionally vulnerable Docker environments** for practicing container
breakout techniques — the kind you hit in CPTC, OSCP-style exams, and real engagements.

Each lab reproduces a *real-world misconfiguration*, ties it to a documented incident,
and gives you a task. **No solution walkthroughs** — you figure out the escape. Each lab
has a recon checklist and optional progressive hints (hidden behind spoilers) if you get
stuck, plus a success criterion so you know when you've actually popped the host.

> ⚠️ **These labs intentionally break container isolation. A successful escape gives
> you root on the HOST. Run them only inside a disposable VM you own.** See
> [`SETUP.md`](SETUP.md) before you start. Do **not** run these on your workstation,
> a shared box, or anything you care about.

This is defensive/educational material: understanding *how* these misconfigurations
lead to escapes is exactly what lets you find them on an engagement and remediate them.

## The labs

| # | Lab | What's misconfigured | Real-world parallel |
|---|-----|----------------------|---------------------|
| 01 | [Docker socket mount](labs/01-docker-socket) | `/var/run/docker.sock` exposed in container | Jenkins/GitLab CI runners, Portainer, Watchtower |
| 02 | [Privileged container](labs/02-privileged-container) | `--privileged` | Docker-in-Docker builders, monitoring DaemonSets |
| 03 | [Exposed Docker API](labs/03-exposed-docker-api) | Unauthenticated daemon on `tcp://0.0.0.0:2375` | TeamTNT / Kinsing / Doki cryptojacking campaigns |
| 04 | [Host filesystem mount](labs/04-host-filesystem-mount) | `-v /:/host` (writable bind mount) | Backup agents, log shippers, node-exporter configs |
| 05 | [CAP_SYS_ADMIN release_agent](labs/05-cap-sys-admin-release-agent) | extra capability on the container | Build containers, CI with extra caps |
| 06 | [Host PID namespace](labs/06-host-pid-namespace) | `--pid=host` | APM/monitoring agents (Datadog-style) |
| 07 | [CAP_DAC_READ_SEARCH](labs/07-cap-dac-read-search) | over-broad capability grant | Minimal-looking cap additions |
| 08 | [CAP_SYS_MODULE](labs/08-cap-sys-module) | capability to touch the kernel | Networking / firewall sidecars |
| 09 | [Host device mount](labs/09-host-device-mount) | `--device=/dev/sdX` raw disk access | Disk/backup utility containers |
| 10 | [CAP_SYS_PTRACE + host PID](labs/10-cap-sys-ptrace) | debug capability + shared PID ns | Debugger / profiler containers |

The lab names hint at the *class* of misconfiguration (so you know what you're
practicing), but working out the actual exploitation path is on you.

## How to use a lab

```bash
cd labs/01-docker-socket
cat README.md        # scenario + your task + success criterion
./start.sh           # build and launch the vulnerable container, drop you a shell
# ... enumerate, then attempt the escape ...
./stop.sh            # tear it down when you're done
```

Each lab is independent. Work them in any order, though 01-04 are the most common and
the best place to start.

## Difficulty

- **Beginner:** 01, 02, 03, 04, 06, 09
- **Intermediate:** 05, 07, 10
- **Advanced (kernel-dependent):** 08

## General recon

Before reaching for hints, the same enumeration applies to almost every lab. Learn to
run it from memory:

```bash
id; cat /proc/self/status | grep -i cap     # what capabilities do I hold?
capsh --print 2>/dev/null                   # decode them (if capsh is present)
mount; cat /proc/mounts                      # what's mounted from the host?
ls -la /var/run/docker.sock 2>/dev/null     # is the daemon socket here?
env; cat /proc/1/cgroup                      # context clues
ls -la /dev                                  # host devices exposed?
ps aux                                       # can I see host processes? (shared PID ns)
```

A good habit from CPTC: write down *every* deviation from a locked-down container, then
ask "what does this one thing let me reach?" Each lab is built around exactly one such
deviation.
