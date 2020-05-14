#!/bin/bash
#SBATCH -o filtervcf-%j.out
#SBATCH -c 16
FILE=$1
OUT=$2

#filters indels using specified paramters

export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH
java -jar ~/software/GenomeAnalysisTK.jar \
   -T VariantFiltration \
   -R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
   -V $FILE \
   --filterExpression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" \
   --filterName "GATK_BP" \
   -o $OUT \
