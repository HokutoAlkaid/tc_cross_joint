set -x

start=`date`
DATE1=`date +%s%N|cut -c1-13`
timefile="runtime.txt"
rm $timefile

# create initial Velocity MOD
cd surf_inv_direct
  #bash run.sh
  cd results
  python3 out2init.py mod_iter10.dat MOD
  cp MOD ../../surf_inv
  cd ..
cd ..

# create initial Gravity MOD
#使用经验公式将速度模型转化为初始密度模型
python3 veltodensi.py \
    surf_inv_direct/results/mod_iter10.dat \
    gravity_inv/initial/joint_mod_iter.dat
#cd gravity_inv_direct
  #bash run.sh
  #cd results
    #cp joint_mod_iter10.dat ../../gravity_inv/initial/joint_mod_iter.dat
  #cd ..
#cd ..

##
cd surf_inv
  rm info*
cd ..

cd gravity_inv
  rm info*
cd ..
##

############
echo "Pre-calculating Gravity Matrix..."
cd gravity_inv
  if [ ! -f MOD ]; then
      cd initial && bash bash.sh && cd ..
  fi
  
  # 运行一次 mkmat，生成 gravmat.dat
  mkmat DSurfTomo.in obsgrav.dat MOD > info_mkmat.txt
  
  if [ -f gravmat.dat ]; then
      echo "Gravity Matrix generated successfully."
  else
      echo "Error: gravmat.dat failed to generate."
      exit 1
  fi
cd ..
############
for i in 1 2 3 4 5 6 7 8 9 10
do
# direct surf inversion
cd surf_inv
bash run.sh
cp info_surf.txt info_surf${i}.txt
rm -r info_surf.txt
  cd results 
    bash bash.sh
    cp delta_ms0.dat ../../data
    cp mod_iter1.dat ../../data
    cp mod_iter0.dat ../../data/mod_iter0.dat    # 将旧模型 (mod_iter0.dat) 复制到数据交换区
  cd ..
cd ..

# direct gravity inversion
cd gravity_inv
bash run.sh
cp info_joint.txt info_joint${i}.txt
  cd results 
    bash bash.sh
    cp delta_mg0.dat ../../data
    cp joint_mod_iter1.dat ../../data
    cp joint_mod_iter0.dat ../../data/joint_mod_iter0.dat  #    # 将旧模型复制到数据交换区
  cd ../
cd ../

# cross-gradient inversion
python3 crossgradient_inversion_1.py

#trans mod_iter into MOD
cd results
  python3 out2init.py mod_iter.dat MOD
  cp MOD ../surf_inv
  cp joint_mod_iter.dat ../gravity_inv/initial/joint_mod_iter.dat
  

cd ../
done
###########
############

#plot results
cd results/surf
  bash bash.sh
cd ..
  
cd gravity
  bash bash.sh
cd ..

cd results
  #cp mod_iter.dat ./gmt_slice_ref/mod_iter.dat
  cd gmt_slice_ref
     bash bash1.sh
     bash bash2.sh
  cd ..
cd ..
    
end=`date`
DATE2=`date +%s%N|cut -c1-13`

echo start time > $timefile
echo $start >> $timefile
echo end time >>$timefile
echo $end   >>$timefile
echo "Running time:: $(($((${DATE2}-${DATE1}))/60000)) min" >>$timefile

