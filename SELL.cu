#include<stdio.h>
#include<stdlib.h>
#include<cuda.h>
#include<unistd.h>
#include<time.h>

__global__ void multiply(int *vec, int *mat, int *out, const int N, const int M)
{
	int tid=threadIdx.x+blockIdx.x*blockDim.x;
        int sum=0;
        
	if(tid<M)
	{
        	for(int i=0; i<N; i++)
        	{	
        		sum += vec[i]*mat[(tid*M)+i];
        	}
        	
   	}
   	out[tid]=sum;
}

__global__ void printmatscreen(int* mat, int N)
{
	int i,j;
	for (i=0;i<N;i++)
	{	
		printf("\n");
		for (j=0;j<N;j++)
		{
			printf("%d ",mat[(i*N)+j]);
		}
	}
	printf("\n");
}


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

int** Make2DVariableIntArray(int rows, int blocks, int blocksize, int* columns)
{
int** theArray;
theArray = (int**) malloc(rows*sizeof(int*));
int i, j, k;
for (i = 0; i < blocks; i++)
{
	k=columns[i];
	for (j=0; j < blocksize; j++)
	{
		theArray[i*blocksize+j] = (int*) malloc(k*sizeof(int));
	}
   
}
//int j;

for (i=0;i<blocks;i++)
{
    for (j=0;j<blocksize;j++)
    {
    	for (k=0;k<columns[i];k++)
	{
	        theArray[i*blocksize+j][k]=0;
    	}
    }
}

   return theArray;
}

int** Changeto2DVariableIntArray(int** theArray,int rows, int blocks, int blocksize, int* columns)
{

int** NewArray=Make2DVariableIntArray(rows,blocks,blocksize,columns);
int i, j, k;

for (i=0;i<blocks;i++)
{
    for (j=0;j<blocksize;j++)
    {
        for (k=0;k<columns[i];k++)
        {
                NewArray[i*blocksize+j][k]=theArray[i*blocksize+j][k];
        }
    }
}
printf("changed to multiple matrixes");
   return NewArray;
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

void printmat(int** matrix, int N, int Nj)
{
	int i,j;
	
	for (i=0;i<N;i++)
	{	
		printf("\n");
		for (j=0;j<N;j++)
		{
			printf("%d ",matrix[i][j]);
		}
	}
	printf("\n");
}

void printtofile(int** matrix, int K, char* filename)
{
	/*
	Prints original 2D matrices to file
	*/
	FILE *fp;
	fp=fopen(filename,"wt");
	int i,j;
	for (i=0;i<K;i++)
	{
		fprintf(fp, "\n");
		for (j=0;j<K;j++)
		{
			fprintf(fp, "%d\t", matrix[i][j]);
		}
	}
}

void printtofile1D(int* matrix, int K, char* filename)
{
	/*
	Prints resultant matrix to a file
	*/
	FILE *fp;
	fp=fopen(filename,"wt");
	int i,j;
	int counters=0;
	for (i=0;i<K;i++)
	{
		fprintf(fp, "\n");
		for (j=0;j<K;j++)
		{
			fprintf(fp, "%d \t", matrix[counters]);
			counters++;
		}
	}
}

int* Make1DIntArray(int arraySizeX)
{
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

void main()
{
	int N=100;
	
//	const int Dsize=1000;
	FILE *arr, *vec;
	int i,j,maxrowwidth=0,tint=0;
	int** a=Make2DIntArray(N,N);
//	int* val=Make1DIntArray(Dsize);
//	int* col=Make1DIntArray(Dsize);
//	int* row=Make1DIntArray(Dsize);
	int* result=Make1DIntArray(N);
	int* vecX=Make1DIntArray(N);
	int** scval=Make2DIntArray(N,N);    //sell c value
	int** sccol=Make2DIntArray(N,N);	//sell c col
	int* rowwidth=Make1DIntArray(N);	//number of elements in each row
	int* temp=Make1DIntArray(N);
	int *dev_a, *dev_b, *dev_c, *dev_d;
	
	//int val[10],col[10],row[10];
	arr=fopen("matrix100.txt","r");
	int k=0,cinrow=0;
	struct timeval start, end;
	gettimeofday(&start, NULL);
	
	
	//Reading the vector
	
	vec=fopen("vector100.txt","r");
	for (i=0;i<N;i++)
	{
		fscanf(vec,"%d",&vecX[i]);
	}
	
	//Reading the matrix
	
	for(i=0;i<N;i++)
	{	
		printf("\n");
		for(j=0;j<N;j++)
		{
			fscanf(arr,"%d",&a[i][j]);
			printf("%d ",a[i][j]);
		}
	}
	printf("\n");
	//row[i]=k;
       	//printf("\n k = %d\n ", k);
       	//sleep(10);
	gettimeofday(&end, NULL);

	double delta = ((end.tv_sec  - start.tv_sec) * 1000000u + 
	         end.tv_usec - start.tv_usec) / 1.e6;

	printf("\nTime spent=%f\n", delta);	

	
	for(i=0;i<N;i++)
	{
		for(j=0;j<N;j++)
		{	
			if(a[i][j]!=0)
			{
				scval[i][k]=a[i][j];
				//printf("\n scval[%d][%d]=%d",i,k,scval[i][k]);

				//sleep(1);
				sccol[i][k]=j;
				//printf("\n sccol[%d][%d]=%d",i,k,sccol[i][k]);
				rowwidth[i]=k+1;
				if(rowwidth[i]>maxrowwidth)
				{	//printf("\nrow[%d] width=%d\n",i,maxrowwidth);
					maxrowwidth=rowwidth[i];
				}k++;
			}
				
		}
		//printf("\nRow width %d = %d", i, rowwidth[i]);
		k=0;
	}
	
	
	for(i=0;i<N-1;i++)
	{
	for(j=0;j<N-1;j++)
	{
		if(rowwidth[j]<rowwidth[j+1])
		{	/*printf("\nrow %d width=%d",j,rowwidth[j]);
			printf("\nscval[%d]=",j);
			for(k=0;k<rowwidth[j];k++)
			{
				printf("%d ", scval[j][k]);
			}
			printf("\nscval[%d]=",j+1);
			for(k=0;k<rowwidth[j+1];k++)
			{
				printf("%d ", scval[j+1][k]);
			}
			*/
			temp=scval[j];	
			scval[j]=scval[j+1];
			scval[j+1]=temp;
			temp=sccol[j];
			sccol[j]=sccol[j+1];
			sccol[j+1]=temp;
			tint=rowwidth[j];
			rowwidth[j]=rowwidth[j+1];
			rowwidth[j+1]=tint;
			tint=vecX[j];
			vecX[j]=vecX[j+1];
			vecX[j+1]=tint;
		}
	}
	}	
	
	for(i=0;i<N;i++)
	{
		if(scval[i][0]==0)
		{
			break;	
		}	
	}
	N=i;
		
	printf("\nmaxrowwidth=%d\n",maxrowwidth);
	printmat(scval,N,N);
//	printtofile(scval,N,"scval.txt");
//	printtofile(sccol,N,"sccol.txt");
	printf("\n Vector is:\n");
	for (i=0;i<N;i++)
	{
		printf("%d\n",vecX[i]);
	}
	

        
        //printmatscreen<<<1,1>>>(dev_b,N);
	multiply<<<N,N>>>(dev_a, dev_b, dev_c, N, N);
	
	cudaMemcpy(result, dev_c, sizeof(int)*N, cudaMemcpyDeviceToHost);

        for (i=0;i<N;i++)
        {
        	printf("\n%d",result[i]);
        }
        
        cudaFree(dev_a);
        cudaFree(dev_b);
        cudaFree(dev_c);
	
	// NEED TO FIGURE OUT A WAY TO POPULATE cols SO AS TO HAVE varmat CREATED PROPERLY. SYSTEM CRASHES OTHERWISE
	
	int c=2;
	int* cols=Make1DIntArray(N/c);
	j=0;
	int colsum=0;
	for(i=0;i<N;i=i+c)
	{
		cols[j]=rowwidth[i];
		colsum+=cols[j];
		j++;
	}
	
	int** varscval=Changeto2DVariableIntArray(scval,N,N/c,c,cols);
	int** varsccol=Changeto2DVariableIntArray(sccol,N,N/c,c,cols);
	for (i=0;i<N/c;i++)
	{
		for(j=0;j<c;j++)
		{
			printf("\n");
			for (k=0;k<cols[i];k++)
			{
				printf("%d ",varscval[i*c+j][k]);
				printf("%d ",varsccol[i*c+j][k]);
				
			}
		}
	}
	int varsize=colsum*c;
	
	cudaMalloc((void**)&dev_vec, sizeof(int)*N);
        cudaMalloc((void**)&dev_scval_flat, sizeof(int)*varsize);
        cudaMalloc((void**)&dev_result, sizeof(int)*N);
        cudaMalloc((void**)&dev_sccol_flat, sizeof(int)*varsize);	
		
	cudaMemcpy(dev_a, vecX, sizeof(int)*N, cudaMemcpyHostToDevice);
        cudaMemcpy(dev_b, varscval, sizeof(int)*varsize, cudaMemcpyHostToDevice);
        cudaMemcpy(dev_c, result, sizeof(int)*N, cudaMemcpyHostToDevice);
        cudaMemcpy(dev_d, varsccol, sizeof(int)*varsize, cudaMemcpyHostToDevice);
	
}


        
        


