#!/bin/bash
#bwa mem alignment for specified forward and reverse sequence files
FWD=$1
REV=$2
OUTPUT=$3
id="${OUTPUT:49:6}" #cuts read groups out of output file name
sm="${OUTPUT:49:6}" 
#lb="${OUTPUT:6}"
bwa mem -M -t 32 -R $(echo "@RG\tID:$id\tSM:$id\tLB:$id\tPL:ILLUMINA") /mnt/home4/djwallis/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa $FWD $REV > $OUTPUT
