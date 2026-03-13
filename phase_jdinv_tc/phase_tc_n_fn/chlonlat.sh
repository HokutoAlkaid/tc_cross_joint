#!/bin/sh
#---
# The purpose of this program is to replace the lon and lat of seismic stations
# Author: Haopeng Chen
# Email: hpchen@gdut.edu.cn
# Creatied time:      2025.01.31 21:48	
# Modified time:      2025.01.31 21:48	
#---
#set -x
#---
fdir1="../phase_tc_n"  # original phase velocity dipsersion

rm disp*.txt

staf="tc_sta_final.xt"

for ((i=8;i<10;i+=2))
do  
  cp $fdir1/disp0${i}s.c1.txt phase.txt
  #---
  #   we delete the line has "nan",
  #   useage:
  #   sed -i '/nan/d' 1.txt,  this directly remove the line with nan.
  #   or sed '/nan/d' 1.txt > new_1.txt, this save the result in new file.
  #---
  headf=`head -n 1 phase.txt`
  #---
  #   remove the first line of phase.txt
  #---
  sed -i '1d' phase.txt
  
  echo "$headf" > disp0${i}s.c1.txt
  
  while read lon1 lat1 lon2 lat2 vel stnm1 stnm2
  do
      lon1n=`grep $stnm1 $staf | gawk '{print $2}'`
      lat1n=`grep $stnm1 $staf | gawk '{print $3}'`
      lon2n=`grep $stnm2 $staf | gawk '{print $2}'`
      lat2n=`grep $stnm2 $staf | gawk '{print $3}'`
      echo "$lon1n  $lat1n  $lon2n  $lat2n  $vel" >>disp0${i}s.c1.txt
  done < phase.txt

  rm phase.txt
done

for ((i=10;i<=40;i+=2))
do  
  cp $fdir1/disp${i}s.c1.txt phase.txt
  #---
  #   we delete the line has "nan",
  #   useage:
  #   sed -i '/nan/d' 1.txt,  this directly remove the line with nan.
  #   or sed '/nan/d' 1.txt > new_1.txt, this save the result in new file.
  #---
  headf=`head -n 1 phase.txt`
  #---
  #   remove the first line of phase.txt
  #---
  sed -i '1d' phase.txt
  
  echo "$headf" > disp${i}s.c1.txt
  
  while read lon1 lat1 lon2 lat2 vel stnm1 stnm2
  do
      lon1n=`grep $stnm1 $staf | gawk '{print $2}'`
      lat1n=`grep $stnm1 $staf | gawk '{print $3}'`
      lon2n=`grep $stnm2 $staf | gawk '{print $2}'`
      lat2n=`grep $stnm2 $staf | gawk '{print $3}'`
      echo "$lon1n  $lat1n  $lon2n  $lat2n  $vel" >>disp${i}s.c1.txt
  done < phase.txt

  rm phase.txt
done





