# Parallel and GPU Computing (PGC) Laboratory

[![GitHub repo](https://img.shields.io/badge/Repository-Parth--Karpe%2FPGC--LAB-181717?style=for-the-badge&logo=github)](https://github.com/Parth-Karpe/PGC-LAB)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%2F%2024.04%20LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](#)
[![OpenMP](https://img.shields.io/badge/OpenMP-Shared--Memory%20Threading-blue?style=for-the-badge)](#)
[![Open MPI](https://img.shields.io/badge/Open%20MPI-Distributed%20Cluster-success?style=for-the-badge)](#)
[![NVIDIA CUDA](https://img.shields.io/badge/NVIDIA%20CUDA-12.4%20GPU-76B900?style=for-the-badge&logo=nvidia&logoColor=white)](#)

---

## 🏛️ Repository Architecture & Overview

This repository contains the complete practical implementations, benchmark suites, mathematical derivations, verification logs, and high-resolution evidence screenshots for the **Parallel and GPU Computing (PGC)** curriculum.

The primary benchmark evaluates large-scale **$4000 \times 4000$ Dense Matrix Multiplication** ($C = A \times B$) across four core computational paradigms:
1. **Sequential (C)** – Single-threaded CPU baseline.
2. **OpenMP (C)** – Shared-memory multi-core multi-threading.
3. **Open MPI (C)** – Distributed-memory multi-process cluster message passing.
4. **NVIDIA CUDA (C++)** – Massively parallel 2D grid/block GPU acceleration.

```
PGC-LAB/
├── Lab-01-Parallel-Matrix-Multiplication/   # 4000x4000 Matrix Multiplication across 4 Models
│   ├── src/
│   │   ├── sequential/                      # Single-threaded baseline C program
│   │   ├── openmp/                          # OpenMP shared-memory multi-threaded C program
│   │   ├── mpi/                             # Open MPI distributed cluster C program + hostfile
│   │   └── cuda/                            # NVIDIA CUDA C++ 2D kernel (.cu)
│   ├── screenshots/                         # Terminal outputs, 16-core htop, speedup plots
│   │   ├── 01-wsl-verification.png
│   │   ├── 02-sequential-execution.png
│   │   ├── 03-openmp-execution.png
│   │   ├── 04-openmp-htop-cores.png
│   │   ├── 05-mpi-cluster-network.png
│   │   ├── 06-mpi-execution.png
│   │   ├── 07-cuda-nvidia-smi.png
│   │   ├── 08-cuda-execution.png
│   │   └── 09-speedup-comparison-chart.png
│   ├── results/                             # Verification logs (C[0][0] = 4000.00) & metrics
│   │   └── performance-comparison.md
│   └── README.md                            # Complete execution guide, derivations & analyses
│
├── VIVA_AND_EXAM_QUICK_REFERENCE.md         # 1-Line answers, Amdahl's Law, commands & QA cheatsheet
└── README.md                                # Master repository documentation
```

---

## 📊 Summary of Benchmark Results

### Matrix Multiplication ($4000 \times 4000$, Target Verification: $C[0][0] = 4000.00$)

* **Workload Size:** $4000 \times 4000$ elements per matrix ($16,000,000$ floating-point multiplications & additions)
* **Mathematical Invariant:** $A_{i,j} = 1.0, B_{i,j} = 1.0 \implies C_{i,j} = \sum_{k=0}^{3999} 1.0 \times 1.0 = 4000.00$

| Computing Model | Underlying Architecture | Execution Time (s) | Measured Speedup | Verification ($C[0][0]$) | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Sequential (Baseline)** | 1 CPU Core (Single Thread) | **244.120000 s** | **1.00× (Baseline)** | `4000.00` | ✅ Passed |
| **OpenMP (8 Threads)** | 8 CPU Cores (Shared Memory) | **30.830434 s** | **7.92×** | `4000.00` | ✅ Passed |
| **OpenMP (16 Threads)** | 16 CPU Threads (SMT/Hyperthreading)| **126.352793 s** | **1.93×** | `4000.00` | ✅ Passed |
| **Open MPI (4 Ranks)** | 4 Distributed Nodes / VMs | **92.979510 s** | **2.63×** | `4000.00` | ✅ Passed |
| **NVIDIA CUDA** | RTX 4500 Ada (16,000,000 GPU Threads)| **0.165004 s** | **1,479.48×** | `4000.00` | ✅ Passed |

---

## ⚡ Quickstart Build and Execution Commands

### 1. Sequential Baseline
```bash
cd Lab-01-Parallel-Matrix-Multiplication/src/sequential
gcc -O2 matrix_sequential.c -o matrix_sequential
./matrix_sequential
```

### 2. OpenMP (Shared Memory Multi-Threading)
```bash
cd Lab-01-Parallel-Matrix-Multiplication/src/openmp
gcc -O2 -fopenmp matrix_openmp.c -o matrix_openmp
export OMP_NUM_THREADS=8
./matrix_openmp
```

### 3. Open MPI (Distributed Memory Cluster)
```bash
cd Lab-01-Parallel-Matrix-Multiplication/src/mpi
mpicc -O2 matrix_mpi.c -o matrix_mpi
mpirun -np 4 --hostfile hosts ./matrix_mpi
```

### 4. NVIDIA CUDA (GPU Acceleration)
```bash
cd Lab-01-Parallel-Matrix-Multiplication/src/cuda
nvcc -O2 matrix_cuda.cu -o matrix_cuda
./matrix_cuda
```

---

## 🚀 Git Synchronization Guide

To sync and push this repository to GitHub:

```bash
# 1. Initialize git repository (if not already initialized)
git init

# 2. Add remote origin
git remote add origin git@github.com:Parth-Karpe/PGC-LAB.git

# 3. Stage all source code, results, and documentation
git add .

# 4. Commit changes
git commit -m "feat: complete Parallel and GPU Computing (PGC) implementations, benchmarks, evidence screenshots, and documentation"

# 5. Push to main branch
git branch -M main
git push -u origin main
```

---

## 👨‍💻 Author & Course Information

* **Course:** Parallel and GPU Computing (PGC) Laboratory
* **Repository:** [Parth-Karpe/PGC-LAB](https://github.com/Parth-Karpe/PGC-LAB)
* **Status:** All 4 programming paradigms (Sequential, OpenMP, MPI, CUDA) implemented, benchmarked, verified, and documented.
