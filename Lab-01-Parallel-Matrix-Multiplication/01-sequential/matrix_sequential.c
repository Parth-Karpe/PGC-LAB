#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 4000

int main()
{
    int i, j, k;
    double *A, *B, *C;
    clock_t start, end;

    printf("=====================================================\n");
    printf(" Sequential Matrix Multiplication (Baseline CPU)     \n");
    printf(" Matrix Dimensions: %d x %d                           \n", N, N);
    printf(" Memory Required:   %.2f MB per matrix (Total: %.2f MB)\n", 
           (N * N * sizeof(double)) / (1024.0 * 1024.0),
           (3.0 * N * N * sizeof(double)) / (1024.0 * 1024.0));
    printf("=====================================================\n");

    A = (double *)malloc(N * N * sizeof(double));
    B = (double *)malloc(N * N * sizeof(double));
    C = (double *)malloc(N * N * sizeof(double));

    if (A == NULL || B == NULL || C == NULL)
    {
        printf("Error: Memory allocation failed!\n");
        return 1;
    }

    printf("Initializing %d x %d matrices...\n", N, N);

    for (i = 0; i < N; i++)
    {
        for (j = 0; j < N; j++)
        {
            A[i * N + j] = 1.0;
            B[i * N + j] = 1.0;
            C[i * N + j] = 0.0;
        }
    }

    printf("Starting computation...\n");
    start = clock();

    for (i = 0; i < N; i++)
    {
        for (j = 0; j < N; j++)
        {
            for (k = 0; k < N; k++)
            {
                C[i * N + j] += A[i * N + k] * B[k * N + j];
            }
        }
    }

    end = clock();

    printf("\nSequential Matrix Multiplication Completed\n");
    printf("Matrix Size = %d x %d\n", N, N);
    printf("Execution Time = %f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);
    printf("Verification C[0][0] = %.2f (Expected: %.2f)\n", C[0], (double)N);

    free(A);
    free(B);
    free(C);

    return 0;
}
