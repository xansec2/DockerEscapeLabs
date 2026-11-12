FROM ubuntu:22.04
RUN apt-get update >/dev/null && apt-get install -y --no-install-recommends \
    gdb gcc libc6-dev procps nano >/dev/null 2>&1 || true
WORKDIR /root
CMD ["/bin/bash"]
