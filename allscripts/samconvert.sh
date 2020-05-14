#!/bin/bash

#convert sam to bam

SAM=$1
OUTPUT=$2
samtools view -S -b -@ 16 $SAM > $OUTPUT 
