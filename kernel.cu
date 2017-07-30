
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>


const int ARRAY_SIZE = 64;

__global__ void square(float * d_out, float * d_in) {
	int idx = threadIdx.x;
	float f = d_in[idx];
	d_out[idx] = f*f;

}


void gpuCode() {
	
	const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

	float h_in[ARRAY_SIZE];
	for (int i = 0; i < ARRAY_SIZE; i++) {
		h_in[i] = float(i);
	}

	float h_out[ARRAY_SIZE];

	float * d_in;	// input array on GPU
	float * d_out;	// output array on GPU

	//allocate memory on GPU
	cudaMalloc((void **)&d_in, ARRAY_BYTES);
	cudaMalloc((void**)&d_out, ARRAY_BYTES);

	//copy input data from CPU to GPU
	cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);

	//execute calculation on GPU
	square << <1, ARRAY_SIZE >> >  (d_out, d_in); 
												  
	cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);
}

int main(int argc,char** argv)
{
	gpuCode();
    return 0;
}

