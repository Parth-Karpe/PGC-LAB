# Parallel Matrix Multiplication Performance & Speedup Analysis

## 1. Problem Specification

* **Matrix Dimensions:** $N = 4000 \times 4000$ double-precision (or single-precision float for GPU).
* **Matrix A Initialization:** All elements $A[i][j] = 1.0$.
* **Matrix B Initialization:** All elements $B[i][j] = 1.0$.
* **Mathematical Verification Target:**
  $$C[0][0] = \sum_{k=0}^{3999} (1.0 \times 1.0) = 4000.00$$
* **Total Floating Point Operations (FLOPs):**
  $$2 \times N^3 = 2 \times 4000^3 = 1.28 \times 10^{11}\text{ FLOPs } (128\text{ GFLOPs})$$

---

## 2. Experimental Execution Results

| Computing Model | Hardware / Concurrency | Execution Time | Measured Speedup | Mathematical Verification |
| :--- | :--- | :--- | :--- | :--- |
| **Sequential (CPU)** | 1 Core (Single-Threaded Baseline) | **244.120000 s** | **1.00× (Baseline)** | $C[0][0] = 4000.00$ |
| **OpenMP (Shared Memory)** | 8 CPU Cores / Threads | **30.830434 s** | **7.92×** | $C[0][0] = 4000.00$ |
| **OpenMP (High Concurrency)** | 16 Logical Threads | **126.352793 s** | **1.93×** | $C[0][0] = 4000.00$ |
| **MPI (Distributed Memory)** | 4 Processes across 4 VMs | **92.979510 s** | **2.63×** | $C[0][0] = 4000.00$ |
| **CUDA (GPU Parallelism)** | NVIDIA RTX 4500 Ada (16M Threads) | **0.165004 s** | **1,479.48×** | $C[0][0] = 4000.00$ |

---

## 3. Analysis & Key Insights

1. **OpenMP Near-Linear Scaling:** With 8 physical CPU cores, OpenMP achieves a **$7.92\times$ speedup (99.0% parallel efficiency)** because the outer loop iterations are independently partitioned without shared write conflicts.
2. **MPI Communication Cost:** In a distributed 4-node VM cluster, `MPI_Scatter` and `MPI_Gather` incur network serialization overhead across the virtual switch, achieving a **$2.63\times$ speedup**.
3. **CUDA Massive GPU Throughput:** Launching $16,000,000$ concurrent logical threads across $62,500$ CUDA blocks achieves a **$1,479.48\times$ total speedup**, executing $128\text{ GFLOPs}$ in just $165\text{ milliseconds}$.
