#!/usr/bin/env python

#----
# a python script to extract data for the direct inversion of 
# surface wave dispersion measurements
# By Hongjian Fang @ USTC(fanghj@mail.ustc.edu.cn) 2014/04/24
# the data format is
# # sta1_lat sta1_lon nt iwave igr
#   sta2_lat sta2_lon phase/group velocity
#----

#----
#    This python script is modified by Haopeng Chen from HUST
#    It is used to change the data format of Yunnan region
#    The original data is the data after gauss correction
#    data format:
#    disp10.c1.txt
#    np, meanc, sigmac
#    lon1,lat1,lon2,lat2,vel  
#    Modified time :: 2020.12.22 20:05
#----
#    Modified time :: 2020.12.30 11:45
#    Modification  ::
#    we output the initial dispersion file at every period from 10-60s and 
#    a new dispersion file at some selected periods.
#----

#----
#    Modified time :: 2023.11.28 21:28
#    Modification  ::
#    we find that the orinal data is not right. We modified the error
#----

import os
import numpy as np
#'''how to use it?
#python extractSurfTomo.py > surfdata.dat
#and move surfdata.dat to the directory where you want to run DSurfTomo
#'''

#----
#    interval : the period interval
#    wavetp   : 2 is Rayleigh wave 
#    veltp    : 0 is Phase velocity
#----
# parameters need to change according to your case
# start
nsrc=75
nrc=75
nf=17
MinP=8
MaxP=40
interval=2
wavetp=2
veltp=0
#end

phav=np.zeros((nrc,nsrc,nf))
sta1la=np.zeros((nrc,nsrc,nf))
sta1lo=np.zeros((nrc,nsrc,nf))
sta2la=np.zeros((nrc,nsrc,nf))
sta2lo=np.zeros((nrc,nsrc,nf))

#---
#   read the station lon and lat
#   Modified by Haopeng Chen, 2020.12.20
#---
stalo=np.zeros((nrc))
stala=np.zeros((nrc))
stanm=np.zeros((nrc))
stafile="tc_sta_final_nonm.xt"
stainfo=np.loadtxt(stafile)
shape0=stainfo.shape
for j in range(shape0[0]):
    stalo[j]=stainfo[j,1]
    stala[j]=stainfo[j,0]
    stanm[j]=stainfo[j,2]
#---
#   path of the dispersion file
#---
path='phase_tc_n_fn'
fileall=os.listdir(path)
fileall.sort()
for file in fileall:
    #---
    #   when use np.loadtxt to load the data, the data format should be the same
    #   so we should skip the first row using skiprows
    #---
    if 'c1.txt' in file:
       filen=path+'/'+file
       data=np.loadtxt(filen,skiprows=1)
       print(file)
       shape=data.shape
       nn=file.split('s.')[0]
       nn=nn.split('sp')[1]
       nn=int(nn)
       f=int(np.rint((nn-MinP)/interval+1))       
       
       for i in range(shape[0]):
           rc=-100
           src=-100
           for j in range(shape0[0]):
               dlo1=np.abs(data[i,0]-stalo[j])
               dla1=np.abs(data[i,1]-stala[j])
               dlo2=np.abs(data[i,2]-stalo[j])
               dla2=np.abs(data[i,3]-stala[j])
               if dlo1<5e-3 and dla1<5e-3:
                  rc=j
               if dlo2<5e-3 and dla2<5e-3:
                  src=j
           #---
           #   we store the phase velocity measurements.
           #   we need to make sure that the source number(src) is less than
           #   the receiver number (rc)
           #   sta1lo and sta1la are the lon and lat of the source stations.
           #   sta2lo and sta2la are the lon and lat of the receiver stations.
           #   Modified by Haopeng Chen
           #   Modified time :: 2020.12.22 20:05
           #---
           if rc > src:
              sta1lo[rc,src,f-1]=data[i,2]
              sta1la[rc,src,f-1]=data[i,3]
              sta2lo[rc,src,f-1]=data[i,0]
              sta2la[rc,src,f-1]=data[i,1]
              phav[rc,src,f-1]=data[i,4] 
              
           if src > rc:
              sta1lo[src,rc,f-1]=data[i,0]
              sta1la[src,rc,f-1]=data[i,1]
              sta2lo[src,rc,f-1]=data[i,2]
              sta2la[src,rc,f-1]=data[i,3]
              phav[src,rc,f-1]=data[i,4]             

srclat=-999.9
per=-999
nsrcout=0

os.system('rm tc_joint_surfdata.dat')
f1 = open("tc_joint_surfdata.dat","w")

#---
#   the dispersion file "tc_joint_surfdata.dat"
#   8-50s, interval 2s
#   total number of periods is 17
#---
for ifr in range(nf):
 for isrc in range(nsrc):
  for irc in range(nrc):
   if phav[irc,isrc,ifr]>0:
    if np.abs(sta1la[irc,isrc,ifr]-srclat)>1e-3 or abs(ifr+1-per)>1e-3:
       nsrcout=nsrcout+1
       f1.write('%s %10.4f %10.4f %d %d %d \n' % ('#',sta1la[irc,isrc,ifr],sta1lo[irc,isrc,ifr],ifr+1,wavetp,veltp))
       f1.write('%10.4f %10.4f %6.4f \n' % (sta2la[irc,isrc,ifr],sta2lo[irc,isrc,ifr],phav[irc,isrc,ifr]))
    else:
       f1.write('%10.4f %10.4f %6.4f \n' % (sta2la[irc,isrc,ifr],sta2lo[irc,isrc,ifr],phav[irc,isrc,ifr]))
    srclat=sta1la[irc,isrc,ifr]
    per=ifr+1
f1.close()   
    
