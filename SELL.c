#include<stdio.h>
#include<stdlib.h>
#include<cuda.h>
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

void freese(int sizeX, int sizeY, double** ptr)
{
    int i;
     for (i=0;i<sizeX;i++)
        free(ptr[i]);
    free(ptr);
}

void main()
{
	
}
