#!/bin/bash
#SBATCH -o concensus-%j.out
# used bcftools to create a concensus sequence from gzipped vcf file
INT=$2 #interval of fasta
REF=$1 #reference file
IN=$3 #input VCF
OUT=$4 #output
samtools faidx $REF $INT | bcftools consensus  $IN -o $OUT
