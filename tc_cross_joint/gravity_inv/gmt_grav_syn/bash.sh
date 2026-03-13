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
rm -r *iter

n=0
for i in 0 1
do
  rm vel.dat
  cp ../syn_grav_iter${i}.dat vel.dat
  cat vel.dat | gawk '{print $1,$2,$3}'> veln.dat
  n=$(($n+1))
  cp -r demo ${i}iter
  mv veln.dat ${i}iter/vel.dat
  label=`head -n $n label.txt | tail -n 1 | awk '{ print $1 }'`
  cd ${i}iter
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
bash all.sh
cd ..
