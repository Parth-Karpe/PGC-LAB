#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <unistd.h>

#define N 4000

int main(int argc, char *argv[])
{
    int rank, size;
    int i, j, k;
    int rows_per_process;
    char hostname[256];

    double *A = NULL;
    double *B = NULL;
    double *C = NULL;
    double *local_A;
    double *local_C;

    double start, end;

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    gethostname(hostname, sizeof(hostname));

    if (N % size != 0)
    {
        if (rank == 0)
            printf("Error: Matrix dimension %d must be divisible by number of processes %d.\n", N, size);

        MPI_Finalize();
        return 0;
    }

    rows_per_process = N / size;

    local_A = (double *)malloc(rows_per_process * N * sizeof(double));
    local_C = (double *)malloc(rows_per_process * N * sizeof(double));
    B = (double *)malloc(N * N * sizeof(double));

    if (local_A == NULL || local_C == NULL || B == NULL)
    {
        printf("Error: Rank %d memory allocation failed!\n", rank);
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    if (rank == 0)
    {
        printf("=====================================================\n");
        printf(" MPI Distributed Matrix Multiplication               \n");
        printf(" Total Cluster Processes: %d                         \n", size);
        printf(" Matrix Size:             %d x %d                    \n", N, N);
        printf(" Rows Per Process:        %d                         \n", rows_per_process);
        printf("=====================================================\n");

        A = (double *)malloc(N * N * sizeof(double));
        C = (double *)malloc(N * N * sizeof(double));

        if (A == NULL || C == NULL)
        {
            printf("Error: Root process memory allocation failed!\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        printf("Initializing %d x %d matrices on Master (Rank 0)...\n", N, N);
        for (i = 0; i < N; i++)
        {
            for (j = 0; j < N; j++)
            {
                A[i * N + j] = 1.0;
                B[i * N + j] = 1.0;
                C[i * N + j] = 0.0;
            }
        }
    }

    // Synchronize all nodes before starting benchmark clock
    MPI_Barrier(MPI_COMM_WORLD);
    start = MPI_Wtime();

    // 1. Scatter slices of Matrix A from Rank 0 to all participating ranks
    MPI_Scatter(
        A, rows_per_process * N, MPI_DOUBLE,
        local_A, rows_per_process * N, MPI_DOUBLE,
        0, MPI_COMM_WORLD);

    // 2. Broadcast complete Matrix B to all participating ranks
    MPI_Bcast(B, N * N, MPI_DOUBLE, 0, MPI_COMM_WORLD);

    printf("Rank %d on host '%s' computing %d rows (Rows %d to %d)...\n",
           rank, hostname, rows_per_process, rank * rows_per_process, (rank + 1) * rows_per_process - 1);

    // 3. Local matrix multiplication
    for (i = 0; i < rows_per_process; i++)
    {
        for (j = 0; j < N; j++)
        {
            local_C[i * N + j] = 0.0;
            for (k = 0; k < N; k++)
            {
                local_C[i * N + j] += local_A[i * N + k] * B[k * N + j];
            }
        }
    }

    // 4. Gather local results back to root process
    MPI_Gather(
        local_C, rows_per_process * N, MPI_DOUBLE,
        C, rows_per_process * N, MPI_DOUBLE,
        0, MPI_COMM_WORLD);

    MPI_Barrier(MPI_COMM_WORLD);
    end = MPI_Wtime();

    if (rank == 0)
    {
        printf("\nMPI Matrix Multiplication Completed\n");
        printf("Matrix Size = %d x %d\n", N, N);
        printf("Number of MPI Processes = %d\n", size);
        printf("Execution Time = %f seconds\n", end - start);
        printf("Verification C[0][0] = %.2f (Expected: %.2f)\n", C[0], (double)N);

        free(A);
        free(C);
    }

    free(B);
    free(local_A);
    free(local_C);

    MPI_Finalize();
    return 0;
}
