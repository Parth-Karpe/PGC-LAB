# Amdahl's Law — Theory & Solved Numerical Problems

## 1. Theoretical Foundation

**Amdahl's Law** (Gene Amdahl, 1967) models the theoretical speedup of an application when executed across multiple parallel processors under a **fixed workload / fixed problem size (Strong Scaling)**.

### Mathematical Formula

$$S(N) = \frac{1}{(1 - P) + \frac{P}{N}}$$

Where:
* $P$ = Fraction of the algorithm that is parallelizable ($0 \le P \le 1$).
* $1 - P$ = Fraction of the algorithm that is strictly sequential / serial ($s$).
* $N$ = Number of parallel processing units (cores / nodes / GPUs).
* $S(N)$ = Theoretical Speedup factor achieved.

### Maximum Theoretical Speedup (Asymptotic Limit)

As the number of processors $N \to \infty$, the parallel execution term $\frac{P}{N} \to 0$:

$$S_{\max} = \lim_{N \to \infty} S(N) = \frac{1}{1 - P}$$

> **Key Insight:** Even with infinite processors, the maximum achievable speedup is strictly bounded by the reciprocal of the sequential portion.

---

## 2. Solved Numerical Problems

### Problem 1: 75% Parallel Program on 4 Processors

**Question:**  
A parallel program consists of $75\%$ parallelizable code and $25\%$ sequential code. The program is executed on $4$ processors.
* **a)** Calculate the theoretical speedup achieved using 4 processors.
* **b)** Calculate the execution time if the original execution time on one processor is $80\text{ seconds}$.
* **c)** Explain why the speedup is less than $4\times$.

**Solution:**
* Given: $P = 0.75$, $1 - P = 0.25$, $N = 4$, $T_{\text{old}} = 80\text{ s}$.

**a) Theoretical Speedup:**
$$S(4) = \frac{1}{(1 - 0.75) + \frac{0.75}{4}} = \frac{1}{0.25 + 0.1875} = \frac{1}{0.4375} \approx 2.29\times$$

**b) New Execution Time:**
$$T_{\text{new}} = \frac{T_{\text{old}}}{S(4)} = \frac{80\text{ s}}{2.29} \approx 34.91\text{ seconds}$$

**c) Explanation:**
Although $4$ processors are used, the $25\%$ sequential fraction ($20\text{ seconds}$) cannot be accelerated or parallelized across the cores. This serial bottleneck creates a fundamental floor on execution time, preventing a linear $4\times$ speedup.

---

### Problem 2: 80% Parallel Program on 8 Processors

**Question:**  
A program takes $120\text{ seconds}$ to execute on a single processor. $80\%$ of the program can be parallelized, while the remaining $20\%$ is sequential.
* **a)** Calculate the theoretical speedup when $8$ processors are used.
* **b)** Determine the new execution time with $8$ processors.
* **c)** What is the maximum possible speedup if an infinite number of processors are used?

**Solution:**
* Given: $T_{\text{old}} = 120\text{ s}$, $P = 0.80$, $1 - P = 0.20$, $N = 8$.

**a) Theoretical Speedup:**
$$S(8) = \frac{1}{(1 - 0.80) + \frac{0.80}{8}} = \frac{1}{0.20 + 0.10} = \frac{1}{0.30} = \frac{10}{3} \approx 3.33\times$$

**b) New Execution Time:**
$$T_{\text{new}} = \frac{120}{\frac{10}{3}} = 120 \times \frac{3}{10} = 36.0\text{ seconds}$$

**c) Maximum Theoretical Speedup ($N \to \infty$):**
$$S_{\max} = \frac{1}{1 - P} = \frac{1}{0.20} = 5.0\times$$

Regardless of how many thousands of cores are added, the minimum execution time will never drop below $24\text{ seconds}$ ($20\%$ of $120\text{s}$).

---

### Problem 3: Diminishing Returns — 5 Processors vs 10 Processors

**Question:**  
Consider a program in which $15\%$ of the execution is sequential and the remaining $85\%$ can be parallelized.
* **a)** Calculate the theoretical speedup when running on $5$ processors.
* **b)** Calculate the theoretical speedup when running on $10$ processors.
* **c)** Compare both results and explain why doubling the number of processors does not double the speedup.

**Solution:**
* Given: $1 - P = 0.15$, $P = 0.85$.

**a) Speedup with 5 Processors ($N=5$):**
$$S(5) = \frac{1}{0.15 + \frac{0.85}{5}} = \frac{1}{0.15 + 0.17} = \frac{1}{0.32} = 3.125\times$$

**b) Speedup with 10 Processors ($N=10$):**
$$S(10) = \frac{1}{0.15 + \frac{0.85}{10}} = \frac{1}{0.15 + 0.085} = \frac{1}{0.235} \approx 4.26\times$$

**c) Comparison Analysis:**
* $5\text{ Processors} \implies 3.125\times\text{ speedup}$ (Parallel Efficiency: $62.5\%$)
* $10\text{ Processors} \implies 4.26\times\text{ speedup}$ (Parallel Efficiency: $42.6\%$)
* **Conclusion:** Increasing processors by $100\%$ ($5 \to 10$) only yields a $36.3\%$ speedup improvement ($3.125 \to 4.26$). The fixed $15\%$ sequential portion dominates total runtime as parallel time shrinks.
