#!/bin/bash
# ==============================================================================
# Automated Network Bandwidth Benchmark Suite (iperf3)
# ==============================================================================
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="$PROJECT_ROOT/results/raw/network"
mkdir -p "$RESULTS_DIR/vm" "$RESULTS_DIR/container"

SERVER_IP="${1:-127.0.0.1}"

echo "=== Starting Network Benchmark Campaign (iperf3 to $SERVER_IP) ==="

# 1. VM Network Benchmark
echo "[1/2] Running VM Network Bandwidth Test..."
iperf3 -c "$SERVER_IP" -t 10 -P 4 -J > "$RESULTS_DIR/vm/iperf_client.json"

# 2. Container Network Benchmark
echo "[2/2] Running Container Network Bandwidth Test..."
docker run --rm \
    --network=host \
    vm-container-benchmark \
    iperf3 -c "$SERVER_IP" -t 10 -P 4 -J > "$RESULTS_DIR/container/iperf_client.json"

echo "✓ Network Benchmarks completed successfully! Raw data saved to $RESULTS_DIR"
