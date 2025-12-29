#!/bin/sh
#---
#   This script is used to created 3D initial checkboard model
#   Author        :: Haopeng Chen
#   Creatied time :: 2021-03-08
#---
set -x
#---
#   copy the initial checkerboard model
#---
rm indoinital.dat
cp ../model/indoinital.dat .

#---
#   we use initial.py to creat MOD and MOD.true used for joint inversion
#---

python indoinital.py


#---
#   plot the vertial slice of the inital model
#---

#cd gmt_slice_ref
  # bash bash1.sh 
   #bash bash2.sh   
#cd ..
