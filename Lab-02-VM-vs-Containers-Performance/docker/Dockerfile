FROM ubuntu:24.04

# Avoid interactive dialogues during build
ENV DEBIAN_FRONTEND=noninteractive

# Install benchmark suites and core utilities
RUN apt-get update && \
    apt-get install -y \
    sysbench \
    fio \
    iperf3 \
    python3 \
    python3-pip \
    procps \
    sysstat \
    iproute2 \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /benchmark

CMD ["/bin/bash"]
