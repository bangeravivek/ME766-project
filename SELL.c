#include<stdio.h>
#include<stdlib.h>
//#include<cuda.h>
#include<unistd.h>
#include<time.h>

int** Make2DIntArray(int arraySizeX, int arraySizeY) {
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

int** Make2DVariableIntArray(int rows, int blocks, int blocksize, int* columns) {
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
		for (j=0;j<Nj;j++)
		{
			printf("%d ",matrix[i][j]);
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

void main()
{
	const int N=6;
	
	const int Dsize=50;
	FILE *arr, *vec;
	int i,j,maxrowwidth;
	int** a=Make2DIntArray(N,N);
	int* val=Make1DIntArray(Dsize);
	int* col=Make1DIntArray(Dsize);
	int* row=Make1DIntArray(Dsize);
	int* result=Make1DIntArray(N);
	int* vecX=Make1DIntArray(N);
	int** scval=Make2DIntArray(N,N);    //sell c value
	int** sccol=Make2DIntArray(N,N);	//sell c col
	int* rowwidth=Make1DIntArray(N);	//number of elements in each row

	//int val[10],col[10],row[10];
	arr=fopen("mat.txt","r");
	int k=0,cinrow=0;
	struct timeval start, end;
	gettimeofday(&start, NULL);
	row[0]=0;
	
	//Reading the vector
	
	vec=fopen("vec.txt","r");
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
				sccol[i][k]=j;
				rowwidth[i]=k+1;
				if(rowwidth[i]>maxrowwidth)
					maxrowwidth=rowwidth[i];
				k++;
			}
		}
		k=0;
	}
		
	printf("\nmaxrowwidth=%d\n",maxrowwidth);				
	printmat(scval,N,maxrowwidth);
	 printmat(sccol,N,maxrowwidth);
	printf("\n Vector is:\n");
	for (i=0;i<N;i++)
	{
		printf("%d\n",vecX[i]);
	}
	
	int cols[6]={8,6,5,9,10,12};
	int** varmat=Make2DVariableIntArray(30,6,5,cols);
	
	for (i=0;i<6;i++)
	{
		for(j=0;j<5;j++)
		{
			printf("\n");
			for (k=0;k<cols[i];k++)
			{
				printf("%d ",varmat[i*5+j][k]);
			}
		}
	}
	printf("\n");
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
	for(i=0;i<Dsize;i++)
        {
                printf("%d\t",row[i]);
        }
        */
        printf("\n");


        /*Now the actual multiplication kernel
        for (i=0;i<N;i++)
        {
        	for (j=row[i];j<row[i+1];j++)
        	{
        		result[i]+=val[j]*vecX[col[j]];
        	}
       	}
	printf("\n Result is:\n");
	for (i=0;i<N;i++)
	{
		printf("%d\n",result[i]);
	}      
	*/
        
        

}
