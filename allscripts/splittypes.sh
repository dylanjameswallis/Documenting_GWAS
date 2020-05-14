#!/bin/bash
#SBATCH -o subsetType-%j.out
#SBATCH -c 16

#Use GATK SelectVariants to split different kinds of variants out of a vcf

FILE=$1
OUT=$2
TYPE=$3
export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH 
java -jar ~/software/GenomeAnalysisTK.jar \
   -T SelectVariants \
   -R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
   -V $FILE \
   -o $OUT \
   -selectType $TYPE \
   
