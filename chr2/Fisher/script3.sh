#! /bin/bash

##controls
paste cons_,* > controls_wind50.txt

#rm cons_,*

#sed -i '1d' controls_wind50.txt
grep -v 'NA' controls_wind50.txt > counts_controls_ii.txt 

#sum up the rows
awk '{ for(i=1; i<=NF;i++) j+=$i; print j; j=0 }' counts_controls_ii.txt > counts_controls_iii.txt
#sed 's/\t/+/g' | bc

##cases
paste hcases_,* > cases_wind50.txt

#rm hcases_,*

#sed -i '1d' cases_wind50.txt
grep -v 'NA' cases_wind50.txt > counts_cases_ii.txt

#sum up the rows
awk '{ for(i=1; i<=NF;i++) j+=$i; print j; j=0 }' counts_cases_ii.txt > counts_cases_iii.txt


####################cases+controls
paste counts_cases_iii.txt counts_controls_iii.txt > table1

sed -i '1d' table1

awk '{print $1" "$2" 21 40"}' table1 > table2

awk ' {$5= $3 - $1} 1' table2 > table3

awk ' {$6= $4 - $2} 1' table3 > table4

rm counts_cases_ii.txt

rm counts_cases_iii.txt 

rm counts_controls_ii.txt

rm counts_controls_iii.txt

rm table1

rm table2

rm table3

#add number row
awk '{print NR" "$0}' table4 > counts_wind50.txt

rm table4

#rm slurm*
