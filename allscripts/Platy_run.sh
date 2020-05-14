#!/bin/bash
#SBATCH -c 16 
#SBATCH -o platy-run-%j.out
#SBATCH -p bigmem

#platypus variant calling script

inputbams=$(ls -m ~/gcrz11/final_g11/postProc/*duped.bam | tr -d ' ' | tr -d '\n')
input=$1
python ~/software/Platypus/bin/Platypus.py callVariants --bamFiles=$inputbams --refFile=~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa --output=~/gcrz11/final_g11/$input.vcf
