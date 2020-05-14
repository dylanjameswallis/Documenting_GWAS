#!/bin/bash

#creates a file with specified segment of a fasta file using coordinates
DIR=$1

for file in $DIR/*.fasta
do
name=${file%.*}
samtools faidx $file 20:19065727-19066327 > $name.sox.fa 
done
