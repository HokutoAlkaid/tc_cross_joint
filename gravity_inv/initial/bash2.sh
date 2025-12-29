set -x

rm MOD*
rm moditer10.dat

python initialmod.py

cp MOD* ../

