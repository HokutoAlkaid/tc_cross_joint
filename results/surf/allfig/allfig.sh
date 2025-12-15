rm *.eps  *.ps *.tif ps*

psfile1="surf_inv_10.0_0.01.ps"

for i in 002 004 006 008 010 015 020 025 030 035 040 045 050 055
do
   cp ../${i}km/${i}km.eps .
   cp ../${i}km/${i}km.jpg .
done

for i in 002 004 006 008 010 015 020 025 030 035 040 045 050 055
do
   rm ${i}km.eps
   #rm -r ../${i}km
done
rm *.ps 
