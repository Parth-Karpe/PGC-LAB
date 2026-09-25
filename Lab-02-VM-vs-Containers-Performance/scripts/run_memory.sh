#!/bin/bash
# ==============================================================================
# Automated Memory Benchmark Suite for VM vs Docker Container
# ==============================================================================
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="$PROJECT_ROOT/results/raw/memory"
mkdir -p "$RESULTS_DIR/vm" "$RESULTS_DIR/container"

echo "=== Starting Memory Benchmark Campaign ==="

# 1. VM Memory Benchmarks (10 Repetitions)
echo "[1/2] Running VM Memory Benchmark (10 runs)..."
for i in {1..10}; do
    echo "  -> VM Memory Run $i/10..."
    sysbench memory \
        --memory-block-size=1M \
        --memory-total-size=10G \
        --threads=4 \
        run > "$RESULTS_DIR/vm/run$i.txt"
done

# 2. Container Memory Benchmarks (10 Repetitions)
echo "[2/2] Running Docker Container Memory Benchmark (10 runs)..."
for i in {1..10}; do
    echo "  -> Container Memory Run $i/10..."
    docker run --rm \
        --cpus=4 \
        --memory=8g \
        vm-container-benchmark \
        sysbench memory \
        --memory-block-size=1M \
        --memory-total-size=10G \
        --threads=4 \
        run > "$RESULTS_DIR/container/run$i.txt"
done

echo "✓ Memory Benchmarks completed successfully! Raw data saved to $RESULTS_DIR"
