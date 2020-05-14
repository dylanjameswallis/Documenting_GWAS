#!/bin/bash
#SBATCH -c 16 -o samtools_sort-%j.out
samtools sort -@ 16 -m 2G aligntrimmedgcrz11.bam -o aligntrimmedgcrz11_sorted.bam  #sort bam file
