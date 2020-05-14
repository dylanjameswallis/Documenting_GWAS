#!/bin/bash
#SBATCH -c 8 -o bwa_index-%j.out
#makes an index file from the specified reference genome
bwa index -a bwtsw Danio_rerio.GRCz11.dna.primary_assembly.fa 
