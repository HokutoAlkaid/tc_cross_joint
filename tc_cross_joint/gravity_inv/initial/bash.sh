set -x

rm MOD*
rm moditer10.dat

#cp ../../SCS_surf/surf_smooth_80/results/mod_iter10.dat .

python initialaver.py
python initialmod.py

cp MOD* ../

