FROM docker:27-cli
# A realistic CI build-agent image: has the docker CLI and a shell, runs as non-root.
RUN apk add --no-cache bash curl >/dev/null 2>&1 || true
RUN adduser -D -s /bin/bash builder 2>/dev/null || true
WORKDIR /home/builder
CMD ["/bin/bash"]
