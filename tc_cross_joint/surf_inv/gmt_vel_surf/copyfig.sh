#!/bin/bash
#----
#rm -r allfig
#mkdir allfig
#mkdir allfig/jpg
#mkdir allfig/eps
for i in ${i}*km
do
   cp ${i}/*.jpg allfig/jpg
   cp ${i}/*.eps allfig/eps
done

cd allfig 
bash all.sh
