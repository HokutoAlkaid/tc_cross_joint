#!/bin/sh
#####
#    The purpose of the Script is to plot the stations of Huabei Region
#####
#    Author:Chen Haopeng,PHD of SGG,Wuhan Univeristy,China
#    Email: chp@whu.edu.cn
#    Creatied time     : 2013.04.08 23:40
#    Last Modified time: 2013.04.08 23:40
#####
# gmtset PLOT_DEGREE_FORMAT ddd:mm:ss
gmtset PLOT_DEGREE_FORMAT ddd
gmtset LABEL_FONT_SIZE	24p
gmtset FRAME_WIDTH 0.2c
gmtset ANNOT_FONT_SIZE_PRIMARY	14p
gmtset MAP_FRAME_TYPE fancy

#set -x 
#####
#    Define the default name of the PostScript output
#####
FNAME="Fig_eventdem.ps"

#####
#    Define the file name of the station file
#####
stationfile="stlalo.txt"

#####
#    Define map bounds: MINLON/MAXLON/MINLAT/MAXLAT 
#####
LATLON="115.5/120.5/23.5/28.5"
#####
#    Define Mercator projection: Center lon,la, Plot_Width   
#####
PROJ="M118.0/26.0/5i"

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
BDRYS="a"

#####
#    Sets map boundary annotation and tickmark intervals
#    2 is the latitude interval, and f represents the minor tick spacing(1)
#    1 is the longitude tick space. 
#    for small region, "m" reprsents arc minute and "c" represent arc second
#####
TICS="1f1/1f1"

#####
#    Set DEM data
#    The DEM is GTOP, which is sepreated into 33 regions
#    grdraster: extract subregion from a binary raster and write a grid file
#               -I option, set grid spacing. m is arc minite 
#    grd2cpt  : Make a color palette table from grid files.
#               -C option.Specify a colortable [Default is rainbow]
#                  topo-Sandwell/Anderson colors for topography[-7000/+7000]
#               -S -Szstart/zstop/zinc
#               -Z Will create a continuous color palette
#####
heightscale="-11000/8500/10"

cptfile="height.cpt"
makecpt -Cdiy.cpt -T${heightscale} -Z > ${cptfile}



gmt psbasemap -J${PROJ} -R${LATLON} -B${TICS} -P -K -V > ${FNAME}



#####
#    Map the DEM
#    definations of some options:
#    -G This option only applies when the resulting image otherwise 
#       would consist of only two colors: black (0) and white (255).  
#    -P Selects Portrait plotting mode [Default is Landscape].Not necessary
#    -K More PostScript code will be appended later [Default terminates
#       the plot system].
#####
#     The range of easia.grd is -R60/160/-10/60
gmt grdimage demfile/easia.grd -J${PROJ} -R${LATLON}  -C$cptfile -G -O -K -P  >> ${FNAME}

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
#pscoast -J${PROJ} -R${LATLON} -B${TICS} -D${RESCOAST}  -N1 -A2000 -W0.5p -P -O -K  >> ${FNAME}

#####
#     plot the boundary of provinces of China
#####
#psxy prov.txt -J${PROJ} -R${LATLON}  -W0.5p -O -K -V >>${FNAME}

#psxy china_boundary.xy -J${PROJ} -R${LATLON} -m -W0.5p -O -K -V >>${FNAME}

#psxy jiuduanxian.dat -J${PROJ} -R${LATLON} -m -W0.5p -O -K -V >>${FNAME}
#####
#    Map the event
#    definations of some options:
#    psxy -S option.Plot symbols. "t" is triangle. "i" is reverse triangle.
#                                 "c" is circle.
#         -G Select color or pattern for filling of symbols or polygons 
#            [Default is no fill]
#         -W Set pen attributes for lines or the outline of symbols 
#            [Defaults: width = 0.25p, color = black, texture = solid]
#            here we don't need it
#         -L option. force closed polygons: connect the endpoints of the 
#            line-segment(s) and draw polygons.
#    pstext station2.txt is the text file.  the five columns of it are
#           x, y, size, angle, fontno, justify, text
#####

#####
#     draw the great circle paths
#####
#psxy path.txt -J${PROJ} -R${LATLON}  -m -W1.0p,0 -O -K -V >> ${FNAME}


gmt pscoast -J${PROJ} -R${LATLON} -B${TICS} -N${BDRYS}  -Dh  -W0.25p -A1000 -P -O -K   >> ${FNAME}

#####
#     plot the main faults
#####
gmt psxy tectonic/Wang_2014_fault.txt -W1.0p,black,  -R -J -O -K >> ${FNAME}
gmt psxy tectonic/Khorat_Plateau.txt -W1.0p,black  -R -J -O -K >> ${FNAME}

#for i in 01 03 04 09
#for i in 02
#do
#  cat chinaborder/gd_${i}*.txt | gawk '{print $3,$4}' | gmt psxy  -W0.8p,red  -R -J -O -K  >> ${FNAME}
#done

#for i in 02  05 06 07 08
#for i in 02
#do
#  cat chinaborder/gd_${i}*.txt | gawk '{print $3,$4}' | gmt psxy  -Sc0.001i -W0.8p,red -R -J -O -K  >> ${FNAME}
#done

#plot the location of city
gmt pstext tectonic/tectonic.dat -J${PROJ} -R${LATLON} -F+f14p,black  -O -K -P -V  >> ${FNAME}

#plot the location of faults
#gmt pstext faultnm.txt -J${PROJ} -R${LATLON} -F+f8p,black -O -K -V >> ${FNAME}

#plot the location of basin
#gmt psxy SSB.dat -J${PROJ} -R${LATLON} -W1p,brown,dashed -O -P -K -V  >> ${FNAME}
#gmt psxy HYbasin.dat -J${PROJ} -R${LATLON} -W1p,brown,dashed  -O -P -K -V  >> ${FNAME}

#plot the location of earthquake
gawk '{print $6,$5,($10-1.0)*0.08"c"}' tectonic/catalog1970_201503.txt |gmt psxy -J${PROJ} -R${LATLON} -Sc -W0.3p -Gred -O -K -V >>${FNAME}


#echo "115.5  21.5 18 0 0 CM YGA" | gmt pstext -J${PROJ} -R${LATLON}  -O -P -V >> ${FNAME}

gmt psscale  -B5000/:m:  -D2.5i/-0.4i/4.0i/0.15ih -C${cptfile}  -O -K -S >> ${FNAME}

#echo 115.0 21.5 18 0 0 CM 'GBA' | gmt pstext -J${PROJ} -R${LATLON}  -O -P -V >> ${FNAME}



#**************************************************************************
#  We will plot the insert map here
#**************************************************************************
gmt gmtset FRAME_WIDTH 0.1c
gmt gmtset TICK_LENGTH 0c
gmt gmtset BASEMAP_TYPE plain
#####
#     
#    Define map bounds: MINLON/MAXLON/MINLAT/MAXLAT 
#####
#LATLON2="90/115/18/35"
LATLON2="80/130/-2/38"
#####
#    Define Mercator projection: Center lon,la, Plot_Width   
#####
PROJ2="M120.0/20/1.4i"

#####
#    Sets map boundary annotation and tickmark intervals
#    2 is the latitude interval, and f represents the minor tick spacing(1)
#    1 is the longitude tick space. 
#    for small region, "m" reprsents arc minute and "c" represent arc second
#####
TICS2="5f5/5f5news"

#####
#    Map the coast
#    definations of some options:
#    -G Select filling or clipping of "dry" areas, here -G200 is grey.
#    -S Select filling or clipping of "wet" areas  
#    -W Draw shorelines [Default is no shorelines].When is used,
#       [Defaults: width = 0.25p, color = black, texture = solid]
#       GMT length unit c, i, m, p(cm, inch, m, and point)
#    -P Selects Portrait plotting mode [Default is Landscape]
#    -K More PostScript code will be appended later [Default terminates
#       the plot system].
#####

#####
#    Define boundaries for pscoast -N
#    1 = National boundaries 
#    2 = State boundaries within the Americas 
#    3 = Marine boundaries 
#    a = All boundaries (1-3) pscoast 
#####

#pscoast -J${PROJ2} -R${LATLON2} -B${TICS2} -Dh -N3 -A1000 -G200 -Swhite -X2.9i -Y0.1i -W0.20p -P -O  >> ${FNAME}

#grdfile2="tibet.grd"
grdfile2="demfile/easia.grd"

gmt grdimage $grdfile2 -J${PROJ2} -R${LATLON2} -B${TICS2} -C$cptfile -X3.6i -Y0.0i -G -O -K -P  >> ${FNAME}

gmt psxy nuvel_1_plates.dat -W1.0p,250  -R${LATLON2} -J${PROJ2} -O -K >> ${FNAME}

#----
#    plot the location of the study region
#    psxy  
#      -L force closed polygon
#      -A Suppress drawing line segments as great circle arcs, i.e. draw straight lines unless
#----
cat > location.txt << EOF
100 15
100 24
110 24
110 15  
EOF

#####
#     plot the boundaries of  main tectonic units
#####

#gmt psxy tectonic/China_tectonic.dat  -J${PROJ2} -R${LATLON2} -O -K -W0.5p,white,-  >>${FNAME}

gmt psxy location.txt  -J${PROJ2} -R${LATLON2} -A  -L -W0.8p,red -O  -V >>${FNAME}





#################################################################

ps2raster  -Te -A ${FNAME}
ps2raster  -Tj -A -E1000 ${FNAME}
ps2raster  -Tf  ${FNAME}
ps2raster  -Tt -A -E1000 ${FNAME}

rm -f ps2*
