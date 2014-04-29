#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<time.h>
#include<cuda.h>
/*
__global__ void multiply(int *val, int *vec, int *result, int *cols, int *rowptr)
{
	int tid=threadIdx.x+blockIdx.x*blockDim.x;
        int sum=0;
        int i;
        for(i=0;i<cols[colidx];i++)
	{	

		sum += vec[rowptr[tid]+i]*val[rowptr[tid]+i];

	}
     	__syncthreads();
   	result[tid]=sum;
}

__global__ void printmatscreen(int* mat, int N)
{
	int i;
	for (i=0;i<N;i++)
	{	
		printf("%d ",mat[i]);
		
	}
	printf("\n");
}
*/
int** Make2DIntArray(int arraySizeX, int arraySizeY)
{
	int** theArray;
	theArray = (int**) malloc(arraySizeX*sizeof(int*));
	int i;
	for (i = 0; i < arraySizeX; i++)
  	 theArray[i] = (int*) malloc(arraySizeY*sizeof(int));
	int j;

	for (i=0;i<arraySizeX;i++)
	{
    	for (j=0;j<arraySizeY;j++)
    	{
       	 theArray[i][j]=0;
    	}
}

   return theArray;
}

void init_zeros(int** matrix, int N)
{
	int i,j;
	for (i=0;i<N;i++)
	{	
		for (j=0;j<N;j++)
		{
			matrix[i][j]=0;
		}
	}
}

void printmat(int** matrix, int N)
{
	int i,j;
	
	for (i=0;i<N;i++)
	{	
		printf("\n");
		for (j=0;j<N;j++)
		{
			printf("%d \t",matrix[i][j]);
		}
	}
	printf("\n");
}


int* Make1DIntArray(int arraySizeX) {
int* theArray;
theArray = (int*)malloc(arraySizeX*sizeof(int));
int i;
for (i=0;i<arraySizeX;i++)
{
    theArray[i]=0;
}

   return theArray;
}

void freese(int sizeX, int sizeY, double** ptr)
{
    int i;
     for (i=0;i<sizeX;i++)
        free(ptr[i]);
    free(ptr);
}

void printtofile1D(int* matrix, int K, char* filename)
{
	/*
	Prints resultant matrix to a file
	*/
	FILE *fp;
	fp=fopen(filename,"wt");
	int i;
	
	for (i=0;i<K;i++)
	{
		fprintf(fp, "%d\n", matrix[i]);
		
	}
	
}

int main()
{

	const int N=10000;

	FILE *arr, *vec;
	int i,j;
	int** a=Make2DIntArray(N,N);
	
	int* result=Make1DIntArray(N);
	int* vecX=Make1DIntArray(N);
	//int val[10],col[10],row[10];
	int* resultsordered=Make1DIntArray(N);
	
//	int sig=4,c=2;
//	int* rowwidth=Make1DIntArray(N);
//	int *dev_vec, *dev_scval, *dev_result, *dev_sccol, *dev_cols, *dev_rowptr;
	
	arr=fopen("matrix10000.txt","r");
	int k=0,cinrow=0;

	//row[0]=0;
	for(i=0;i<N;i++)
	{
		for(j=0;j<N;j++)
		{
			fscanf(arr,"%d",&a[i][j]);
			if(a[i][j])
			{
				k++;
			}	
			
		}
		cinrow=0;
		
	}

	
	int Dsize=k;
	int* val=Make1DIntArray(Dsize);
	int* col=Make1DIntArray(Dsize);
	int* row=Make1DIntArray(N+1);
       	printf("\n k = %d\n ", k);
       	//sleep(10);
       	
k=0;
	row[0]=0;
	for(i=0;i<N;i++)
	{
		for(j=0;j<N;j++)
		{
			if(a[i][j])
			{
				val[k]=a[i][j];
				col[k]=j;
				cinrow++;
				k++;
				
			}	
			
		}
		row[i+1]=row[i]+cinrow;
		cinrow=0;
		
	}
//	sleep(5);
	row[i]=k;

	vec=fopen("vector10000.txt","r");
	for (i=0;i<N;i++)
	{
		fscanf(vec,"%d",&vecX[i]);
	
	
			
		
	}
	

	
	
	/*printf("\n Vector is:\n");
	for (i=0;i<N;i++)
	{
		printf("%d\n",vecX[i]);
	}
//printing val, col and row
	/*
	printf("Val=");
	for(i=0;i<Dsize;i++)
	{
		printf("%d\t",val[i]);
	}
	printf("\n");
	
	printf("col=");
        for(i=0;i<Dsize;i++)
        {
                printf("%d\t",col[i]);
        }
        printf("\n");
	printf("row=");
	for(i=0;i<k;i++)
        {
                printf("%d\t",row[i]);
        }
        */
        printf("\n");


        /*Now the actual multiplication kernel*/
        
	/*struct timeval start, end;
	gettimeofday(&start, NULL);        
	*/
	
	cudaEvent_t start_kernel, stop_kernel;
	float time_kernel;
	cudaEventCreate(&start_kernel);
	cudaEventCreate(&stop_kernel);
	
	cudaEventRecord(start_kernel,0);
	
       	for (i=0;i<N;i++)
        {
        	for (j=row[i];j<row[i+1];j++)
        	{ 	
        		result[i]+=val[j]*vecX[col[j]];
        		
        	}
       	}

	cudaEventRecord(stop_kernel,0);




/*	gettimeofday(&end, NULL);

	double delta = ((end.tv_sec  - start.tv_sec) * 1000000u + 
	         end.tv_usec - start.tv_usec) / 1.e6;

	printf("\nTime spent=%f\n", delta);	

*/	cudaEventSynchronize(stop_kernel);

//	multiply<<<N,1>>>(val, vecX, result, col, row);

	cudaEventElapsedTime(&time_kernel, start_kernel, stop_kernel);
	
	printf("\nTime for kernel without data transfer = %f ms \n", time_kernel); 
	
	printtofile1D(result,N,"results.txt");

/*	printf("\n Result is:\n");
	for (i=0;i<N;i++)
	{
		printf("%d\n",result[i]);
	}      
*/
	return 0;

}

