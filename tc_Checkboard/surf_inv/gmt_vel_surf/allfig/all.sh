rm *.eps  *.ps *.tif ps* *.bb

psfile1="surf_inv_10.0_0.01.ps"

for i in 010 020 030 040 050 060 070 080 090 100 120 140 
do
   cp ../${i}km/${i}km.eps .
   cp ../${i}km/${i}km.jpg .
done

psimage 080km.eps -W7c -C0/0/BL -K > ${psfile1}
psimage 100km.eps -W7c -C7.2c/0/BL -O -K >> ${psfile1}
psimage 120km.eps -W7c -C14.4c/0/BL -O -K >> ${psfile1}
psimage 040km.eps -W7c -C0/5.5c/BL -O -K >> ${psfile1}
psimage 050km.eps -W7c -C7.2c/5.5c/BL -O -K >> ${psfile1}
psimage 060km.eps -W7c -C14.4c/5.5c/BL -O -K >> ${psfile1}
psimage 010km.eps -W7c -C0/11.0c/BL -O -K >> ${psfile1}
psimage 020km.eps -W7c -C7.2c/11.0c/BL -O -K >> ${psfile1}
psimage 030km.eps -W7c -C14.4c/11.0c/BL -O >> ${psfile1}

ps2raster -A -P -Tj -E400  ${psfile1}

for i in 010 020 030 040 050 060 070 080 090 100 120 140 
do
   rm ${i}km.eps
   #rm -r ../${i}km
done
rm *.ps 
