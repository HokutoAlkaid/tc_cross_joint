#!/bin/sh
set -x
#####
#    The purpose of the Script is to copy the data for gmt plot
#####
#    Author:Chen Haopeng,PHD of SGG,Wuhan Univeristy,China
#    Email: chp@whu.edu.cn
#    Creatied time     : 2013.06.17 19:11
#    Last Modified time: 2013.08.17 11:11
##### 
#rm scale 
#gfortran scale.f90 -o scale
#./scale

read lscale hscale <scale.dat
read depth label< depth.dat

rm *.ps *eps
#rm depth.dat scale.dat
bash tomo.sh $lscale $hscale $depth $label


