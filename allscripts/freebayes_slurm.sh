#!/bin/bash
#SBATCH -c 8 -o freebayes-%j.out

#run freebayes on bam to create alignment

~/freebayes/bin/freebayes -f Danio_rerio.GRCz11.dna.primary_assembly.fa -r 20 aligntrimmedgcrz11_sorted.bam > aligntrimmedgcrz11_freebayes.vcf

