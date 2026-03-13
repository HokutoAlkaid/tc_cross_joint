# The purpos of this program is to merge all the eps figures
# Author: Haopeng Chen
# Creatied time: 2013.11.06 19:00
set -x

rm *.eps  *.ps *.tif

for i in 006 012 020 030 040 050 060 080 100 120
do
   cp ../${i}km/${i}km.eps .
   cp ../${i}km/${i}km.jpg .
done

#####
#    psimage merge the eps file
#      -Wwidth/height
#      -Cx0/y0 define the loction of the figure
#    ps2raster convert ps file to other formats
#####
psfile1="scs_surf_inv_10.0_0.01.ps"

psimage 040km.eps -W7c -K > ${psfile1}
psimage 060km.eps -W7c -C7.1c/0/BL -O -K >> ${psfile1}
psimage 020km.eps -W7c -C0/6c/BL -O -K >> ${psfile1}
psimage 030km.eps -W7c -C7.1c/6c/BL -O -K >> ${psfile1}
psimage 006km.eps -W7c -C0/12.0c/BL -O -K >> ${psfile1}
psimage 012km.eps -W7c -C7.1c/12.0c/BL -O >> ${psfile1}


ps2raster -A -P -Te ${psfile1}
ps2raster -A -P -Tj -E350 ${psfile1}

for i in 006 012 020 030 040 050 060 080 100 120 140
do
   rm ${i}km.eps
   #rm -r ../${i}km
done
rm *.ps 
