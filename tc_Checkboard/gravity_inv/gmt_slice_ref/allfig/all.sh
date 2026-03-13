rm *.eps  *.ps *.tif ps*
psfile1="slice.ps"

for i in 22.5 23.5 113 115
do
  cd ../${i}_sli
  bash scale2.sh
  cd ../allfig
done


for i in 22.5 23.5 113 115
do
  cp ../${i}_sli/${i}.eps .
  cp ../${i}_sli/${i}.jpg .
done

psimage 23.5.eps -W7c -C0/0c/BL  -K > ${psfile1}
psimage 22.5.eps -W7c -C7.2c/0c/BL -O -K >> ${psfile1}
psimage 113.eps -W7c -C0/4.5c/BL -O -K >> ${psfile1}
psimage 115.eps -W7c -C7.2c/4.5c/BL -O >> ${psfile1}

ps2raster -A -P -Tj -E1000  ${psfile1}

for i in 22.5 23.5 113 115
do
   rm ${i}.eps
   #rm -r ../${i}km
done
rm *.ps 
