#!/bin/bash
# ==============================================================================
# Automated CPU Benchmark Suite for VM vs Docker Container
# ==============================================================================
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="$PROJECT_ROOT/results/raw/cpu"
mkdir -p "$RESULTS_DIR/vm" "$RESULTS_DIR/container"

echo "=== Starting CPU Benchmark Campaign ==="

# 1. Host/VM Benchmark Execution (10 Repetitions)
echo "[1/2] Running VM CPU Benchmark (10 runs)..."
for i in {1..10}; do
    echo "  -> VM Run $i/10..."
    sysbench cpu \
        --cpu-max-prime=20000 \
        --threads=4 \
        --time=30 \
        run > "$RESULTS_DIR/vm/run$i.txt"
done

# 2. Container Benchmark Execution (10 Repetitions)
echo "[2/2] Running Docker Container CPU Benchmark (10 runs)..."
for i in {1..10}; do
    echo "  -> Container Run $i/10..."
    docker run --rm \
        --cpus=4 \
        --memory=8g \
        vm-container-benchmark \
        sysbench cpu \
        --cpu-max-prime=20000 \
        --threads=4 \
        --time=30 \
        run > "$RESULTS_DIR/container/run$i.txt"
done

echo "✓ CPU Benchmarks completed successfully! Raw data saved to $RESULTS_DIR"
