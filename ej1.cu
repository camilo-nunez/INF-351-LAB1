#include <stdio.h>


__global__ void ponderacion(float *output, int n, int l) {
    for (int i = 0; i < n; i++) output[i] = output[i]/l;
}

int main(int argc, char*argv[]) {

    // L: image number, M y N: image shape
    int l, m, n;

    // read firts three importand values
    scanf("%d %d %d", &l, &m, &n);

    //
    int size = m*n;

    float* RhInput = (float*)calloc(size,sizeof(float));
    float* RhOutput = (float*)calloc(size,sizeof(float));

    float* GhInput = (float*)calloc(size,sizeof(float));
    float* GhOutput = (float*)calloc(size,sizeof(float));

    float* BhInput = (float*)calloc(size,sizeof(float));
    float* BhOutput = (float*)calloc(size,sizeof(float));

    int pass=1;

    for(int j=0; j < l; j++){ // iteration for the L images COLOR
        if(pass==1){
            for(int i=0; i < m*n; i++){ // iteration for the line with m*n float values // COLOR R
            float aux;
            scanf("%f", &aux);
            RhInput[i]= RhInput[i] + aux;
            }
            pass++;
        }else if (pass==2){
            for(int i=0; i < m*n; i++){ // iteration for the line with m*n float values // COLOR G
            float aux;
            scanf("%f", &aux);
            GhInput[i]= GhInput[i] + aux;
            }
            pass++;
        }else if (pass==3){
            for(int i=0; i < m*n; i++){ // iteration for the line with m*n float values // COLOR B
            float aux;
            scanf("%f", &aux);
            BhInput[i]= BhInput[i] + aux;
            }
            pass=1;
        }
    

    }

    float* RdInput = NULL, *RdOutput = NULL; // COLOR R
    float* GdInput = NULL, *GdOutput = NULL; // COLOR G
    float* BdInput = NULL, *BdOutput = NULL; // COLOR B


    cudaMalloc((void**)&RdInput, sizeof(float)*size);
    cudaMalloc((void**)&RdOutput, sizeof(float)*size);

    cudaMalloc((void**)&GdInput, sizeof(float)*size);
    cudaMalloc((void**)&GdOutput, sizeof(float)*size);

    cudaMalloc((void**)&BdInput, sizeof(float)*size);
    cudaMalloc((void**)&BdOutput, sizeof(float)*size);


    cudaMemcpy(RdInput, RhInput, sizeof(float)*size, cudaMemcpyHostToDevice);
    cudaMemcpy(GdInput, GhInput, sizeof(float)*size, cudaMemcpyHostToDevice);
    cudaMemcpy(BdInput, BhInput, sizeof(float)*size, cudaMemcpyHostToDevice);

    ponderacion<<<1,l>>>(RdOutput, size, l);
    ponderacion<<<1,l>>>(GdOutput, size, l);
    ponderacion<<<1,l>>>(BdOutput, size, l);

    cudaMemcpy(RhOutput, RdOutput, sizeof(float)*size, cudaMemcpyDeviceToHost);
    cudaMemcpy(GhOutput, GdOutput, sizeof(float)*size, cudaMemcpyDeviceToHost);
    cudaMemcpy(BhOutput, BdOutput, sizeof(float)*size, cudaMemcpyDeviceToHost);


    printf("\nInput Color R = ");
    for (int i = 0; i < size; i++) {
        printf("%f\t",RhInput[i]);
    }

    printf("\nOutput Color R = ");
    for (int i = 0; i < size; i++) {
        printf("%f\t",RhOutput[i]);
    }

    printf("\nInput Color G = ");
    for (int i = 0; i < size; i++) {
        printf("%f\t",GhInput[i]);
    }

    printf("\nOutput Color G = ");
    for (int i = 0; i < size; i++) {
        printf("%f\t",GhOutput[i]);
    }

    printf("\nInput Color B = ");
    for (int i = 0; i < size; i++) {
        printf("%f\t",BhInput[i]);
    }

    printf("\nOutput Color B = ");
    for (int i = 0; i < size; i++) {
        printf("%f\t",BhOutput[i]);
    }

    printf("\n");
    printf("\n");

    return 0;
}