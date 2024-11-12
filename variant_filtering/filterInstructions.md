# FILTERING VARIANTS BY MAF

### 1. Select only controls from the VCF file
* Extract fields eg. 1-15 and eg. 54-87 to create a VCF for the controls
```
cut -f 1-15,54-87 multi-sample.vcf > controls.vcf
```

### 2. Calculate MAF using PLINK
* Run PLINK1.9 to calculate MAF for the control group
```
plink --set-missing-var-ids @:# --double-id --vcf controls.vcf --freq --out maf_plink_plus
```

### 3. Filter variants with MAF < 0.05
* Use awk to filter variants with MAF < 0.05 and extract variant IDs and MAFs
```
cat maf_plink_plus.frq | awk 'if($5==$5+0 && $5<0.05)print$2)' > mafplink1
cat maf_plink_plus.frq | awk 'if($5==$5+0 && $5<0.05)print$5)' > mafplink2
```

* Combine variant IDs and MAFs into one CSV file
```
paste mafplink1 mafplink2 > mafplink_005.csv
```

* The final file mafplink_005.csv contains the variants and corresponding MAFs

### 4. Extract cases from the original VCF
* Use cut to select fields eg. 1-9 (standard VCF) and additional fields for the cases cohort
```
cut -f 1-9,18-22,27-29,31-35,37,41-43,46-47,51-52 multi-sample.vcf > cases.vcf
```

* Extract variant IDs from mafplink_005.csv to create rarelist.txt
```
awk '{print $1}' mafplink_005.csv > rarelist.txt
```

### 5. Convert control and cases VCFs into PLINK binary format
* Run PLINK1.9 to convert control and cases VCF files into binary format (.bed, .bim, .fam)
```
plink --set-missing-var-ids @:# --double-id --vcf controls.vcf --make-bed --out controlsPlinkFormat
plink --set-missing-var-ids @:# --double-id --vcf cases.vcf --make-bed --out CasesPlinkFormat
```

### 6. Extract rare variants based on rarelist.txt
* Extract the variants listed in rarelist.txt from both control and cases binary files
```
plink --bfile controlsPlinkFormat --extract rarelist.txt --make-bed --out controlsRarePlink
plink --bfile CasesPlinkFormat --extract rarelist.txt --make-bed --out CasesRarePlink
```

* Verify the number of variants
```
wc -l *RarePlink.bim
```
* Should output the same number of variants for both files, e.g., 132266 for both CasesRarePlink.bim and controlsRarePlink.bim

### 7. Split the data by chromosome
* For both control and cases datasets, split the data by chromosome (e.g., chr 3, 4, 8, etc.)
```
plink --bfile controlsRarePlink --chr 3 --recodeA --out controlsRareChr3
plink --bfile controlsRarePlink --chr 4 --recodeA --out controlsRareChr4
plink --bfile controlsRarePlink --chr 8 --recodeA --out controlsRareChr8
plink --bfile controlsRarePlink --chr 9 --recodeA --out controlsRareChr9
plink --bfile controlsRarePlink --chr 10 --recodeA --out controlsRareChr10
plink --bfile controlsRarePlink --chr 11 --recodeA --out controlsRareChr11
plink --bfile controlsRarePlink --chr 12 --recodeA --out controlsRareChr12
plink --bfile controlsRarePlink --chr 16 --recodeA --out controlsRareChr16
```

* Do the same for cases (CasesRarePlink)
```
plink --bfile CasesRarePlink --chr 3 --recodeA --out CasesRareChr3
plink --bfile CasesRarePlink --chr 4 --recodeA --out CasesRareChr4
plink --bfile CasesRarePlink --chr 8 --recodeA --out CasesRareChr8
plink --bfile CasesRarePlink --chr 9 --recodeA --out CasesRareChr9
plink --bfile CasesRarePlink --chr 10 --recodeA --out CasesRareChr10
plink --bfile CasesRarePlink --chr 11 --recodeA --out CasesRareChr11
plink --bfile CasesRarePlink --chr 12 --recodeA --out CasesRareChr12
plink --bfile CasesRarePlink --chr 16 --recodeA --out CasesRareChr16
```

# PROCESS RARE VARIANTS FOR SLIDING WINDOW

### 1. Extract chromosome (CHR) information from rarelist.txt
* Use grep to extract lines with 'chr' and format them with tab-separated values
```
grep 'chr' rarelist.txt | tr : $'\t' > chr.csv
```

### 2. Extract rs IDs from rarelist.txt
* Use grep to extract 'rs' entries and add a header to the rs file
```
grep 'rs' rarelist.txt | sed -e '1iID' > rs.csv
```

### 3. Merge rs IDs with VCF data (R script)
* Load R module and use the following R commands to merge VCF data with rs IDs
```
module load R/4.1.2-foss-2021b
R
rs <- read.delim("rs.csv", header = TRUE, sep = " ")
all <- read.delim("all.vcf", header = TRUE, sep = " ")
rs_merged <- merge(x = all, y = rs, by = "ID", all.y = TRUE)
write.csv(rs_merged, "rs_merged.csv")
```

### 4. Merge chromosome and rs ID data for each chromosome
* Extract chromosome data and corresponding rs data for each chromosome and combine them
```
grep 'chr*' chr.csv | cut -f2 > chr_chr*.csv
grep 'chr*' rs_merged.csv | awk -F, '{print $4}' > rs_chr*.csv
cat chr_chr*.csv rs_chr*.csv | sort > chr*_rare_pos.csv
```

### 5. Quality control (QC)
* Verify the number of rare variants for chromosome 3 by counting lines in the CSV files
```
cat chr3_rare_pos.csv | wc -l
```
* Expected output: 18344

* Verify the number of chromosome-specific entries by counting lines in chr_chr3.csv
```
cat chr_chr3.csv | wc -l
```
* Expected output: 2788

* Verify the number of rs entries for chromosome 3 by counting lines in rs_chr3.csv
```
cat rs_chr3.csv | wc -l
```
* Expected output: 15556
