#!/bin/bash
# bowtie 2 script
FWD=$1
REV=$2
OUTPUT=$3

bowtie2 -p 16 -x /mnt/home4/pthunga/temp/T5Dindex -1 $FWD -2 $REV -S $OUTPUT
