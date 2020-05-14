#!/bin/bash
#SBATCH -c 8 -o samtools_index-%j.out

#index sorted bam file for GATK

samtools index -b aligntrimmedgcrz11_sorted.bam #index sorted bam file for GATK
samtools faidx Danio_rerio.GRCz11.dna.primary_assembly.fa # index reference
