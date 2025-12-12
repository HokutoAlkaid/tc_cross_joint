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
#  para.txt the parameter file
#--
paraf="para.txt"
para=np.loadtxt(paraf)
wts=para[0]
sigmat=para[1]
sigmag=para[2]
ns=para[3]
ng=para[4]

resf1="res_surf.dat"
res1=np.loadtxt(resf1)
nn1=res1.shape[0]
sumrs=0.0
for i in range(nn1):
    sumrs=sumrs+(res1[i,2]-res1[i,1])**2
sumrs=sumrs*wts/(ns*sigmat**2)


resf2="res_grav.dat"
res2=np.loadtxt(resf2)
nn2=res2.shape[0]
sumrg=0.0
for i in range(nn2):
    sumrg=sumrg+(res2[i,1]-res2[i,0])**2
sumrg=sumrg*(1.0-wts)/(ng*sigmag**2)

os.system('rm resi.txt')
f1 = open("resi.txt","w")
f1.write("%10.3f %10.3f %10.3f \n"%(sumrs,sumrg,sumrs+sumrg))
f1.close()


