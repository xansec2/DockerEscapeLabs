# Lab 03 — The exposed Docker API

## Scenario

While sweeping a subnet you find a host with **TCP port 2375 open**. That's the Docker
Engine API, running **without TLS and without authentication**. The daemon behind it runs
as root. An exposed 2375 is a full root-equivalent remote API — no credentials required.

This is not theoretical. It's one of the most heavily exploited misconfigurations on the
internet:

- **TeamTNT**, **Kinsing**, **Doki**, and **Graboid** are all documented malware families
  whose core spreading method was scanning for `2375/tcp` and deploying cryptominers (or
  worse) through the open API.
- Cloud instances get popped within minutes of exposing 2375 to the internet.

This lab is **fully self-contained**: it does *not* expose your real host's Docker
daemon. It stands up a throwaway "victim" daemon (the thing you attack) and an "attacker"
box on an internal network. The victim daemon's own container filesystem plays the role
of the host you're breaking into.

## Topology

```
  [ attacker ] ---- internal network ----> [ vulnerable-daemon :2375 ]  <-- the "host"
   docker CLI,                              dockerd with --host tcp://0.0.0.0:2375
   curl, nmap                               /flag-on-host.txt lives in here
```

## Your task

From the `attacker` container, reach the exposed API on `vulnerable-daemon:2375` and use
it to read `/flag-on-host.txt`, which lives on the **vulnerable-daemon** (your target
"host"), not on the attacker box.

## Success criterion

You print the target's `/flag-on-host.txt` token from the attacker container.

## Start / stop

```bash
./start.sh     # brings up both boxes, drops you into the attacker shell
./stop.sh
```

The `docker` CLI on the attacker box can be pointed at a remote daemon. Figure out how,
then figure out what a remote root daemon lets you do to its own host.
