# Lab 04 — The host filesystem bind mount

## Scenario

You're in a container called `backup-agent`. Its job is to back up the host, so it was
given a bind mount of the host's root filesystem — writable — at `/host`.

Variations of this are everywhere:

- **Backup / snapshot agents** mounting `/` or large host paths.
- **Log shippers** and monitoring exporters mounting `/etc`, `/var/log`, or `/`.
- "Just mount the whole host so the tool can see everything" shortcuts.
- A mount of `/etc` alone is already game over — think about what writable `/etc` buys you.

A writable host mount means the container can modify files the host trusts. That's a
direct line to host code execution.

## Your task

Two parts:

1. **Read:** print the host's `/flag-on-host.txt`.
2. **Escalate:** use the writable mount to arrange code execution as **root on the host**
   (there are several classic ways — pick one and demonstrate it).

## Success criterion

You read the flag, and you can show a mechanism that would run your code as host root
(e.g. something you dropped on the host executes, or you can authenticate to the host as
root). Keep whatever you do inside this disposable VM.

## Start / stop

```bash
./start.sh
./stop.sh
```

You start as root in the container, with `/host` mounted read-write.
