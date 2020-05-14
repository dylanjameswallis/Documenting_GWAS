#!/bin/bash
#SBATCH -c 8 -o picard-addRG-%j.out

#another script that's supposed to add read groups to a bam

java -jar picard-tools-2.5.0/picard.jar AddOrReplaceReadGroups I=aligntrimmedgcrz11_sorted.bam O=aligntrimmedgcrz11_sortedRG.bam LB=LB PL=illumina PU=PU SM=name
