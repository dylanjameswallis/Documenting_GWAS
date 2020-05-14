#!/bin/bash

#picard duplicate marker for bam files

IN=$1
OUT=$2
MET=$3
java -jar ~/software/picard.jar MarkDuplicates \
      I=$IN \
      O=$OUT \
      M=$MET #file name for metrics text file
