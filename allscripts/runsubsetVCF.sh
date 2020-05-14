#!/bin/bash
outfile=$1
#SBATCH -o subsetVCF-%j.out
command=$(head -${SLURM_ARRAY_TASK_ID} /home5/djwallis/GATK/chr20/ControlSubsetRun.txt | tail -1)
$command
