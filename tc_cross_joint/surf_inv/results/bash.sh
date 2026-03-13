cat mod_iter1.dat > 1.dat   #new
gawk '{print $4} ' mod_iter0.dat > 2.dat    #old
#paste 1.dat 2.dat | awk '{print $1, $2, $3, $5 - $4}' > delta_ms0.dat    #old - new
paste 1.dat 2.dat | awk '{print $1, $2, $3, $4 - $5}' > delta_ms0.dat    #new - old

