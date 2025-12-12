#---
# This program is used to perform direct 3D S-wave velocity inversion.
#---
#set -x
start=`date`
DATE1=`date +%s%N|cut -c1-13`

timefile="runtime1.txt"
rm $timefile
#rm -r results
rm fort*

#rm MOD MOD.true
#cd scsinitial
#   python scsinitalmod1.py
#cd ../
#cp scsinitial/MOD .
#cp scsinitial/MOD.true .

#rm info*.txt

# first run direct surface wave tomography
# use ../bin/DSurfTomo -h for help
# ./this paramfile datafile initmod (truemod)
echo "run direct surface wave inversion"
DSurfTomo DSurfTomo.in tc_joint_surfdata.dat MOD MOD.true > info_surf.txt

#rm gravmat.dat
rm -r kernel*
rm rw.dat

#---
#   plot the figure
#---
#cd gmt_vel_surf
#   bash bash.sh
#cd ..

#cd gmt_slice*
#   bash bash.sh
#cd ..

end=`date`
DATE2=`date +%s%N|cut -c1-13`

echo start time >$timefile
echo $start >>$timefile
echo end time >>$timefile
echo $end   >>$timefile
echo "Running time:: $(($((${DATE2}-${DATE1}))/60000)) min" >>$timefile
