#!/bin/bash

#generic run script for slurm arrays

outfile=$1
#SBATCH -o outfile-%j.out
command=$(head -${SLURM_ARRAY_TASK_ID} /path/to/file/with/commandlist  | tail -1)
$command
