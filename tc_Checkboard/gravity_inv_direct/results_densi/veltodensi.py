#!/usr/bin/env python
#----
#    This python script is used to convert S-wave velocity to density structure
#    Author:: Haopeng Chen from HUST
#----
import os
import numpy as np

os.system('rm joint_mod_iter10.dat')
os.system('cp ../results/joint_mod_iter10.dat .')
velfile="joint_mod_iter10.dat"
densifile="joint_densi_iter10.dat"
f1 = open("joint_densi_iter10.dat","w")

data=np.loadtxt(velfile)
len1=data.shape[0]

#---
#   format of Vs file : lon,lat,depth,vs
#   format of density file : lon,lat,depth,rho  
#---
for i in range(len1):
    vs=data[i,3]
    vp=0.9409 + 2.0947*vs - 0.8206*vs**2+ 0.2683*vs**3 - 0.0251*vs**4    
    rho=1.6612*vp- 0.4721*vp**2 + 0.0671*vp**3 - 0.0043*vp**4 + 0.000106*vp**5
    f1.write('%8.2f %8.2f %6d %10.4f \n' % (data[i,0],data[i,1],data[i,2],rho))

