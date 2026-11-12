FROM ubuntu:22.04
RUN apt-get update >/dev/null && apt-get install -y --no-install-recommends \
    build-essential kmod nano >/dev/null 2>&1 || true
WORKDIR /root
CMD ["/bin/bash"]
