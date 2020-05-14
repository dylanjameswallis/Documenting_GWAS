#!/bin/bash
#SBATCH -o consensus-%j.out
SAMPLIST=$1 #list of samples 
IN=$2 #input vcf
DIR=$3 #directory to save fastas

#another script for getting a consenssu sequence from bcftools

for sample in $(cat $SAMPLIST); do
	#echo $sample
	samtools faidx ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa 20:19065827-19066227 | bcftools consensus $IN -s $sample -o $DIR/$sample.consensus.fa;  
done	
