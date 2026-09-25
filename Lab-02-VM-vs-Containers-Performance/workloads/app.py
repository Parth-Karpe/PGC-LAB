import time
import math
import numpy as np
from fastapi import FastAPI, Query

app = FastAPI(title="PGC Microservice Workload Benchmark API", version="1.0.0")

@app.get("/health")
def health_check():
    return {"status": "healthy", "timestamp": time.time()}

@app.get("/compute-matrix")
def compute_matrix(size: int = Query(default=200, ge=10, le=1000)):
    """
    Executes a controlled CPU and memory intensive floating-point matrix multiplication
    to measure request-response latency, throughput, and memory pressure.
    """
    start = time.perf_counter()
    A = np.ones((size, size), dtype=np.float32)
    B = np.ones((size, size), dtype=np.float32)
    C = np.dot(A, B)
    duration = time.perf_counter() - start
    
    return {
        "status": "success",
        "matrix_size": f"{size}x{size}",
        "duration_seconds": round(duration, 6),
        "verification_element": float(C[0, 0]),
        "total_operations": size ** 3
    }

@app.get("/prime-stress")
def prime_stress(n: int = Query(default=50000, ge=1000, le=500000)):
    """
    CPU-bound prime search workload.
    """
    start = time.perf_counter()
    primes = []
    for num in range(2, n + 1):
        is_prime = True
        for i in range(2, int(math.isqrt(num)) + 1):
            if num % i == 0:
                is_prime = False
                break
        if is_prime:
            primes.append(num)
    duration = time.perf_counter() - start
    
    return {
        "status": "success",
        "prime_limit": n,
        "total_primes_found": len(primes),
        "duration_seconds": round(duration, 6)
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
