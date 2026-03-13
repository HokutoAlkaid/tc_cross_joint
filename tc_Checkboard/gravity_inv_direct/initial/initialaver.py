#---
#   This script is used to creat the inital model in Yunnan region.
#   it is modifed from the script "generate_checkerboard.py" written by Nanqiao Du.
#   Author:: Haopeng Chen  from HUST
#   Creatied time :: 2020.12.27 12:40
#   Modified time :: 2021.02.18 15:40
#   Modification  ::
#          (1) we use the model from direct surface wave inversion as the initial model
#              for joint inversion.
#---
import os
import numpy as np 
import matplotlib.pyplot as plt
from numpy import sin

#--
#  nz is the points in the depth direction, the number is actually 18.
#  nx is the points along the latitude (from north to south)
#  ny is the points along the longitude (from west to east)
#--
#nz=18
nx=21
ny=21
dx = 0.25
dy = 0.25
lat = 27.0 - np.arange(nx) * dx
lon = 97.0 + np.arange(ny) * dy

dep = np.array([0.0,2.0,4.0,6.0,8.0,10.0,15.0,20.0,25.0,30.0,35.0,40.0])                
nz=dep.shape[0]
#--
#  read the initial model. the model from direct surface wave inversion.
#  format :: 
#  lon lat depth  vs_velocity
#--

modfile="mod_iter10.dat"
mod=np.loadtxt(modfile)
nmod=mod.shape[0]

#print(nmod)

vs = np.zeros((nz,ny,nx))

vsaver = np.zeros((nz,ny,nx))

meanv = np.zeros((nz))

for i in range(nz):
    for j in range(ny):
        for k in range(nx):
            nn=nx*ny*i+nx*j+k
            vs[i,j,k]=mod[nn,3]


os.system('rm MOD.aver')
f = open("MOD.aver","w")
for i in range(nz):
    f.write("%.1f "%(dep[i]))
f.write("\n")

for i in range(nz):
    meanv[i]=0
    for j in range(ny):
        for k in range(nx):
            meanv[i]=meanv[i]+vs[i,j,k]
    meanv[i]=meanv[i]/(nx*ny)
       
for i in range(nz):
    for j in range(ny):
        for k in range(nx):
            f.write("%.4f "%meanv[i])
        f.write("\n") 
f.close() 

