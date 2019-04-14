#define N 512
__globar__ void add(int *a, int *b, int *c){
    c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

int main(void){
    int *a, *b, *c;
    int *d_a, *d_b, *d_c;
    int size = N * sizeof(int);
    

    cudaMalloc((void **)&d_a, size);
    cuda Malloc((void **)&d_b, size);
    cuda Malloc((void **)&d_c, size);
    
    a = (int *)malloc(size); random_ints(a, N);
    b = (int *)malloc(size); random_ints(a, N);
    c = (int *)malloc(size);
    
    printf("value of \'a\': %d", &a);
    prinf("value of \'b\': %d", &b);
    

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
    
    add<<<N, 1>>>(d_a, d_b, d_c);
    

    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
    print("Result: c = %d",c);
    //Cleanup
    free(a); free(b); free(c);
    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
    return 0;
}