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
FNAME="indodepth.ps"
#####
#    Define the file name of the tomography file
#####
velfile="vel.dat"

path="tectonic"

#####
#    Define map bounds: MINLON/MAXLON/MINLAT/MAXLAT 
#####

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
TICS="1f1/1f1"

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
depth=${3}km
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
surface ${velfile} -G${grdfile}  -I2m/2m -R${LATLON} -V 
pscoast -J${PROJ} -R${LATLON} -B${TICS} -N${BDRYS}  -Dh -G200 -W0.25p -A100 -P -K  > ${FNAME}
#psclip $path/psclip.txt -J${PROJ} -R${LATLON} -K -P -O  >>${FNAME}
grdimage ${grdfile} -J${PROJ} -R${LATLON} -B${TICS} -C${cptfile} -G -K -P -O  >> ${FNAME}
#---
#  grdcontour 
#  option:
#  -C could be a cpt.file or  a constant value, which will be used as contour interval
#  -A annot_int is annotation interval in data units; it is ignored if contour levels 
#     are given in a file. [Default is no annotations].
#     e.g A0.1f10, 10 is the size of the annotation
#  -G Controls the placement of labels along the contours.
#     -Gddist(c|i|m|p) or Gddist[d|e|k|m|n])
#  -W type, if present, can be a for annotated contours or c for regular contours [Default].
#     pen sets the attributes for the particular line. Default values for annotated 
#     contours: width = 0.75p, color = black, texture = solid
#     W[+]<type><pen>], pen include:<width>, <color>, and <texture>
#     texture "a" is "---"."o" is "...."
#  -L Limit range: Do not draw contours for data values below low or above high
#---
#grdcontour ${grdfile} -J${PROJ} -R${LATLON} -B${TICS} -K -P -O -C0.2 -A0.2f8 \
#           -Gd8c  -Wathinner,blue,a -Wcthinner,blue,a -V >> ${FNAME}
         


########
#  psvelo command. Plot velocity vectors, crosses, and wedges on maps
#   -Sn option. Anisotropy bars. Barscale sets the scaling of the bars. This 
#       scaling gives inches(unless c, i, m, or p is appended).
#       Parameters are expected to be in the following columns:
#       1,2 longitude, latitude of station . 3,4 eastward, northward components 
#       of anisotropy vector 
########
#--cancle psclip
#psclip -C -O -K -P >> ${FNAME}

#####
#     plot the boundaries of  main tectonic units
#####

#psxy $path/China_tectonic.dat   -m -J${PROJ} -R${LATLON} -O -K -W1p,white,-  >>${FNAME}

#####
#     plot the main faults
#####
#psxy $path/faultyang.dat -J${PROJ} -R${LATLON}   -W1.0p,20 -O -K -V >>${FNAME}
#psxy $path/faultzhang.dat -m -J${PROJ} -R${LATLON}   -W1.0p,20 -O -K -V >>${FNAME}
#pstext $path/faultnm.txt -J${PROJ} -R${LATLON}  -G0/0/0 -O -P -V -K >> ${FNAME}

#####
#     plot the main blocks
#####

#pstext $path/block.txt -J${PROJ} -R${LATLON}  -G0/0/0 -W255 -O -P -V -K >> ${FNAME}
#pstext $path/tectonic.dat -J${PROJ} -R${LATLON}  -G0/0/0 -W255 -O -K -P -V >> ${FNAME}

#####
#     plot the main cities
#####


#---
#   command psscale 
#        -G option  
#---

psscale  -B0.2f0.1/:km/s:  -D5.6i/2.4i/4.8i/0.2i -C${cptfile}  -O  -K  -S >> ${FNAME}


#echo 99.0 22.5 18 0 0 CM $label| pstext -J${PROJ} -R${LATLON}  -O -P -V -K >> ${FNAME}
echo 108.0 15.5 18 0 0 CM $depth| pstext -J${PROJ} -R${LATLON}  -O -P -V  >> ${FNAME}


#####
#    Map the locations of main cities
#    definations of some options:
#    psxy -S option.Plot symbols. "t" is triangle. "i" is reverse triangle.
#                                 "c" is circle. "a" is star
#                                k is kustom symbol. gmtpath/share/custom
#                                example: -Skstar/0.08i
#         -G Select color or pattern for filling of symbols or polygons 
#            [Default is no fill]
#         -W Set pen attributes for lines or the outline of symbols 
#            [Defaults: width = 0.25p, color = black, texture = solid]
#            here we don't need it
#    pstext station2.txt is the text file.  the five columns of it are
#           x, y, size, angle, fontno, justify, text
#    Caution: When we use the -X -Y option, like -Y0.15 first time, we must
#             remove the offset next time, -Y-0.15
#####

#psxy $path/citylalon.txt -J${PROJ} -R${LATLON} -Skstar/0.12i  -G255/0/0 -O  -K -V >>${FNAME}
#pstext $path/cityname.txt -J${PROJ} -R${LATLON}  -G255/0/0 -Y0.15 -O -P -V  >> ${FNAME}

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
#ps2raster ${FNAME} -Te -A
cp ${FNAME}   $depth.ps
ps2raster -A -P -Tj $depth.ps
ps2raster -A -P -Te $depth.ps
#cp $depth.jpg ../allfig/${depth}_vel_joint.jpg
rm  *grd 
rm ${FNAME} $depth.ps
      


