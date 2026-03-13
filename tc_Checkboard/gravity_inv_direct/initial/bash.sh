set -x

rm MOD*
rm moditer10.dat

cp ../../surf_inv_direct/results/mod_iter10.dat .

python initialaver.py
python initialmod.py

cp MOD* ../

