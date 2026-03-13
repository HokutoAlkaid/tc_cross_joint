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
velfile="mod_iter.dat"
rm *.dat
rm $velfile
cp ../$velfile .
n=0
for i in 24.5 25.5
do
  rm vel.dat
  #awk '{if($3==depth1) print $1,$2,$4}' depth1=$i $velfile > vel.dat
  awk '{if($2==lat1) print $1,$3,$4}' lat1=$i $velfile > vel.dat
  
  #awk '{print $1,$2,$3-(2.5+0.02*$2)}' vel.dat > veln.dat
  #mv veln.dat vel.dat
  
  n=$(($n+1))
  rm -r ${i}_sli
  cp -r demo1 ${i}_sli
  mv vel.dat ${i}_sli/vel.dat
  label=`head -n $n label.txt | tail -n 1 | awk '{ print $1 }'`
  cd ${i}_sli
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

#cd allfig
#   bash bash.sh
#cd ..

