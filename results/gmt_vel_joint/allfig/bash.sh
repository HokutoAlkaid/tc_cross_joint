# The purpos of this program is to merge all the eps figures
# Author: Haopeng Chen
# Creatied time: 2013.11.06 19:00
set -x

rm *.eps *.jpg *.ps *.tif

for i in 002 004 006 008 010 015 020 025 030 035 040 045 050 055
do
   cp ../${i}km/${i}km.eps .
   cp ../${i}km/${i}km.jpg ${i}km_joint.jpg
done

#####
#    psimage merge the eps file
#      -Wwidth/height
#      -Cx0/y0 define the loction of the figure
#    ps2raster convert ps file to other formats
#####
#psfile1="Indo_jiont_1.ps"
#psfile2="Indo_jiont_2.ps"

#psimage 025km.eps -W7c -K > ${psfile1}
#psimage 030km.eps -W7c -C7.1c/0/BL -O -K >> ${psfile1}
#psimage 015km.eps -W7c -C0/5.5c/BL -O -K >> ${psfile1}
#psimage 020km.eps -W7c -C7.1c/5.5c/BL -O -K >> ${psfile1}
#psimage 005km.eps -W7c -C0/11.0c/BL -O -K >> ${psfile1}
#psimage 010km.eps -W7c -C7.1c/11.0c/BL -O  >> ${psfile1}


#ps2raster -A -P -Te ${psfile1}
#ps2raster -A -P -Tj -E350 ${psfile1}

#psimage 080km.eps -W7c -K > ${psfile2}
#psimage 090km.eps -W7c -C7.1c/0/BL -O -K >> ${psfile2}
#psimage 060km.eps -W7c -C0/5.5c/BL -O -K >> ${psfile2}
#psimage 070km.eps -W7c -C7.1c/5.5c/BL -O -K >> ${psfile2}
#psimage 040km.eps -W7c -C0/11.0c/BL -O -K >> ${psfile2}
##psimage 050km.eps -W7c -C7.1c/11.0c/BL -O  >> ${psfile2}

#ps2raster -A -P -Te ${psfile2}
#ps2raster -A -P -Tj -E350 ${psfile2}

#for i in 005 010 015 020 025 030 040 050 060 070 080 090 100 110
#do
#   rm ${i}km.eps
  # rm -r ../${i}km
#done
rm *.ps
rm *.eps
