#!/bin/sh

#----
#    The purpose of this program is to simultaneously run the program
#    Author        :: Haopeng Chen
#    Email         :: chp@whu.edu.cn
#    Creatied time :: 2015.03.29 10:10
#    Modified time :: 2015.03.29 10:10
#----
set -x
#rm -r allfig
#mkdir allfig
rm -r *km
velfile="indoinital.dat"
rm *.dat
rm $velfile
cp ../model/$velfile .
n=0
for i in 000 002 004 006 008 010 015 020 025 030 035 040 045 050 055 060
do
  rm vel.dat
  awk '{if($3==depth1) print $1,$2,$4}' depth1=$i $velfile > vel.dat
  n=$(($n+1))
  cp -r demo ${i}km
  mv vel.dat ${i}km/vel.dat
  label=`head -n $n label.txt | tail -n 1 | awk '{ print $1 }'`
  cd ${i}km
     echo $i $label >depth.dat
     #---
     #   use the same scale bar as that in gmt_vel_surf
     #---
     bash scale1.sh
     #rm scale.dat
     #cp ../../gmt_vel_surf/${i}km/scale.dat .
     bash scale2.sh
  cd ..
done

cd allfig
   bash bash.sh
cd ..

