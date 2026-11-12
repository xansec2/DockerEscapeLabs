# Lab 06 — Shared host PID namespace

## Scenario

You're in a container started with `--pid=host`. It shares the **host's process ID
namespace**, so `ps` inside the container lists every process on the host, including PID 1.

Why would anyone do this? Legitimately:

- **APM / monitoring agents** (Datadog, New Relic-style) that want to see and profile host
  processes.
- Debugging/observability sidecars.
- Tools that "need to see the real process tree."

Sharing the PID namespace by itself lets you *see* host processes. Combined with the
capabilities this container has, seeing them turns into entering them.

## Your task

Use the shared PID namespace to break into the host context and read
`/flag-on-host.txt`.

## Success criterion

You print the host's `/flag-on-host.txt` from the container.

## Start / stop

```bash
./start.sh
./stop.sh
```

You start as root in the container, sharing the host PID namespace. Look hard at what
you can reach through other processes' `/proc` entries and namespaces.
