#!/bin/sh
set -x
rm -r *km
velfile="joint_mod_iter10.dat"
rm *.dat
rm $velfile
cp ../results/$velfile .

for i in 010 020 030 040 050 060 080 100 120 140 160
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
  
  cp ../../../surf_inv_direct/gmt_vel_surf/${i}km/scale.dat .
  
  bash scale.sh
  cd ..
done

bash copyfig.sh

#rm -r *km
