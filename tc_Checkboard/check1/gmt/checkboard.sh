#!/bin/sh
#####
#    The purpose of the Script is to plot the ray density of Huabei Region
#####
#    Author:Chen Haopeng,PHD of SGG,Wuhan Univeristy,China
#    Email: chp@whu.edu.cn
#    Creatied time     : 2014.01.21 15:06
#    Last Modified time: 2014.01.21 15:06
#####
# gmtset PLOT_DEGREE_FORMAT ddd:mm:ss
gmtset PLOT_DEGREE_FORMAT ddd
#####
#    Define the default name of the PostScript output
#####
FNAME="checkboard.ps"
#####
#    Define the file name of the tomography file
#####
xyzfile="file.txt"
path="tectonic"
#####
#    Define map bounds: MINLON/MAXLON/MINLAT/MAXLAT 
#####
LATLON0="97/102/22/27"
LATLON="97/102/22/27"

#---
#    LATLONori is used to create the initial 3D model
#---
LATLONori="97/102/22/27"

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
TICS="2/2"

lowscale="$1"
highscale="$2"
depth="$3"

hscale="$lowscale/$highscale/0.02"
cptfile="raynumber.cpt"
grdfile="raynumber.grd"

#makecpt -Cgray -T${hscale}  -I -Z -V > ${cptfile}
#makecpt -Crainbow -T${hscale}  -I -Z -V > ${cptfile}
makecpt -Cseis -T${hscale}   -Z -V > ${cptfile}
#---
#  convert txt file to grd file.
#  xyz2grd command£¬-I option set the step£¬c is arc second
#                  10c/10c is 10¡°X10¡°¡£m is arc minute¡£
#  xyz2grd need that the xyz data is regular. For irregular data, 
#  surface command is recommended.
#  -V Selects verbose mode, which will send progress reports to stderr 
#  -: Toggles between (longitude,latitude) and (latitude,longitude) input 
#     and/or output [Default is (longitude,latitude)].
#  caution:
#      note that as the xyzfile is global 1x1deg, and the data is that of 
#      midle piont of the grid. When we use the xyz2grd or surface command
#      to convert xyzfile to 1x1deg grid file, the -R options must be 
#      -R-179.5/179.5/-89.5/89.5, and that of grdimage is -R-180/180/-90/90.
#      error will occur if we don't do like this.
#      for small scale data tomography, we also must caution this. 
#---

#surface ${xyzfile} -G${grdfile}   -I0.1/0.1 -R$LATLON0 -V 
surface ${xyzfile} -G${grdfile}   -I0.25/0.25 -R$LATLONori -V 


grd2xyz ${grdfile}  >interpvel.txt

cat interpvel.txt | gawk -v dep="$depth" '{printf "%6.1f %6.1f %4d %8.4f \n", $1,$2,dep,$3}' > interpveln.txt
mv interpveln.txt interpvel.txt


surface ${xyzfile} -G${grdfile}   -I0.05/0.05 -R$LATLON0 -V 


#---
#  grdclip 
#  grdclip input.grd -Goutput.grd -Sahigh/above -Sblow/below -V
#  -Sahigh/above  set all data > high to above
#  -Sblow/below   set all data < low to below
#---
#grdclip ${grdfile} -G${grdfile} -Sa3.6/3.6 -Sb3.0/3.0 -V

#####
#    Command pscoast.Map the coast
#    definations of some options:
#    -G Select filling or clipping of "dry" areas, here -G200 is grey.  
#    -W Draw shorelines [Default is no shorelines].When is used,
#       [Defaults: width = 0.25p, color = black, texture = solid]
#       GMT length unit c, i, m, p(cm, inch, m, and point)
#    -P Selects Portrait plotting mode [Default is Landscape]
#    -K More PostScript code will be appended later [Default terminates
#       the plot system].
#    -D Choose one of the following resolutions:h, i,l,c
#    -A Place limits on coastline features from the GSHHS data base.
#       Features smaller than <min_area> (in km^2) will be skipped.
#####
pscoast -J${PROJ} -R${LATLON} -B${TICS} -Dh  -G200 -W0.25p -A100 -P -K  > ${FNAME}

#psclip $path/psclip.txt -J${PROJ} -R${LATLON} -K -P -K -O >>${FNAME}

grdimage ${grdfile} -JM5i -R${LATLON} -B${TICS} -C${cptfile} -G -K -P -O -V >> ${FNAME}

#####
#     plot the boundaries of  main tectonic units
#####

psxy $path/China_tectonic.dat   -m -J${PROJ} -R${LATLON} -O -K -W1p,white,-  >>${FNAME}

#####
#     plot the main faults
#####
psxy $path/faultyang.dat -J${PROJ} -R${LATLON}   -W1.0p,20 -O -K -V >>${FNAME}
psxy $path/faultzhang.dat -m -J${PROJ} -R${LATLON}   -W1.0p,20 -O -K -V >>${FNAME}

#--cancle psclip
#psclip -C -O -K -P >> ${FNAME}

#echo 104.0 22.5 18 0 0 CM ${depth}km| pstext -J${PROJ} -R${LATLON}  -O -P -V -K >> ${FNAME}
#---
#   command psscale 
#        -B option.Set scale annotation interval and label
#           
#        -D<xpos/ypos/length/width>[h] 
#          set mid-point position and length/width for scale.
#          Append h for horizontal scale
#    
#---
psscale  -B0.1/:km/s:  -D5.6i/2.3i/4.8i/0.2i -C${cptfile}  -O -K -S >> ${FNAME}

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

psxy $path/citylalon.txt -J${PROJ} -R${LATLON} -Skstar/0.12i  -G255/0/0 -O  -K -V >>${FNAME}
pstext $path/cityname.txt -J${PROJ} -R${LATLON}  -G255/0/0 -Y0.15 -O -P -V  >> ${FNAME}


rm *grd *cpt
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
#cp ${FNAME} crust1.ps
ps2raster -A -P -Te ${FNAME}
ps2raster -A -P -Tj ${FNAME}

