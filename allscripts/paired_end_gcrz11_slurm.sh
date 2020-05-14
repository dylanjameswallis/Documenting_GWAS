#!/bin/bash
#SBATCH -c 8 -o pairendtrimmed-%j.out

#bowtie2 alignment code that takes 2 lists as input
#I'm guessing these are the lists made by the other listy programs?

bowtie2 -p 8 -x index-grcz11 -1 $(cat ~/gcrz11/trimmed1commas.txt)  -2 $(cat ~/gcrz11/trimmed2commas.txt) -S aligntrimmedgcrz11.sam
