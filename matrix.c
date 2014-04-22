#include<stdio.h>
#include<stdlib.h>
#include<time.h>
void main()
{

	FILE *arr;
	int a[3][3],i,j;
	int val[10],col[10],row[10];
	arr=fopen("matrix.txt","r");
	int k=0,cinrow=0;
	struct timeval start, end;
	gettimeofday(&start, NULL);
	for(i=0;i<3;i++)
	{
		for(j=0;j<3;j++)
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
	for(i=0;i<k;i++)
	{
		printf("%d\t",val[i]);
	}
	printf("col=");
        for(i=0;i<k;i++)
        {
                printf("%d\t",col[i]);
        }
	printf("row=");
	for(i=0;i<4;i++)
        {
                printf("%d\t",row[i]);
        }




}

