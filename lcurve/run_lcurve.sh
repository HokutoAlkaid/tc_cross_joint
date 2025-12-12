#---
# This program is used compile the code to calculate L-curve
# Author:: This script is written by Haopeng Chen from HUST.
# lcurve.cpp is written by Nanqiao Du form CAS and then modified by Haopeng Chen
#---
#set -x 
#---
#   step 1
#   compile the code
#---
cd src
   bash compile.sh
cd ..

#---
#   step 2
#   calculate the model difference of final model and initial model,
#   and model roughness ||m||^2, the input file is mod0.dat, mod1.dat
#   The output file is "mod2.dat" and rough.txt
#---
rm mod0.dat mod1.dat
cp ../results/joint_mod_iter0.dat mod0.dat
cp ../results/joint_mod_iter10.dat mod1.dat
python mrough.py

#---
#   step 3
#   calculate the ||Lm||^2 of both mod_iter10.dat and the model difference
#   the mod2.dat. The latter is correct. 
#   The output file is lm.txt
#---
cp mod1.dat mod_iter.dat
./bin/lmcal
mv lm.txt lm_iter10.txt

cp mod2.dat mod_iter.dat
./bin/lmcal
mv lm.txt lm_iter10_dif.txt

rm mod_iter.dat

#---
#   step 4
#   calculate the data residual. I think we should use ||Ws*Rs||^2+||Wg*Rg||^2
#   rather than ||Rs||^2+||Rg||^2
#   format of ref_surf10.dat : dist, obs_traveltime, theory_traveltime
#   format of ref_grav10.dat : obs_gravity theory_gravity
#---
rm JointSG.in res_surf.dat res_grav.dat
cp ../JointSG.in .
cp ../results/res_surf10.dat res_surf.dat
cp ../results/res_grav10.dat res_grav.dat

#--
#  sigmat and sigmag are the error of surface wave and gravity data
#  wts is the weight of surface wave data.
#  ns and ng are number of surface wave data and gravity data.
#--
sigmat=`tail -n 1 JointSG.in | gawk '{print $1}'`
sigmag=`tail -n 1 JointSG.in | gawk '{print $2}'`
wts=`tail -n 2 JointSG.in | head -n 1 | gawk '{print $1}'`
ns1=`cat ../surfdataSC.dat | wc -l`
ns2=`cat ../surfdataSC.dat | grep "#" | wc -l`
ns=`echo $ns1 $ns2 | gawk '{print $1-$2}'`
ng=`cat ../obsgrav.dat | wc -l`
echo "$wts $sigmat $sigmag $ns $ng" > para.txt
cat para.txt
python residual.py
rm para.txt

read lm10 < lm_iter10.txt
read lm10_dif < lm_iter10_dif.txt
read mrough < mrough.txt
read res_s res_g resall < resi.txt
rm resi.txt mrough.txt lm_iter10.txt lm_iter10_dif.txt

echo "res_s  res_g  resall  lm10  lm10_dif  mrough" > lcurve.txt
echo "res_s  res_g  resall  lm10  lm10_dif  mrough"
echo "$res_s $res_g $resall $lm10 $lm10_dif $mrough" >> lcurve.txt
echo "$res_s $res_g $resall $lm10 $lm10_dif $mrough"


