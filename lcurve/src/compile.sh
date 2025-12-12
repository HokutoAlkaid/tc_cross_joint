#---
# This program is used compile the code to calculate L-curve
# Author:: This script is written by Haopeng Chen from HUST.
# lcurve.cpp is written by Nanqiao Du form CAS and then modified by Haopeng Chen
# we rename lcurve.cpp as lmcal.cpp
#---
set -x 
#---
#   compile the code
#---
rm ../bin/lmcal
g++ lmcal.cpp -std=c++11 -o lmcal
mv lmcal ../bin
