#!/bin/bash
outfile=$1
#SBATCH -o makeFasta-%j.out
command=$(head -${SLURM_ARRAY_TASK_ID} /home5/djwallis/GATK/chr20/controlVCFs/controlFastaArray.txt | tail -1)
$command
