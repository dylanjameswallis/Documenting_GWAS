#!/bin/bash
#SBATCH -o singendprac-%j.out
bowtie2 -x index-grcz11 -U ERR3333446.fastq -S aligntest_randomseq.sam
