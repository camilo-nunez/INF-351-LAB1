#include <stdio.h>
#include <iostream>
#include <time.h>
#include <cuda_runtime.h>

__global__ void ponderacion(double *input, double *output, int n, int l) {
    for (int i = 0; i < n; i++) output[i] = input[i]/l;
}

/*
 *  Escritura Archivo
 */
void Write(double* R, double* G, double* B, 
           int M, int N, const char *filename) {
    FILE *fp;
    fp = fopen(filename, "w");
    fprintf(fp, "%d %d\n", M, N);
    for(int i = 0; i < M*N-1; i++)
        fprintf(fp, "%f ", R[i]);
    fprintf(fp, "%lf\n", R[M*N-1]);
    for(int i = 0; i < M*N-1; i++)
        fprintf(fp, "%f ", G[i]);
    fprintf(fp, "%lf\n", G[M*N-1]);
    for(int i = 0; i < M*N-1; i++)
        fprintf(fp, "%f ", B[i]);
    fprintf(fp, "%lf\n", B[M*N-1]);
    fclose(fp);
}

int main(int argc, char*argv[]) {

    // L: image number, M y N: image shape
    int l, m, n;

    // read firts three importand values
    scanf("%d %d %d", &l, &m, &n);

    int size = m*n;

    double* RhInput = (double*)calloc(size,sizeof(double));
    double* RhOutput = (double*)calloc(size,sizeof(double));

    double* GhInput = (double*)calloc(size,sizeof(double));
    double* GhOutput = (double*)calloc(size,sizeof(double));

    double* BhInput = (double*)calloc(size,sizeof(double));
    double* BhOutput = (double*)calloc(size,sizeof(double));

    int pass=1;

    for(int j=0; j < l; j++){ // iteration for the L images COLOR
        if(pass==1){
            for(int i=0; i < m*n; i++){ // iteration for the line with m*n double values // COLOR R
            double aux;
            scanf("%lf", &aux);
            RhInput[i]= RhInput[i] + aux;
            }
            pass++;
        }else if (pass==2){
            for(int i=0; i < m*n; i++){ // iteration for the line with m*n double values // COLOR G
            double aux;
            scanf("%lf", &aux);
            GhInput[i]= GhInput[i] + aux;
            }
            pass++;
        }else if (pass==3){
            for(int i=0; i < m*n; i++){ // iteration for the line with m*n double values // COLOR B
            double aux;
            scanf("%lf", &aux);
            BhInput[i]= BhInput[i] + aux;
            }
            pass=1;
        }
    

    }

    double* RdInput = NULL, *RdOutput = NULL; // COLOR R
    double* GdInput = NULL, *GdOutput = NULL; // COLOR G
    double* BdInput = NULL, *BdOutput = NULL; // COLOR B


    cudaMalloc((void**)&RdInput, sizeof(double)*size);
    cudaMalloc((void**)&RdOutput, sizeof(double)*size);

    cudaMalloc((void**)&GdInput, sizeof(double)*size);
    cudaMalloc((void**)&GdOutput, sizeof(double)*size);

    cudaMalloc((void**)&BdInput, sizeof(double)*size);
    cudaMalloc((void**)&BdOutput, sizeof(double)*size);


    cudaMemcpy(RdInput, RhInput, sizeof(double)*size, cudaMemcpyHostToDevice);
    cudaMemcpy(GdInput, GhInput, sizeof(double)*size, cudaMemcpyHostToDevice);
    cudaMemcpy(BdInput, BhInput, sizeof(double)*size, cudaMemcpyHostToDevice);

    ponderacion<<<1,size>>>(RdInput, RdOutput, size, l);
    ponderacion<<<1,size>>>(GdInput, GdOutput, size, l);
    ponderacion<<<1,size>>>(BdInput, BdOutput, size, l);

    cudaMemcpy(RhOutput, RdOutput, sizeof(double)*size, cudaMemcpyDeviceToHost);
    cudaMemcpy(GhOutput, GdOutput, sizeof(double)*size, cudaMemcpyDeviceToHost);
    cudaMemcpy(BhOutput, BdOutput, sizeof(double)*size, cudaMemcpyDeviceToHost);


    /*
    printf("\nOutput Color R = ");
    for (int i = 0; i < size; i++) {
        printf("%f\t",RhOutput[i]);
    }

    printf("\nOutput Color G = ");
    for (int i = 0; i < size; i++) {
        printf("%f\t",GhOutput[i]);
    }

    printf("\nOutput Color B = ");
    for (int i = 0; i < size; i++) {
        printf("%f\t",BhOutput[i]);
    }
    */

    Write(RhOutput, GhOutput, BhOutput, m, n, "imgGPU.txt");

    free(RhInput);
    free(RhOutput);
    free(GhInput);
    free(GhOutput);
    free(BhInput);
    free(BhOutput);

    cudaFree(RdInput);
    cudaFree(RdOutput);
    cudaFree(GdInput);
    cudaFree(GdOutput);
    cudaFree(BdInput);
    cudaFree(BdOutput);

    printf("\n");
    printf("\n");

    return 0;
}