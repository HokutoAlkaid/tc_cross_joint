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


for depth in 005 010 015 020
do
    #----
    #    set the initial parameter file of the model. 
    #----
    dv1="-0.3"
    dv2="0.3"
    grdlon="100.0 110.0 6"
    grdlat="15.0 24.0 3"
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

for depth in 025 030 040 050 
do
    #----
    #    set the initial parameter file of the model. 
    #----
    dv1="0.3"
    dv2="-0.3"
    grdlon="100.0 110.0 6"
    grdlat="15.0 24.0 3"
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

for depth in 060 070 080 090 100 110
do
    #----
    #    set the initial parameter file of the model. 
    #----
    dv1="-0.3"
    dv2="0.3"
    grdlon="100.0 110.0 6"
    grdlat="15.0 24.0 3"
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

for depth in 000 025 055 080
do
    #----
    #    set the initial parameter file of the model. 
    #----
    dv1="0.0"
    dv2="0.0"
    grdlon="100.0 110.0 6"
    grdlat="15.0 24.0 3"
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

