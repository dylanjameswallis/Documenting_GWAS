#!/bin/bash
#SBATCH -o combinegvcfs-%j.out
#SBATCH -c 8
#combines gvcf files from GATK
#takes list of gvcfs as .list file

export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH

java -jar ~/software/GenomeAnalysisTK.jar -T CombineGVCFs \
    -R /home5/djwallis/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
    --variant /home5/djwallis/GATK/completegcfs/abamectin_grcz11.list  \
    -o /home5/djwallis/GATK/completegcfs/abamectin_GRCz11_full.g.vcf
