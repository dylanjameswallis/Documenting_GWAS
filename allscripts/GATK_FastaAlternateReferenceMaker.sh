#!/bin/bash
#SBATCH -o MakeFastaGATK-%j.out
#SBATCH -c 16

#Creates a Fasta file using a specified VCF file and reference

VCFIN=$1 #input VCF file
OUT=$(echo ${VCFIN:0:6}.fasta) #name fasta using name of vcf
echo $OUT  
export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH 
java -jar ~/software/GenomeAnalysisTK.jar \
-T FastaAlternateReferenceMaker \
-R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
-o $(echo $OUT) \
-V $VCFIN 
