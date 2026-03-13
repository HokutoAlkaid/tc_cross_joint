#!/bin/sh
#####
#    The purpose of the Script is to plot the tomography result of Huabei Region
#####
#    Author:Chen Haopeng,PHD of SGG,Wuhan Univeristy,China
#    Email: chp@whu.edu.cn
#    Creatied time     : 2013.05.10 16:17
#    Last Modified time: 2013.05.10 16:17
#####
# gmtset PLOT_DEGREE_FORMAT ddd:mm:ss
gmtset PLOT_DEGREE_FORMAT ddd
#####
#    Define the default name of the PostScript output
#####
FNAME="yndepth.ps"
#####
#    Define the file name of the tomography file
#####
velfile="vel.dat"

path="tectonic"

#####
#    Define map bounds: MINLON/MAXLON/MINLAT/MAXLAT 
#####
LATLON0="98/106/0/120"
LATLON="99/105/0/110"
#####
#    Define Mercator projection: Center lon,la, Plot_Width   
#####
#PROJ="M103.0/25/5i"
PROJ="X4i/-2.0i"
#####
#    Define Coastline resolution: one of fhilc 
#    (f)ull, (h)igh, (i)ntermediate, (l)ow, and (c)rude)
#  . The resolution drops off by 80% between data sets.
#####
RESCOAST="h"

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
TICS="1f1/20f20"

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
#pscoast -J${PROJ} -R${LATLON} -B${TICS} -D${RESCOAST}  -G200 -W0.25p -P -K  > ${FNAME}

lscale=$1
hscale=$2
depth=${3}
label=$4
velscale="$lscale/$hscale/0.02"

cptfile="height.cpt"
grdfile="vel.grd"
#makecpt -Cmy_rainbow.cpt -T${velscale} -I -Z > ${cptfile}
makecpt -Cmy_seis.cpt -T${velscale} -Z > ${cptfile}
#---
#  convert txt file to grd file.
#  xyz2grd command£¬-I option set the step£¬c is arc second
#                  10c/10c is 10¡°X10¡°¡£m is arc minute¡£
#  xyz2grd need that the xyz data is regular. For irregular data, 
#  surface command is recommended.
#  -V Selects verbose mode, which will send progress reports to stderr 
#  -: Toggles between (longitude,latitude) and (latitude,longitude) input 
#     and/or output [Default is (longitude,latitude)]. 
#---
size=0.1
#xyz2grd ${velfile} -G${grdfile} -Ddegree -I0.1  -R${LATLON} -V -:
surface ${velfile} -G${grdfile}  -I0.1/0.5 -R${LATLON0} -V 

#---
#   we add an option -E300, which will be more smoothing. 2021.03.22
#-E sets dpi for the projected grid which must be constructed
#	   if -Jx or -Jm is not selected [Default gives same size as input grid].
#	   Give i to do the interpolation in PostScript at device resolution.
#---
#grdimage ${grdfile} -J${PROJ} -R${LATLON} -B${TICS} -C${cptfile} -G -K -P -K  > ${FNAME}
#grdimage ${grdfile} -J${PROJ} -R${LATLON} -B${TICS} -C${cptfile} -E300 -G  -P  > ${FNAME}
psscale  -B0.1/:km/s:   -D1.8i/-0.35i/3.0i/0.15ih -C${cptfile}   >> ${FNAME}

mv ${FNAME}   colorbar.ps
ps2raster -A -P -Tj colorbar.ps
ps2raster -A -P -Te colorbar.ps
rm  *grd 
rm *.ps
      


