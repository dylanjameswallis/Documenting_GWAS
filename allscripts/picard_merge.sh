#!/bin/bash
#SBATCH -c 16 -o GATK_mergebam-%j.out

#merges sam files to bam files

java -jar ~/software/picard.jar MergeSamFiles $(cat /mnt/home4/djwallis/gcrz11/final_g11/postProc/mergebamlist.txt) O=finalmerged.bam #merge sams to bam

