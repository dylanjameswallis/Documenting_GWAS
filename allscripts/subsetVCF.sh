#!/bin/bash
#SBATCH -o subsetvcf-%j.out
#SBATCH -c 16

#uses GATK SelectVariants to select specific samples

export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH 
java -jar ~/software/GenomeAnalysisTK.jar \
   -T SelectVariants \
   -R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
   -V ~/GATK/chr20/vcfs/chr20.vcf.gz \
   -o "$1.vcf" \
   -sn $1 \
   -env \
   -trimAlternates
