#---
# This program is used to perform direct 3D S-wave velocity inversion.
#---
#set -x
start=`date`
DATE1=`date +%s%N|cut -c1-13`

#rm MOD MOD.true fort.*
#cp ../check1/indoinital/MOD .
cp ../check1/indoinital/MOD.true .

timefile="runtime1.txt"
rm $timefile
#rm -r results
rm fort*
rm surfdataSC.dat obsgrav.dat
#cp tc_bouguer_s15_2m.txt obsgrav.dat
cp tc_joint_surfdata.dat surfdataSC.dat

rm info*.txt

# 修改参数文件为“正演模式” (synthetic flag = 1)
# 使用 sed 命令动态修改 DSurfTomo.in
cp DSurfTomo.in DSurfTomo_Syn.in
# 将 synthetic flag 0 改为 1
sed -i 's/synthetic flag(0:real data,1:synthetic)/synthetic flag/' DSurfTomo_Syn.in 
sed -i 's/^0 .*synthetic flag/1                                 # synthetic flag/' DSurfTomo_Syn.in

# first run direct surface wave tomography
# use ../bin/DSurfTomo -h for help
# ./this paramfile datafile initmod (truemod)
echo "run direct surface wave inversion"
DSurfTomo DSurfTomo_Syn.in surfdataSC.dat MOD MOD.true > info_surf.txt

#rm gravmat.dat
rm -r kernel*
rm rw.dat
#cp MOD.true results/
#cp checkmod.py results/

#---
#   plot the figure
#---
#cd gmt_vel_surf
   #bash bash.sh
#cd ..

#cd gmt_slice*
   #bash bash.sh
#cd ..

end=`date`
DATE2=`date +%s%N|cut -c1-13`

echo start time >$timefile
echo $start >>$timefile
echo end time >>$timefile
echo $end   >>$timefile
echo "Running time:: $(($((${DATE2}-${DATE1}))/60000)) min" >>$timefile
