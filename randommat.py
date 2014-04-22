#Script to generate a random sparse matrix

from random import randint

f=open('matrix.txt','wt')
X=randint(100,1000)
for i in range(0,X):
	for j in range(0,X):
		Y=randint(1,100)
		if Y>85:
			Z=str(randint(1,100))
			f.write(Z+' ')
			#f.write(' ')
		else:
			f.write('0 ')
	f.write("\n")
	
	
