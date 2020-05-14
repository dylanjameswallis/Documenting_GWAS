#!/bin/bash
IN=$1
OUT=$2

#GATK haplotype caller script specifically for chr20?

java -jar ~/software/GenomeAnalysisTK.jar -T HaplotypeCaller \
	--emitRefConfidence GVCF \
        -R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
	-L 20 \
        -I $IN \
        -o $OUT \
         

