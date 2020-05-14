#!/bin/bash
#SBATCH -c 16 -o samtools_pract-%j.out

#creates a .dict sequence dictionary file from a reference fasta for GATK

samtools dict -o Danio_rerio.GRCz11.dna.primary_assembly.dict Danio_rerio.GRCz11.dna.primary_assembly.fa #creates a sequence dictionary file
