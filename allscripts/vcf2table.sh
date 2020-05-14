#!/bin/bash
#SBATCH -o vcf2table-%j.out
#SBATCH -c 16

#converts VCF to easy to read table with GATK VariantsToTable

IN=$1
OUT=$2
export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH 
java -jar ~/software/GenomeAnalysisTK.jar \
   -T VariantsToTable \
   -R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
   -V $IN \
   -o $OUT.table \
   -F CHROM -F POS -F ID -F QUAL -F REF -F ALT \
   -GF GT
