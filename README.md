# Parallel and GPU Computing (PGC) & Cloud Virtualization Laboratory

[![GitHub repo](https://img.shields.io/badge/Repository-Parth--Karpe%2FPGC--LAB-181717?style=for-the-badge&logo=github)](https://github.com/Parth-Karpe/PGC-LAB)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%2F%2024.04%20LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](#)
[![OpenMP](https://img.shields.io/badge/OpenMP-Multi--Threading-blue?style=for-the-badge)](#)
[![Open MPI](https://img.shields.io/badge/Open%20MPI-Distributed%20Cluster-success?style=for-the-badge)](#)
[![NVIDIA CUDA](https://img.shields.io/badge/NVIDIA%20CUDA-12.4%20GPU-76B900?style=for-the-badge&logo=nvidia&logoColor=white)](#)
[![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?style=for-the-badge&logo=docker&logoColor=white)](#)
[![Proxmox](https://img.shields.io/badge/Proxmox%20VE-Type--1%20Hypervisor-E57000?style=for-the-badge&logo=proxmox&logoColor=white)](#)

---

## 🏛️ Repository Architecture & Overview

This repository contains the complete practical implementations, benchmark suites, mathematical models, high-resolution evidence screenshots, and theoretical analyses for the **Parallel and GPU Computing (PGC)** and **Cloud Computing / Virtualization** curriculum.

```
PGC-LAB/
├── CC-Experiment-01-Hypervisor-Analysis/     # Type-1 (Proxmox VE) vs Type-2 (VMware) Benchmark
│   ├── screenshots/                         # 12 Mandatory evidence screenshots
│   │   ├── type1-proxmox/                   # 01 to 07 Proxmox VE screenshots
│   │   ├── type2-vmware/                    # 01 to 04 VMware Workstation screenshots
│   │   └── comparison/                      # 01 Performance comparison chart
│   ├── results/                             # Detailed analysis markdown
│   └── README.md                            # Experiment documentation & commands
│
├── Lab-01-Parallel-Matrix-Multiplication/   # 4000x4000 Matrix Multiplication across 4 Models
│   ├── src/
│   │   ├── sequential/                      # Single-threaded baseline C program
│   │   ├── openmp/                          # OpenMP shared-memory multi-threaded C program
│   │   ├── mpi/                             # Open MPI distributed cluster C program + hosts
│   │   └── cuda/                            # NVIDIA CUDA C++ 2D kernel (.cu)
│   ├── screenshots/                         # Terminal outputs, 16-core htop, speedup plots
│   ├── results/                             # Verification logs (C[0][0] = 4000.00)
│   └── README.md                            # Complete execution guide & derivations
│
├── Lab-02-VM-vs-Containers-Performance/     # Virtual Machines vs. Docker Containers Analysis
│   ├── docker/                              # Standardized benchmark Dockerfile
│   ├── docs/                                # Hardware, memory, storage & kernel configs
│   ├── scripts/                             # Automated Sysbench, fio, iperf3, Python runners
│   ├── workloads/                           # FastAPI microservice benchmark workload
│   ├── results/                             # Raw logs, summary_metrics.csv & plots
│   ├── screenshots/                         # Benchmark evidence & comparative charts
│   └── README.md                            # Multi-dimensional evaluation report
│
├── THEORY/                                  # Theoretical Concepts & Numerical Solutions
│   ├── 01-Introduction-To-Parallel-Computing.md # Flynn's Taxonomy, Memory Models, Concurrency
│   ├── 02-Amdahls-Law-Numerical-Problems.md     # Fixed workload strong scaling derivations
│   ├── 03-Gustafsons-Law-Application-Solutions.md # Scaled workload weak scaling solutions
│   └── chp_1.png                            # High-resolution infographic cheatsheet
│
└── README.md                                # Master repository documentation
```

---

## 📊 Summary of Benchmark Results

### 1. Matrix Multiplication ($4000 \times 4000$, Target: $C[0][0] = 4000.00$)

| Computing Model | Underlying Architecture | Execution Time (s) | Measured Speedup | Correctness |
| :--- | :--- | :--- | :--- | :--- |
| **Sequential** | 1 CPU Core (Single Thread Baseline) | **244.120000 s** | **1.00× (Baseline)** | `4000.00` (Passed) |
| **OpenMP** | 8 CPU Cores (Shared Memory) | **30.830434 s** | **7.92×** | `4000.00` (Passed) |
| **OpenMP** | 16 Threads (High Concurrency) | **126.352793 s** | **1.93×** | `4000.00` (Passed) |
| **Open MPI** | 4 Distributed Nodes (VM Cluster) | **92.979510 s** | **2.63×** | `4000.00` (Passed) |
| **NVIDIA CUDA** | RTX 4500 Ada (16,000,000 Threads) | **0.165004 s** | **1,479.48×** | `4000.00` (Passed) |

---

### 2. Hypervisor Analysis: Type-1 (Proxmox VE) vs. Type-2 (VMware Workstation)

| Benchmark Metric | Type-1 Proxmox VE (Bare-Metal) | Type-2 VMware Workstation (Hosted) | Advantage |
| :--- | :--- | :--- | :--- |
| **CPU Throughput (Sysbench)** | **1,548.22 events/sec** | **1,382.45 events/sec** | **+12.0% Faster (Proxmox)** |
| **Average Latency** | **1.29 ms** | **1.44 ms** | **10.4% Lower Latency** |
| **P95 Latency** | **1.35 ms** | **1.52 ms** | **11.2% Lower Latency** |
| **Jitter / Max Latency** | **2.85 ms** | **4.12 ms** | **30.8% Lower Spikes** |

---

### 3. Virtualization vs. Containerization (VMware VM vs. Docker Container)

| Metric Category | Specific Benchmark Metric | VMware VM | Docker Container | Advantage |
| :--- | :--- | :--- | :--- | :--- |
| **CPU Throughput** | Sysbench Events/sec | 2,850.40 eps | **3,180.75 eps** | **Docker (+11.6%)** |
| **Memory Bandwidth**| Sysbench RAM Transfer | 18,450 MB/s | **22,100 MB/s** | **Docker (+19.8%)** |
| **Disk Storage** | fio 4K RandRW Bandwidth | 483 MB/s | **758 MB/s** | **Docker (+56.9%)** |
| **Network** | iperf3 Host Bandwidth | 8.74 Gbps | **38.40 Gbps** | **Docker (4.4× higher)** |
| **Application API** | FastAPI Throughput | 1,420 req/s | **1,890 req/s** | **Docker (+33.1%)** |
| **Lifecycle** | Cold Boot Startup Time | 24.8 s | **0.85 s** | **Docker (29.2× faster)** |
| **Memory Footprint**| Idle RAM Overhead | 1,250 MB | **142 MB** | **Docker (8.8× lighter)** |

---

## ⚡ Quickstart Commands Cheat Sheet

### 1. Build and Run Parallel Matrix Multiplication
```bash
# Part A: Sequential
cd Lab-01-Parallel-Matrix-Multiplication/src/sequential
gcc -O2 matrix_sequential.c -o matrix_sequential
./matrix_sequential

# Part B: OpenMP
cd ../openmp
gcc -O2 -fopenmp matrix_openmp.c -o matrix_openmp
export OMP_NUM_THREADS=16
./matrix_openmp

# Part C: MPI (4 Processes)
cd ../mpi
mpicc -O2 matrix_mpi.c -o matrix_mpi
mpirun -np 4 --hostfile hosts sh -c '$HOME/matrix_mpi'

# Part D: NVIDIA CUDA
cd ../cuda
nvcc -O2 matrix_cuda.cu -o matrix_cuda
./matrix_cuda
```

### 2. Run VM vs Container Performance Suite
```bash
cd Lab-02-VM-vs-Containers-Performance

# Build Docker image
docker build -t vm-container-benchmark -f docker/Dockerfile .

# Run automated test suites
bash scripts/run_cpu.sh
bash scripts/run_memory.sh
bash scripts/run_disk.sh
python3 scripts/benchmark_all.py
```

---

## 🚀 Git Synchronization Guide

To sync and push this complete laboratory repository to GitHub:

```bash
# 1. Initialize git repository (if not already initialized)
git init

# 2. Add remote origin
git remote add origin git@github.com:Parth-Karpe/PGC-LAB.git

# 3. Stage all source codes, screenshots, and documentation
git add .

# 4. Commit changes
git commit -m "feat: complete PGC and Cloud Lab implementations, benchmarks, evidence screenshots, and documentation"

# 5. Push to main branch
git branch -M main
git push -u origin main
```

---

## 👨‍💻 Author & Course Information

* **Course:** Parallel and GPU Computing (PGC) & Cloud Computing
* **Repository:** [Parth-Karpe/PGC-LAB](https://github.com/Parth-Karpe/PGC-LAB)
* **Status:** All experiments, verified results, and mandatory screenshot structures complete.
