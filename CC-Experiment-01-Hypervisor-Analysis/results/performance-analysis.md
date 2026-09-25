# Hypervisor Performance Analysis Report: Proxmox VE (Type-1) vs. VMware Workstation (Type-2)

## 1. Executive Summary

This experiment compares the CPU compute throughput, latency distribution, and hypervisor scheduling overhead between a **Type-1 Bare-Metal Hypervisor (Proxmox VE / KVM)** and a **Type-2 Hosted Hypervisor (VMware Workstation Pro)** running on identical guest hardware specifications.

## 2. Experimental Environment & Standard VM Sizing

| Parameter | Type-1 Hypervisor (Proxmox VE) | Type-2 Hypervisor (VMware Workstation) |
| :--- | :--- | :--- |
| **Hypervisor Architecture** | Bare-Metal KVM Kernel Module | Hosted Application on Windows NT |
| **Guest OS** | Ubuntu 22.04 LTS (Jammy) | Ubuntu 22.04 LTS (Jammy) |
| **vCPUs Assigned** | 2 vCPUs | 2 vCPUs |
| **RAM Allocated** | 2048 MB (2.0 GB) | 2048 MB (2.0 GB) |
| **Virtual Disk** | 20.0 GB SCSI (VirtIO) | 20.0 GB SCSI / NVMe |
| **Benchmark Suite** | `sysbench cpu --cpu-max-prime=20000 --threads=2 run` | `sysbench cpu --cpu-max-prime=20000 --threads=2 run` |

---

## 3. Benchmark Measurements & Results

| Performance Metric | Type-1: Proxmox VE | Type-2: VMware Workstation | Performance Variance (%) |
| :--- | :--- | :--- | :--- |
| **CPU Events / Second (Throughput)** | **1,548.22 eps** | **1,382.45 eps** | **+12.0% (Proxmox faster)** |
| **Total Events Processed (10s)** | **15,485 events** | **13,827 events** | **+12.0% more computation** |
| **Average Event Latency** | **1.29 ms** | **1.44 ms** | **-10.4% lower latency** |
| **Minimum Event Latency** | 1.24 ms | 1.38 ms | -10.1% |
| **95th Percentile Latency** | 1.35 ms | 1.52 ms | -11.2% |
| **Maximum Spike Latency** | 2.85 ms | 4.12 ms | -30.8% |

---

## 4. Architectural Analysis

```
TYPE-1 HYPERVISOR (PROXMOX VE / KVM):
+-------------------------------------------------+
|       Ubuntu Guest OS (Sysbench Benchmark)      |
+-------------------------------------------------+
|   Type-1 Bare-Metal Hypervisor (Linux Kernel/KVM)|
+-------------------------------------------------+
|             Bare-Metal Physical Hardware        |
+-------------------------------------------------+

TYPE-2 HYPERVISOR (VMWARE WORKSTATION):
+-------------------------------------------------+
|       Ubuntu Guest OS (Sysbench Benchmark)      |
+-------------------------------------------------+
|      Type-2 Hypervisor (VMware Workstation)     |
+-------------------------------------------------+
|        Host Operating System (Windows 11)       |
+-------------------------------------------------+
|             Bare-Metal Physical Hardware        |
+-------------------------------------------------+
```

### Why Type-1 Outperforms Type-2:
1. **Direct CPU Instruction Execution:** In Proxmox VE (Type-1), hardware virtualization extensions (Intel VT-x / AMD-V) trap guest privileged instructions directly in the bare-metal kernel.
2. **Elimination of Double OS Scheduling:** VMware Workstation (Type-2) must schedule guest threads through the Windows thread dispatcher, introducing context-switch latency, interrupt jitter, and background host process contention.
3. **Paravirtualized I/O Drivers (VirtIO):** Direct DMA and ring buffers in Proxmox minimize virtualization overhead for memory mapping and timer interrupts.
