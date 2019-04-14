#include <stdlib.h>
#include <stdio.h>
#include <cuda.h>

typedef struct {
	float r;
	float g;
	float b;
} pixel;



int main(int argc, char const *argv[]){

	// L: image number, M y N: image shape
	int l, m, n;

	// read firts three importand values
	scanf("%d %d %d", &l, &m, &n);
	

	for(int j=0; j < l; j++){ // iteration for the L images
		for(int i=0; i < m*n; i++){ // iteration for the line with m*n float values
			float aux;
			scanf("%f", &aux); 
			printf("%f",aux );
		}
	}


	return 0;
}