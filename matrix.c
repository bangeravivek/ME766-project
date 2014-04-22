#include<stdio.h>
#include<stdlib.h>
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
    theArray[i]=0.0;
}

   return theArray;
}


void main()
{

	const int N=1000;
	const int Dsize=5000;
	FILE *arr;
	int i,j;
	int** a=Make2DIntArray(N,N);
	int* val=Make1DIntArray(Dsize);
	int* col=Make1DIntArray(Dsize);
	int* row=Make1DIntArray(Dsize);
	//int val[10],col[10],row[10];
	arr=fopen("matrix.txt","r");
	int k=0,cinrow=0;
	struct timeval start, end;
	gettimeofday(&start, NULL);
	for(i=0;i<N;i++)
	{
		for(j=0;j<N;j++)
		{
			fscanf(arr,"%d",&a[i][j]);
			if(a[i][j])
			{
				val[k]=a[i][j];
				col[k]=j;
				cinrow++;
				if(cinrow==1)
				{
					row[i]=i*3+j;
				}
				k++;
			}	
		}
	cinrow=0;
		
	}
	
	row[i]=k;
	gettimeofday(&end, NULL);

	double delta = ((end.tv_sec  - start.tv_sec) * 1000000u + 
	         end.tv_usec - start.tv_usec) / 1.e6;

	printf("\nTime spent=%f\n", delta);	
//printing val, col and row
	printf("Val=");
	for(i=0;i<Dsize;i++)
	{
		printf("%d\t",val[i]);
	}
	printf("col=");
        for(i=0;i<Dsize;i++)
        {
                printf("%d\t",col[i]);
        }
	printf("row=");
	for(i=0;i<Dsize;i++)
        {
                printf("%d\t",row[i]);
        }




}

