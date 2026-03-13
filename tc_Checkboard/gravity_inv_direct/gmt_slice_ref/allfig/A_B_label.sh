# The purpos of this program is to merge all the eps figures
# Author: Haopeng Chen
# Creatied time: 2013.11.06 19:00
set -x

#####
#    psimage merge the eps file
#      -Wwidth/height
#      -Cx0/y0 define the loction of the figure
#    ps2raster convert ps file to other formats
#####
psfile="Fig3_path_rayl.ps"

rm *.eps *.ps *.jpg *.tif

for i in 10s 40s
do
   cp ../$i/$i.eps .
done
 
psimage 10s.eps -W7c -C0/0c/BL -K > ${psfile}
psimage 40s.eps -W7c -C7.2c/0c/BL -O -K >> ${psfile}


#---
#   plot the fig. number
#---
LATLON="0/1/0/1"
PROJ="X1i"
echo 0.5 0.5 18 0 0 0 "(a)"| pstext -J${PROJ} -R${LATLON}   -P -V >alabel.ps
echo 0.5 0.5 18 0 0 0 "(b)"| pstext -J${PROJ} -R${LATLON}   -P -V >blabel.ps
ps2raster -A -P -Te alabel.ps
ps2raster -A -P -Te blabel.ps

psimage alabel.eps -W0.4c -C1.0c/5.0c/BL -O -K >> ${psfile}
psimage blabel.eps -W0.4c -C8.2c/5.0c/BL -O  >> ${psfile}

for i in 10s 40s
do
   rm $i.eps
done

rm alabel* blabel*
rm a_disp.eps b_path.eps
ps2raster -A -P -Te ${psfile}
ps2raster -A -P -Tf ${psfile}
ps2raster -A -P -Tt -E350 ${psfile}

