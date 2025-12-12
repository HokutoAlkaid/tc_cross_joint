cat joint_mod_iter0.dat > 1.dat
gawk '{print $4} ' joint_mod_iter1.dat > 2.dat
paste 1.dat 2.dat | awk '{print $1, $2, $3, $5 - $4}' > delta_mg0.dat


