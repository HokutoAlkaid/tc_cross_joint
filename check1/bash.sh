#!/bin/sh
#---
#   This script is used to created 3D initial checkboard model
#   Author        :: Haopeng Chen
#   Creatied time :: 2021-03-08
#---
set -x
rm -r allfig model
mkdir allfig model

#---
#   step1, compile the code
#---
rm checkboard
gfortran checkboard.f90 -o checkboard

#---
#   step3, creat the initial model with checkboard anomaly 
#   we just need to change the velocity anomaly dv1 and dv2
#---


for depth in 000 002 004 006 008 010 015 020 025 030 035 040 045 050 055 060
do
    #----
    #    set the initial parameter file of the model. 
    #----
    dv1="-0.3"
    dv2="0.3"
    grdlon="97.0 102.0 5" 
    grdlat="22.0 27.0 5"
    echo $dv1 $dv2 >checkboard.in
    echo $grdlon  >>checkboard.in
    echo $grdlat  >>checkboard.in
    echo $depth   >>checkboard.in
    rm grdfile.txt
    ./checkboard
    
    echo $depth >depth.txt
    mv depth.txt gmt
    #---
    #   interpolate the initial checkboard model
    #---
    cd gmt
       bash scale.sh
       cp checkboard.jpg ../allfig/${depth}km.jpg
       cp interpvel.txt  ../model/${depth}km.txt
    cd ..
done

rm checkboard

cd model
   cat *km.txt > indoinital.dat
cd ..

cd indoinital
   bash bash.sh
cd ..

