#Script to generate a random sparse matrix

from random import randint

f=open('matrix.txt','wt')
g=open('vector.txt','wt')
count=0
#X=randint(100,1000)
#W=randint(100,1000)
for i in range(0,1000):
	for j in range(0,1000):
		Y=randint(0,100)
		if Y>99 and count<10000:
			Z=str(randint(0,100))
			f.write(Z+' ')
			#f.write(' ')
			count+=1
		else:
			f.write('0 ');
	f.write("\n")

for i in range(0,1000):
	g.write(str(randint(0,100)))
	g.write("\n")
	
	
	
