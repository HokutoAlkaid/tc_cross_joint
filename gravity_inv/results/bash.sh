cat joint_mod_iter0.dat > 1.dat  #old
gawk '{print $4} ' joint_mod_iter1.dat > 2.dat   #new
paste 1.dat 2.dat | awk '{print $1, $2, $3, $5 - $4}' > delta_mg0.dat   #（新 - 旧）
#paste 1.dat 2.dat | awk '{print $1, $2, $3, $4 - $5}' > delta_mg0.dat  # (旧 - 新)

