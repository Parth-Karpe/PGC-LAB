# Parallel and GPU Computing (PGC) Laboratory — Experiment 01

[![GitHub repo](https://img.shields.io/badge/Repository-Parth--Karpe%2FPGC__LAB__EXPERIMENT__01-181717?style=for-the-badge&logo=github)](https://github.com/Parth-Karpe/PGC_LAB_EXPERIMENT_01)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%2F%2024.04%20LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](#)
[![OpenMP](https://img.shields.io/badge/OpenMP-Shared--Memory%20Threading-blue?style=for-the-badge)](#)
[![Open MPI](https://img.shields.io/badge/Open%20MPI-Distributed%20Cluster-success?style=for-the-badge)](#)
[![NVIDIA CUDA](https://img.shields.io/badge/NVIDIA%20CUDA-13.4%20GPU-76B900?style=for-the-badge&logo=nvidia&logoColor=white)](#)

---

## 🏛️ Repository Architecture & Overview

This repository contains the complete practical implementations, benchmark suites, mathematical derivations, verification logs, and high-resolution evidence screenshots for the **Parallel and GPU Computing (PGC)** curriculum.

The primary benchmark evaluates large-scale **$4000 \times 4000$ Dense Matrix Multiplication** ($C = A \times B$) across four core computational paradigms:
1. **Sequential (C)** – Single-threaded CPU baseline.
2. **OpenMP (C)** – Shared-memory multi-core multi-threading.
3. **Open MPI (C)** – Distributed-memory multi-process cluster message passing.
4. **NVIDIA CUDA (C++)** – Massively parallel 2D grid/block GPU acceleration.

```
PGC_LAB_EXPERIMENT_01/
├── Lab-01-Parallel-Matrix-Multiplication/   # 4000x4000 Matrix Multiplication across 4 Models
│   ├── 01-sequential/                       # Single-threaded baseline C program
│   │   ├── matrix_sequential.c
│   │   └── screenshots/
│   │       └── 01-sequential-execution.png
│   ├── 02-openmp/                           # OpenMP shared-memory multi-threaded C program
│   │   ├── matrix_openmp.c
│   │   └── screenshots/
│   ├── 03-mpi/                              # Open MPI distributed cluster C program + hostfile
│   │   ├── matrix_mpi.c
│   │   ├── hosts
│   │   └── screenshots/
│   ├── 04-cuda/                             # NVIDIA CUDA C++ 2D kernel (.cu)
│   │   ├── matrix_cuda.cu
│   │   └── screenshots/
│   ├── 05-results/                          # Verification logs (C[0][0] = 4000.00) & metrics
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
| **NVIDIA CUDA** | RTX 5060 Ti (16,000,000 GPU Threads)| **0.330440 s** | **738.73×** | `4000.00` | ✅ Passed |

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
git remote add origin git@github.com:Parth-Karpe/PGC_LAB_EXPERIMENT_01.git

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
* **Repository:** [Parth-Karpe/PGC_LAB_EXPERIMENT_01](https://github.com/Parth-Karpe/PGC_LAB_EXPERIMENT_01)
* **Status:** All 4 programming paradigms (Sequential, OpenMP, MPI, CUDA) implemented, benchmarked, verified, and documented.
