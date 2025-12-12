#---
# This program is used to perform direct 3D S-wave Gravity Inversion.
#---
#set -x
start=`date`
DATE1=`date +%s%N|cut -c1-13`

timefile="runtime1.txt"
rm $timefile
#rm -r results
rm out.dat rw.dat o_vr.txt
cp tc_bouguer_s15_2m.txt obsgrav.dat
rm fort*

rm MOD MOD.true MOD.aver
cd initial
   bash bash.sh
cd ../
#cp scsinitial/MOD .
#cp scsinitial/MOD.aver .
#cp scsinitial/MOD.true .


rm info*.txt

# first run direct surface wave tomography
# use ../bin/DSurfTomo -h for help
# ./this paramfile datafile initmod (truemod)
#echo "run direct surface wave inversion"
#DSurfTomo DSurfTomo.in scs_surfdata1.dat MOD MOD.true > info_surf.txt

# generate gravity matrix
# use ../bin/mkmat -h for help
# ./this paramfile datafile vs-model
echo "---- generate gravity matrix -----"
mkmat DSurfTomo.in obsgrav.dat MOD > info_mkmat.txt

# then compute gravity for results of DSurfTomo
#---
#   syngrave will use "JointSG.in", "obsgrav.dat" "gravmat.dat", "MOD"
#   the use age has been changed at 2021.01.31
#---
#syngrav 

# run joint inversion
# use ../bin/JointTomo -h for help
# ./this paramfile surfdatafile gravdatafile gravmat initmod (refmod) (truemod)
echo "run joint inversion of surface wave and gravity data"
JointSG JointSG.in tc_joint_surfdata.dat obsgrav.dat gravmat.dat MOD MOD.aver MOD.true > info_joint.txt

#rm gravmat.dat
rm -r kernel*
rm rw.dat

#---
#    convert vel to density
#---

#echo "-----convert vel to density----"

#cd results_densi
#   python veltodensi.py
#cd ..

#echo "-----plot figure----"

#cd gmt_vel_joint
#   bash bash.sh
#cd ..


end=`date`
DATE2=`date +%s%N|cut -c1-13`

echo start time >$timefile
echo $start >>$timefile
echo end time >>$timefile
echo $end   >>$timefile
echo "Running time:: $(($((${DATE2}-${DATE1}))/60000)) min" >>$timefile
