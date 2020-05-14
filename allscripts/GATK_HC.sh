#!/bin/bash
IN=$1
OUT=$2

#GATK HaplotypeCaller in gvcf mode

export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH 
java -jar ~/software/GenomeAnalysisTK.jar -T HaplotypeCaller \
	--emitRefConfidence GVCF \
        -R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
        -I $IN \
        -o $OUT 
         

