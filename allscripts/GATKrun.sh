#!/bin/bash
#SBATCH -o GATK-%j.out
#SBATCH -p bigmem
#slurm array runscript for GATKlist.sh
command=$(head -${SLURM_ARRAY_TASK_ID} /home5/djwallis/GATK/GATKlist.sh | tail -1)
$command
