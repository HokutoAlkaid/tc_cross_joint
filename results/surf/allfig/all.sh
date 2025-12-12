rm *.eps  *.ps *.tif ps*

psfile1="surf_inv_10.0_0.01.ps"

for i in 002 004 006 008 010 015 020 025 030 035
do
   cp ../${i}km/${i}km.eps .
   cp ../${i}km/${i}km.jpg .
done

psimage 020km.eps -W7c -C0/0/BL -K > ${psfile1}
psimage 030km.eps -W7c -C7.2c/0/BL -O -K >> ${psfile1}
psimage 035km.eps -W7c -C14.4c/0/BL -O -K >> ${psfile1}
psimage 008km.eps -W7c -C0/5.5c/BL -O -K >> ${psfile1}
psimage 010km.eps -W7c -C7.2c/5.5c/BL -O -K >> ${psfile1}
psimage 015km.eps -W7c -C14.4c/5.5c/BL -O -K >> ${psfile1}
psimage 002km.eps -W7c -C0/11.0c/BL -O -K >> ${psfile1}
psimage 004km.eps -W7c -C7.2c/11.0c/BL -O -K >> ${psfile1}
psimage 006km.eps -W7c -C14.4c/11.0c/BL -O >> ${psfile1}

ps2raster -A -P -Tj -E400  ${psfile1}

for i in 002 004 006 008 010 015 020 025 030 035 
do
   rm ${i}km.eps
   #rm -r ../${i}km
done
rm *.ps 
