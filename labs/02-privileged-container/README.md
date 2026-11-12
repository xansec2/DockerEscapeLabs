# Lab 02 — The privileged container

## Scenario

You have a shell in a container that was started with `--privileged`. Someone needed it
to "just work" with devices / nested Docker / a monitoring agent, and `--privileged` made
the errors go away.

`--privileged` disables almost every isolation feature at once: it grants all
capabilities, drops seccomp/AppArmor confinement, and — critically — exposes the host's
devices under `/dev`. The container is barely a container anymore.

Real-world parallels:

- **Docker-in-Docker (DinD)** build runners, which are frequently run privileged.
- **Monitoring / node agents** deployed as privileged Kubernetes DaemonSets so they can
  read host metrics.
- Countless cryptojacking incidents where a privileged container was the whole game —
  once you're in, the host is yours.

## Your task

Escape to the host and read `/flag-on-host.txt` (exists only on the host). Bonus: get a
root shell that can see the real host root filesystem.

## Success criterion

You can print the host's `/flag-on-host.txt` token from inside the container.

## Start / stop

```bash
./start.sh
./stop.sh
```

You start as **root inside the container** (as privileged containers usually run).
Enumerate what `--privileged` actually exposed and find your way out.
