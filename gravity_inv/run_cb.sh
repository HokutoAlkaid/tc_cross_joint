#---
# This program is used to perform direct 3D S-wave velocity inversion.
#---
#set -x
start=`date`
DATE1=`date +%s%N|cut -c1-13`

timefile="runtime1.txt"
rm $timefile
#rm -r results
#mkdir results
rm out.dat rw.dat o_vr.txt
rm surfdataSC.dat obsgrav.dat
rm JointSG_Syn.in
cp tc_bouguer_s15_2m.txt obsgrav.dat
cp tc_joint_surfdata.dat surfdataSC.dat
rm fort*
rm info*.txt

rm MOD MOD.true MOD.aver
cp ../check1/indoinital/MOD.true .
cp ../check1/indoinital/MOD MOD.aver

cd initial
   bash bash.sh
cd ..

# generate gravity matrix
# use ../bin/mkmat -h for help
echo "generate gravity matrix"
#mkmat DSurfTomo.in obsgrav.dat MOD > info_mkmat.txt
echo "Skipping mkmat (Assuming gravmat.dat exists)..."

# 修改参数文件为“正演模式” (synthetic flag = 1)
# 使用 sed 命令动态修改 JointSG.in
cp JointSG.in JointSG_Syn.in
# 将 synthetic flag 0 改为 1
sed -i 's/synthetic flag(0:real data,1:synthetic)/synthetic flag/' JointSG_Syn.in 
sed -i 's/^0 .*synthetic flag/1                                 # synthetic flag/' JointSG_Syn.in

# run joint inversion
# use ../bin/JointTomo -h for help
echo "run joint inversion of surface wave and gravity data"
JointSG JointSG_Syn.in surfdataSC.dat obsgrav.dat gravmat.dat MOD MOD.aver MOD.true > info_joint.txt

#rm gravmat.dat
rm -r kernel*
rm rw.dat

#cd results_densi
   #python veltodensi.py
#cd ..

#---
#   plot the figure
#---
#cd gmt_vel_surf
   #bash bash.sh
#cd ..

#cd gmt_vel_joint
   #bash bash.sh
#cd ..

end=`date`
DATE2=`date +%s%N|cut -c1-13`

echo start time >$timefile
echo $start >>$timefile
echo end time >>$timefile
echo $end   >>$timefile
echo "Running time:: $(($((${DATE2}-${DATE1}))/60000)) min" >>$timefile
