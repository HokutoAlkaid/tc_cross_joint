#---
# This program is used to output the synthetic gravity data from inverted model.
#---
#set -x


# then compute gravity for results of DSurfTomo
#---
#   syngrave will use "JointSG.in", "obsgrav.dat" "gravmat.dat", "MOD"
#   the use age has been changed at 2021.01.31
#    please run ./this paramfile refmod truemod obsgrav gravmat remove_mean(false or true) outfile
#
#---

for ii in 0 1 10
do
    rm syn_grav_iter${ii}.dat joint_mod_iter.dat
    cp results/joint_mod_iter${ii}.dat joint_mod_iter.dat
    syngrav syngrav.in MOD.aver joint_mod_iter.dat obsgrav.dat gravmat.dat true syn_grav.dat
    mv syn_grav.dat syn_grav_iter${ii}.dat
done

 


cd gmt_grav_syn
   bash bash.sh
cd ..

