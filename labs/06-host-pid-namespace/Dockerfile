FROM ubuntu:22.04
RUN apt-get update >/dev/null && apt-get install -y --no-install-recommends \
    util-linux procps >/dev/null 2>&1 || true
WORKDIR /root
CMD ["/bin/bash"]
