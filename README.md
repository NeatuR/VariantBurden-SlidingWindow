# VariantBurden-SlidingWindow
This workflow calculates the burden of rare variants across the genome using a sliding window approach, enabling the detection of regional clusters of rare variants. By systematically scanning variant call format (VCF) files, it identifies genomic regions enriched for rare variants, supporting analyses of localised genetic burden that may contribute to phenotype or disease susceptibility.

This workflow starts with a multi-sample VCF file containing cases and controls. The `filterInstructions.md`, provides a step-by-step guide on how to filter variants with MAF < 0.05 and subsequently divide the VCF files by chromosome.

##STEP 1
* navigate to the directory `variant_filtering`
* follow the steps outlined `filterInstructions.md`
* move the final outputs in a directory with a corresponding name

##STEP 2
For each chromosome:
* directory `chrNo/sliding_window`: follow the steps outlined in the comments
* directory `chrNo/Fisher`: follow the steps outlined in the comments

While this process could potentially be further automated, in research, time is not always dedicated to coding. However, it can serve as a baseline for implementing sliding window or burden tests approaches from scratch.

  

