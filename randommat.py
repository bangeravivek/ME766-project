#Script to generate a random sparse matrix

from random import randint

f=open('matrix10000.txt','wt')
g=open('vector10000.txt','wt')
count=0
#X=randint(100,1000)
#W=randint(100,1000)
for i in range(0,10000):
	for j in range(0,10000):
		Y=randint(0,100)
		if Y>95: 
			Z=str(randint(0,100))
			f.write(Z+' ')
			#f.write(' ')
			count+=1
		else:
			f.write('0 ');
	f.write("\n")

for i in range(0,10000):
	g.write(str(randint(0,100)))
	g.write("\n")
	
	
	
