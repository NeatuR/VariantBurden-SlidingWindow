#! /bin/bash

module load R/4.1.2-foss-2021b

Rscript fisher.R

nochr="chr3"
nobp="50bp"

sed -i '1d' ${nochr}_${nobp}_p.csv

sed -e 's/,/\n&/g' ${nochr}_${nobp}_p.csv | sed 's/,//' | sed '1d' |awk '{print NR" "$0}' > ${nochr}_${nobp}_p_final.csv

rm ${nochr}_${nobp}_p.csv
