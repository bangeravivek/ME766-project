#Script to generate a random sparse matrix

from random import randint

f=open('matrix.txt','wt')
#X=randint(100,1000)
#W=randint(100,1000)
for i in range(0,1000):
	for j in range(0,1000):
		Y=randint(1,100)
		if Y>95:
			Z=str(randint(1,100))
			f.write(Z+' ')
			#f.write(' ')
		else:
			f.write('0 ')
	f.write("\n")
	
	
