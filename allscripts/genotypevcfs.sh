#!/bin/bash
#SBATCH -o gtype-%j.out
#SBATCH -c 16

#GenotypeVCFs script
#only takes one gvcf so all gvcfs must be merged first

export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH 
java -jar ~/software/GenomeAnalysisTK.jar  \
   -T GenotypeGVCFs \
   -R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
   --variant ~/GATK/chr20/chr20full.g.vcf  \
   -o ~/GATK/chr20/chr20.vcf
