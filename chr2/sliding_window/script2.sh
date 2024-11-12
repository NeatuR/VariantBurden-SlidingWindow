#! /bin/bash

#SBATCH --mem-per-cpu=8G
#SBATCH --array=2-41

module load R/4.1.2-foss-2021b

Rscript script2.R ${SLURM_ARRAY_TASK_ID}
