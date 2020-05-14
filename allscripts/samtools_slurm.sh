#!/bin/bash
#SBATCH -c 8 -o samtools_convbam-%j.out

#slurm script to convert sam to bam with samtools, seems preferable

samtools view -S -b aligntrimmedgcrz11.sam > aligntrimmedgcrz11.bam  #convert to bam

