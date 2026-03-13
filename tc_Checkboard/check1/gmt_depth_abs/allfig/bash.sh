# The purpos of this program is to merge all the eps figures
# Author: Haopeng Chen
# Creatied time: 2013.11.06 19:00
set -x

rm *.eps *.jpg *.ps *.tif

for i in 000 002 004 006 008 010 015 020 025 030 035 040 045 050 055 060
do
   #cp ../${i}km/${i}km.eps .
   cp ../${i}km/${i}km.jpg ${i}km.jpg
done

#####
#    psimage merge the eps file
#      -Wwidth/height
#      -Cx0/y0 define the loction of the figure
#    ps2raster convert ps file to other formats
#####
psfile1="Fig5_S-wave1.ps"

psimage 60km.eps -W7c -K > ${psfile1}
psimage 100km.eps -W7c -C7.1c/0/BL -O -K >> ${psfile1}
psimage 10km.eps -W7c -C0/5.8c/BL -O -K >> ${psfile1}
psimage 30km.eps -W7c -C7.1c/5.8c/BL -O  >> ${psfile1}


ps2raster -A -P -Te ${psfile1}
ps2raster -A -P -Tj -E300 ${psfile1}

rm *.ps
