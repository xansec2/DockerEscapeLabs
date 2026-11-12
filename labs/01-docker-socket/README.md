# Lab 01 — The mounted Docker socket

## Scenario

You've landed a shell in a container called `ci-runner`. It's a build agent: the kind
of thing a CI/CD pipeline uses to build and push images. To "let the pipeline build
Docker images," whoever set it up bind-mounted the host's Docker socket into the
container.

This is one of the single most common real-world container escapes. It shows up in:

- **Jenkins / GitLab / GitHub Actions self-hosted runners** configured with
  `-v /var/run/docker.sock:/var/run/docker.sock` so jobs can run `docker build`.
- **Portainer**, **Watchtower**, and other management containers given the socket to
  manage other containers.
- The **TeamTNT** and **Kinsing** crews both automated this exact pivot once inside a
  container that had the socket.

## Your task

From inside the `ci-runner` container, read `/flag-on-host.txt`, which exists **only on
the host filesystem**, not in the container. Getting its contents proves you reached the
host.

## Success criterion

You can print the contents of the host's `/flag-on-host.txt` (a random token), and
ideally get an interactive root shell on the host filesystem.

## Start / stop

```bash
./start.sh     # writes the host flag, launches the container, drops you in
./stop.sh
```

You start as a non-root user inside the container, to make it realistic. Enumerate the
container (see the "General recon" section in the top-level [README](../../README.md))
and work out the path yourself.
