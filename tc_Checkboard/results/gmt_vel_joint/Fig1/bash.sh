# The purpos of this program is to merge all the eps figures
# Author: Haopeng Chen
# Creatied time: 2021.05.16 23:00
set -x

#####
#    psimage merge the eps file
#      -Wwidth/height
#      -Cx0/y0 define the loction of the figure
#    ps2raster convert ps file to other formats
#####
#---
#   path1 is the path of initial model
#   path2 is the path of joint inversion model
#---
path1="../../../check1/gmt_depth_abs/allfig/eps"
path2="../allfig/eps"


psfile1="Fig6_checker_depth.ps"

rm *.eps *.ps *.jpg *.tif

for i in 010 020 050
do
   cp $path1/${i}km.eps ${i}km_init.eps
done

for i in 010 020 050
do
   cp $path2/${i}km.eps ${i}km_invt.eps
done



psimage 050km_init.eps -W7c -K > ${psfile1}
psimage 050km_invt.eps -W7c -C7.1c/0/BL -O -K >> ${psfile1}
psimage 020km_init.eps -W7c -C0/5.9c/BL -O -K >> ${psfile1}
psimage 020km_invt.eps -W7c -C7.1c/5.9c/BL -O -K  >> ${psfile1}
psimage 010km_init.eps -W7c -C0/11.8c/BL -O -K >> ${psfile1}
psimage 010km_invt.eps -W7c -C7.1c/11.8c/BL -O  >> ${psfile1}


ps2raster -A -P -Te ${psfile1}
ps2raster -A -P -Tf ${psfile1}
ps2raster -A -P -Tj -E300 ${psfile1}
ps2raster -A -P -Tt -E300 ${psfile1}

for i in 010 020 050
do
   rm ${i}km_init.eps
   rm ${i}km_invt.eps
done

