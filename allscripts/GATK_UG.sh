#!/bin/bash
#SBATCH -c 16  -o GATK_UG-%j.out

#UnifiedGenotyper script, probably don't use this

java -jar ~/gcrz11/GenomeAnalysisTK.jar -T UnifiedGenotyper \
	-R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
	-I trimmed_merged_duped_sorted.bam \
	-o trimmed_unrecal_UG.vcf \
	-glm both 
	 
