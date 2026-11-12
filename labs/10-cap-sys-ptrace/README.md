# Lab 10 — CAP_SYS_PTRACE + shared host PID namespace

## Scenario

You're in a profiler/debugger container: it has `--pid=host` (shares the host process
namespace) and `CAP_SYS_PTRACE` (can attach a debugger to other processes). Together these
are exactly what a performance-profiling or crash-dump tool asks for.

They're also exactly what you need to **attach to a host process and hijack it**. With
ptrace over a host process you can read its memory and, more usefully, inject code so the
host process executes your instructions — as whatever user it runs as, including root.

Real-world parallels: debugging/observability sidecars, profilers, and crash reporters
that get `SYS_PTRACE` plus host PID visibility.

## Your task

Attach to a **host** process and make it run your code, then read `/flag-on-host.txt`
(root-only, not in the container image).

## Success criterion

You print the host flag token, obtained by hijacking a host process (not by any other
lab's technique).

## Build tools

The image ships `gdb` and `gcc`. How you drive the injection — debugger scripting or raw
`ptrace` — is up to you.

## Start / stop

```bash
./start.sh
./stop.sh
```

`ps aux` inside the container will show host processes. Pick a target and figure out how
to turn "I can debug it" into "it runs my code."
