#!/bin/sh
set -x
rm -r *km
velfile="mod_iter10.dat"
rm *.dat
rm $velfile
cp ../results/$velfile .

for i in  002 004 006 008 010 015 020 025 030 035 040 
do
  rm vel.dat
  awk '{if($3==depth1) print $1,$2,$4}' depth1=$i $velfile > vel.dat
  cp -r demo ${i}km
  mv vel.dat ${i}km/vel.dat
  cd ${i}km
  #--
  #  create the depth file
  #--
  echo ${i}km >depth.dat
  
  bash scale.sh
  cd ..
done

bash copyfig.sh

#rm -r *km
