#---
#   This script is used to creat the inital model in Yunnan region.
#   it is modifed from the script "generate_checkerboard.py" written by Nanqiao Du.
#   Author:: Haopeng Chen  from HUST
#   Creatied time :: 2020.12.27 12:40
#---
import os
import numpy as np 
import matplotlib.pyplot as plt
from numpy import sin

#--
#  nz is the points in the depth direction, the number is actually 21.
#  nx is the points along the latitude (from north to south)
#  ny is the points along the longitude (from west to east)
#--
#nz=17
nx=21
ny=21
dx = 0.25
dy = 0.25
lat = 27.0 - np.arange(nx) * dx
lon = 97.0 + np.arange(ny) * dy

dep = np.array([0.0,2.0,4.0,6.0,8.0,10.0,15.0,20.0,25.0,30.0,35.0,40.0])                
nz=dep.shape[0]
vsref=np.zeros((nz))

#--
#  read the initial model. The average model of YGADaWan region.
#  format :: 
#  layer_thickness  vs_velocity
#  depmod is the depth of each layer.
#--
modfile="scsavemod.txt"
mod=np.loadtxt(modfile)
nmod=mod.shape[0]
depmod=np.zeros((nmod+1))
depmod[0]=0.0
for i in range(1,nmod+1):
    aa=mod[:i,0]
    depmod[i]=sum(aa)

vsref[0]=mod[0,0]
for i in range(nz):
    for j in range(nmod): 
        if dep[i] >= depmod[j] and dep[i] < depmod[j+1]:
           vsref[i]=mod[j,1]

vs = np.zeros((nz,ny,nx))

for i in range(nz):
    vs[i,:,:] = vsref[i]

os.system('rm MOD')
os.system('rm MOD.true')
f = open("MOD","w")
for i in range(nz):
    f.write("%.1f "%(dep[i]))
f.write("\n")

for i in range(nz):
    for j in range(ny):
        for k in range(nx):
            f.write("%.4f "%vs[i,j,k])
        f.write("\n") 
f.close()  

f = open("MOD.true","w")  
for i in range(nz):
    f.write("%.1f "%(dep[i]))
f.write("\n")      
for i in range(nz):
    for j in range(ny):
        for k in range(nx):
            f.write("%.4f "%vs[i,j,k])
        f.write("\n") 
f.close() 

