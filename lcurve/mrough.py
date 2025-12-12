#---
#   This script is used to calculate the model roughtness.
#   Author:: Haopeng Chen  from HUST
#   Creatied time :: 2021.12.27 12:40
#---
import os
import numpy as np 
import matplotlib.pyplot as plt
from numpy import sin


#--
#  mod0.dat is the inital model
#  mod1.dat is the final model
#--
modfile0="mod0.dat"
mod0=np.loadtxt(modfile0)

modfile1="mod1.dat"
mod1=np.loadtxt(modfile1)

nn0=mod0.shape[0]
nn1=mod1.shape[0]
if nn0 != nn1:
   print('Warning: These two files donot have the same length')
else:
   print('They have the same length')

summ=0.0
for i in range(nn0):
    mod1[i,3] = mod1[i,3]-mod0[i,3]
    summ=summ+mod1[i,3]**2

os.system('rm mrough.txt')
f1 = open("mrough.txt","w")
f1.write("%10.3f \n"%(summ))
f1.close()

os.system('rm mod2.dat')
f = open("mod2.dat","w")
for i in range(nn0):
    f.write("%6.1f %6.1f %4d %8.5f \n"%(mod1[i,0],mod1[i,1],mod1[i,2],mod1[i,3]))
f.close()

