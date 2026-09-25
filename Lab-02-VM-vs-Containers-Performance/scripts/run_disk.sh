#!/bin/bash
# ==============================================================================
# Automated Disk I/O Benchmark Suite (fio) for VM vs Docker Container
# ==============================================================================
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="$PROJECT_ROOT/results/raw/disk"
mkdir -p "$RESULTS_DIR/vm" "$RESULTS_DIR/container" /tmp/bench_disk

echo "=== Starting Disk I/O Benchmark Campaign (fio) ==="

# 1. VM Disk I/O
echo "[1/2] Running VM Disk Benchmark..."
fio --name=vm-randrw \
    --directory=/tmp/bench_disk \
    --ioengine=libaio \
    --rw=randrw \
    --bs=4k \
    --size=1G \
    --numjobs=4 \
    --runtime=30 \
    --group_reporting \
    --output="$RESULTS_DIR/vm/randrw_4k.txt"

# 2. Docker Container Disk I/O
echo "[2/2] Running Docker Container Disk Benchmark..."
docker run --rm \
    -v /tmp/bench_disk:/benchmark/data \
    vm-container-benchmark \
    fio --name=container-randrw \
    --directory=/benchmark/data \
    --ioengine=libaio \
    --rw=randrw \
    --bs=4k \
    --size=1G \
    --numjobs=4 \
    --runtime=30 \
    --group_reporting \
    --output="/benchmark/data/container_randrw_4k.txt"

cp /tmp/bench_disk/container_randrw_4k.txt "$RESULTS_DIR/container/randrw_4k.txt"
rm -rf /tmp/bench_disk

echo "✓ Disk Benchmarks completed successfully! Raw data saved to $RESULTS_DIR"
