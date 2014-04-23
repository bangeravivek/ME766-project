#include<stdio.h>
#include<stdlib.h>
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


void main()
{

	const int N=6;
	const int Dsize=50;
	FILE *arr;
	int i,j;
	int** a=Make2DIntArray(N,N);
	int* val=Make1DIntArray(Dsize);
	int* col=Make1DIntArray(Dsize);
	int* row=Make1DIntArray(Dsize);
	//int val[10],col[10],row[10];
	arr=fopen("mat.txt","r");
	int k=0,cinrow=0;
	struct timeval start, end;
	gettimeofday(&start, NULL);
	row[0]=0;
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
				k++;
			}	
			
		}
	printf("\n no of elements in row %d is %d\n",i,cinrow);
	row[i+1]=row[i]+cinrow;
	cinrow=0;
		
	}

	row[i]=k;
       	printf("\n k = %d\n ", k);
       	//sleep(10);
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
        printf("\n");





}

