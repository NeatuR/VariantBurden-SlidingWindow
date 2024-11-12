#! /bin/bash

samples="cases"
chr="chr3"

cut -d " " -f 7- CasesRareChr3.raw > ${samples}_${chr}.tsv

awk '
{ 
    for (i=1; i<=NF; i++)  {
        a[NR,i] = $i
    }
}
NF>p { p = NF }
END {    
    for(j=1; j<=p; j++) {
        str=a[1,j]
        for(i=2; i<=NR; i++){
            str=str" "a[i,j];
        }
        print str
    }
}' ${samples}_${chr}.tsv > ${samples}_${chr}_ii.tsv

rm ${samples}_${chr}.tsv

sort -n ${chr}_rare_pos.csv > ${chr}_rare_pos2.csv

paste ${chr}_rare_pos2.csv ${samples}_${chr}_ii.tsv > ${samples}_${chr}_iii.tsv

rm ${chr}_rare_pos2.csv

rm ${samples}_${chr}_ii.tsv

#change the region accordingly and choose between the seq/awk commands
seq 59121944 67121944 | awk '{print $1" blank 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0"}' > blank_${chr}_${samples}.tsv

#seq 59121944 67121944 | awk '{print $1" blank 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0"}' > blank_${chr}_${samples}.tsv

cat ${samples}_${chr}_iii.tsv blank_${chr}_${samples}.tsv > ${samples}_${chr}_iv.tsv

sort -s -n -k 1,1 ${samples}_${chr}_iv.tsv > ${samples}_${chr}_v.tsv

awk '!seen[$1]++' ${samples}_${chr}_v.tsv > ${samples}_${chr}_final.tsv

#choose between the awk commands accordingly
awk '{print $1" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$14" "$15" "$16" "$17" "$18" "$19" "$20" "$21" "$22" "$23}' ${samples}_${chr}_final.tsv > ${samples}_${chr}_final2.tsv 

#awk '{print $1" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$14" "$15" "$16" "$17" "$18" "$19" "$20" "$21" "$22" "$23" "$24" "$25" "$26" "$27" "$28" "$29" "$30" "$31" "$32" "$33" "$34" "$35" "$36" "$37" "$38" "$39" "$40" "$41" "$42}' ${samples}_${chr}_final.tsv > ${samples}_${chr}_final2.tsv 

rm ${samples}_${chr}_iii.tsv

rm ${samples}_${chr}_iv.tsv

rm ${samples}_${chr}_v.tsv

rm blank*
