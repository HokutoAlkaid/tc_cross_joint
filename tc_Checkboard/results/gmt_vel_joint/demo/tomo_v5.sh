#!/bin/sh
#####
#    The purpose of the Script is to plot the tomography result of South China Sea
#####
#    Author:Chen Haopeng,HUST
#    Email: chp@whu.edu.cn
#    Creatied time     :: 2013.05.10 16:17
#    Last Modified time:: 2013.05.10 16:17
#    Modified time::   2020.01.29 12:27
#    Modification ::
#                (1) we change the script from gmt4 format to gmt5 format.
#####
gmt set FORMAT_GEO_MAP ddd
#####
#    Define the default name of the PostScript output
#####
FNAME="indotomo.ps"
#####
#    Define the file name of the tomography file
#####
velfile="vel.dat"

path="tectonic"

#####
#    Define map bounds: MINLON/MAXLON/MINLAT/MAXLAT 
#####
LATLON0="92/108/17/32"
LATLON="97/102/22/27"
#####
#    Define Mercator projection: Center lon,la, Plot_Width   
#####
PROJ="M99.5/24.5/5i"
#####
#    Define Coastline resolution: one of fhilc 
#    (f)ull, (h)igh, (i)ntermediate, (l)ow, and (c)rude)
#  . The resolution drops off by 80% between data sets.
#####
RESCOAST="f"

#####
#    Define boundaries for pscoast 
#    1 = National boundaries 
#    2 = State boundaries within the Americas 
#    3 = Marine boundaries 
#    a = All boundaries (1-3) pscoast 
#####
BDRYS="3"

#####
#    Sets map boundary annotation and tickmark intervals
#    2 is the latitude interval, and f represents the minor tick spacing(1)
#    1 is the longitude tick space. 
#    for small region, "m" reprsents arc minute and "c" represent arc second
#####
TICS="1"

#####
#    Map the coast
#    definations of some options:
#    -G Select filling or clipping of "dry" areas, here -G200 is grey.  
#    -W Draw shorelines [Default is no shorelines].When is used,
#       [Defaults: width = 0.25p, color = black, texture = solid]
#       GMT length unit c, i, m, p(cm, inch, m, and point)
#    -P Selects Portrait plotting mode [Default is Landscape]
#    -K More PostScript code will be appended later [Default terminates
#       the plot system].
#####

depth=${1}
label=$2

cptfile="height.cpt"
grdfile="vel.grd"

#
#---
#  convert txt file to grd file.               
#  xyz2grd need that the xyz data is regular. For irregular data, 
#  surface command is recommended.
#  -V Selects verbose mode, which will send progress reports to stderr 
#  -: Toggles between (longitude,latitude) and (latitude,longitude) input 
#     and/or output [Default is (longitude,latitude)]. 
#---


#---
#  surface command
#  -Lllower and -Luupper option
#   Impose limits on the output solution. llower sets the lower bound. 
#   lower can be the name of a grid file with lower bound values, a fixed value, 
#   d to set to minimum input value., or u for unconstrained [Default]. uupper sets 
#   the upper bound and can be the name of a grid file with upper bound values, a fixed 
#   value, d to set to maximum input value, or u for unconstrained [Default]
#---
gmt surface ${velfile} -G${grdfile}  -I1m/1m -R${LATLON0} -Lld -Lud
gmt psbasemap -J${PROJ} -R${LATLON} -B${TICS} -P -K -V > ${FNAME}

gmt grdcut ${grdfile} -G${grdfile} -R${LATLON}
#---
#   automatically set the scale of the color bar from the grid file
#---
z_min=`gmt grdinfo $grdfile | grep z_min | gawk '{print $3}'`
z_max=`gmt grdinfo $grdfile | grep z_min | gawk '{print $5}'`

z_min=`echo $z_min | gawk '{print int($1*10.0+0.5)/10.0}'`
z_max=`echo $z_max | gawk '{print int($1*10.0+0.5)/10.0}'`
#---
#   we use the mean value of the grid to set the scale bar in order 
#   to show the low and high velocity anomaly.
#---
#z_mean=`gmt grdinfo $grdfile -L2 | grep mean | gawk '{print int($3*10)/10.0}'`
#z_dmax=`echo $z_max $z_mean | gawk '{print $1-$2}'`
#z_dmin=`echo $z_min $z_mean | gawk '{print $2-$1}'`
#z_scale=`echo $z_dmin $z_dmax | gawk '{if ($1>$2) {print $1} else {print $2}}'`
#z_scale=`echo $z_scale | gawk '{ print int($1*10+0.5)/10.0}'`
#z_min=`echo $z_mean $z_scale | gawk '{print $1-$2}'`
#z_max=`echo $z_mean $z_scale | gawk '{print $1+$2}'`

lscalev=$z_min
hscalev=$z_max
dscale=`echo $z_min $z_max | gawk '{ print int(2.5*($2-$1))/10.0}'`
echo "----color bar scale $lscalev $hscalev  $dscale ---- "
velscale="$lscalev/$hscalev/0.02"
gmt makecpt -Cmyrainbow.cpt -T${velscale} -I  -Z > ${cptfile}
#gmt makecpt -Cseis.cpt -T${velscale}   -Z > ${cptfile}


gmt psclip psclip.txt -J${PROJ} -R${LATLON} -P -K -O >>${FNAME}
#---
#   for "grdimage" command, 
#      -n+c, append +c to clip the interpolated grid to input z-min/max
#       [ default may exceed limits ].
#      -t option. I find that this option is useless 
#         Set PDF transparency level for an overlay, in 0-100 percent range
#      
#---

gmt grdimage ${grdfile} -J${PROJ} -R${LATLON} -B${TICS} -C${cptfile}  -P -O -K   >> ${FNAME}
gmt psclip -C -O -K -P >> ${FNAME}
gmt pscoast -J${PROJ} -R${LATLON} -B${TICS} -N${BDRYS}  -Dh  -W0.25p -A1000 -P -O -K   >> ${FNAME}


########
#  psvelo command. Plot velocity vectors, crosses, and wedges on maps
#   -Sn option. Anisotropy bars. Barscale sets the scaling of the bars. This 
#       scaling gives inches(unless c, i, m, or p is appended).
#       Parameters are expected to be in the following columns:
#       1,2 longitude, latitude of station . 3,4 eastward, northward components 
#       of anisotropy vector 
########
#--cancle psclip

#psclip -C -O -K -P >> ${ErFNAME}

#gmt psxy chinaborder/CN-border-La.dat -W1.0p,red  -R -J -O -K >> ${FNAME}
gmt psxy chinaborder/gdborder.dat -W1.0p,black  -R -J -O -K >> ${FNAME}

#---
#   plot the faults
#---
gmt psxy chinaborder/CN-faults.dat -W1.0p,white  -R -J -O -K >> ${FNAME}


for i in 01 03 04 09
#for i in 02
do
  cat chinaborder/gd_${i}*.txt | gawk '{print $3,$4}' | gmt psxy  -W0.8p,red  -R -J -O -K  >> ${FNAME}
done

for i in 02  05 06 07 08
#for i in 02
do
  cat chinaborder/gd_${i}*.txt | gawk '{print $3,$4}' | gmt psxy  -Sc0.001i -W0.8p,red  -R -J -O -K  >> ${FNAME}
done


#---
#   command psscale 
#        -G option  
#---

#gmt psscale  -B$dscale/:km/s:  -Dx5.6i/2.3i/4.6i/0.2i -C${cptfile}  -O  -K  -S -V >> ${FNAME}
gmt psscale  -B0.1/:km/s:  -Dx5.6i/2.2i/4.4i/0.2i -C${cptfile}  -O  -K  -S -V >> ${FNAME}

echo 111.5 24.5 22 0 0 LM "$label"| gmt pstext -J${PROJ} -R${LATLON} -F+fblue -O -P -K -V  >> ${FNAME}
echo 111.5 21.5 20 0 0 LM "$depth"| gmt pstext -J${PROJ} -R${LATLON} -F+fblue -O -P  -V  >> ${FNAME}
#echo 102.0 23.0 16 0 0 LM "Joint"| gmt pstext -J${PROJ} -R${LATLON}  -O -P -V  >> ${FNAME}



#####
#    convert the ps picture to eps format
#    eps is usually for print and used in the microsoftword
#    Caution: make sure that the ps file has been closed before use ps2raster.
#    that's to say the last plot command don't has -K option.
#    -T option 
#       e  eps file
#       f  pdf file
#       j  jpeg file
#       t  tif file
#####

#cp ${FNAME}   ${period}v.ps
#---
#   gmt4, we use ps2raster
#   ps2raster -A -P -Te  ${FNAME} 
#   gmt5, we should use psconvert

#---
mv ${FNAME} ${depth}.ps
gmt psconvert -A -P -Te  ${depth}.ps
gmt psconvert -A -P -Tj ${depth}.ps 
#gmt psconvert -A -P -Tf  ${FNAME} 
rm *.ps

rm  ${FNAME} 
rm  *.grd
      


