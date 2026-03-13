#!/bin/sh
set -x
#####
#    The purpose of the Script is to copy the data for gmt plot
#####
#    Author:Chen Haopeng,PHD of SGG,Wuhan Univeristy,China
#    Email: chp@whu.edu.cn
#    Creatied time     : 2013.06.17 19:11
#    Last Modified time: 2013.06.17 19:11
#####
rm file.txt
rm *.ps *.eps 
cp ../gridfile.txt file.txt
gfortran scale.f90 -o scale
./scale
read lowv highv < scale.txt
read depth < depth.txt
bash checkboard.sh $lowv $highv $depth
rm scale


