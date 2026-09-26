#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#define N 4000

// 2D CUDA Matrix Multiplication Kernel
// Each CUDA thread computes exactly one output element C[row][col]
__global__ void matMulKernel(const float *A, const float *B, float *C, int n)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < n && col < n)
    {
        float sum = 0.0f;
        for (int k = 0; k < n; k++)
        {
            sum += A[row * n + k] * B[k * n + col];
        }
        C[row * n + col] = sum;
    }
}

int main()
{
    size_t bytes = (size_t)N * N * sizeof(float);

    float *h_A, *h_B, *h_C;
    float *d_A, *d_B, *d_C;

    printf("=====================================================\n");
    printf(" CUDA GPU Parallel Matrix Multiplication             \n");
    printf(" Matrix Dimensions: %d x %d                           \n", N, N);
    printf(" Matrix Memory:     %.2f MB per matrix               \n", bytes / (1024.0 * 1024.0));
    printf("=====================================================\n");

    // Allocate host pinned memory or standard heap memory
    h_A = (float *)malloc(bytes);
    h_B = (float *)malloc(bytes);
    h_C = (float *)malloc(bytes);

    if (h_A == NULL || h_B == NULL || h_C == NULL)
    {
        printf("Error: Host memory allocation failed!\n");
        return 1;
    }

    printf("Initializing host matrices with 1.0f...\n");
    for (int i = 0; i < N * N; i++)
    {
        h_A[i] = 1.0f;
        h_B[i] = 1.0f;
        h_C[i] = 0.0f;
    }

    // Allocate GPU Device Global Memory
    cudaError_t err;
    err = cudaMalloc((void **)&d_A, bytes);
    if (err != cudaSuccess) { printf("CUDA malloc error d_A: %s\n", cudaGetErrorString(err)); return 1; }
    err = cudaMalloc((void **)&d_B, bytes);
    if (err != cudaSuccess) { printf("CUDA malloc error d_B: %s\n", cudaGetErrorString(err)); return 1; }
    err = cudaMalloc((void **)&d_C, bytes);
    if (err != cudaSuccess) { printf("CUDA malloc error d_C: %s\n", cudaGetErrorString(err)); return 1; }

    cudaEvent_t totalStart, totalStop;
    cudaEvent_t kernelStart, kernelStop;

    cudaEventCreate(&totalStart);
    cudaEventCreate(&totalStop);
    cudaEventCreate(&kernelStart);
    cudaEventCreate(&kernelStop);

    // Total CUDA phase starts (includes PCIe Host-to-Device transfer)
    cudaEventRecord(totalStart);

    cudaMemcpy(d_A, h_A, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, bytes, cudaMemcpyHostToDevice);

    // Grid and Block Configuration
    dim3 block(16, 16); // 256 threads per block
    dim3 grid((N + block.x - 1) / block.x, (N + block.y - 1) / block.y); // 250 x 250 = 62,500 blocks

    printf("Launching CUDA Kernel:\n");
    printf("  Grid Dimensions:  %d x %d blocks (%d total blocks)\n", grid.x, grid.y, grid.x * grid.y);
    printf("  Block Dimensions: %d x %d threads (%d threads per block)\n", block.x, block.y, block.x * block.y);
    printf("  Total Logical Threads: %lu\n", (unsigned long)grid.x * grid.y * block.x * block.y);

    cudaEventRecord(kernelStart);
    matMulKernel<<<grid, block>>>(d_A, d_B, d_C, N);
    cudaEventRecord(kernelStop);
    cudaEventSynchronize(kernelStop);

    // Copy result back from GPU Device Global Memory to Host RAM
    cudaMemcpy(h_C, d_C, bytes, cudaMemcpyDeviceToHost);

    cudaEventRecord(totalStop);
    cudaEventSynchronize(totalStop);

    float kernelTime = 0.0f;
    float totalTime = 0.0f;

    cudaEventElapsedTime(&kernelTime, kernelStart, kernelStop);
    cudaEventElapsedTime(&totalTime, totalStart, totalStop);

    printf("\nCUDA Matrix Multiplication Completed\n");
    printf("Matrix Size = %d x %d\n", N, N);
    printf("Grid Size = %d x %d blocks\n", grid.x, grid.y);
    printf("Block Size = %d x %d threads\n", block.x, block.y);
    printf("Kernel Execution Time = %.6f seconds\n", kernelTime / 1000.0f);
    printf("Total CUDA Phase Time = %.6f seconds (includes PCIe Memcpy H2D + D2H)\n", totalTime / 1000.0f);
    printf("Verification C[0][0] = %.2f (Expected: %.2f)\n", h_C[0], (float)N);

    // Free GPU device memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    // Free Host RAM
    free(h_A);
    free(h_B);
    free(h_C);

    cudaEventDestroy(totalStart);
    cudaEventDestroy(totalStop);
    cudaEventDestroy(kernelStart);
    cudaEventDestroy(kernelStop);

    return 0;
}
