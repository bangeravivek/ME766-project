#include<stdio.h>
void main()
{

	FILE *arr;
	int a[3][3],i,j;
	int val[10],col[10],row[10];
	arr=fopen("mat.txt","r");
	int k=0,cinrow=0;
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

