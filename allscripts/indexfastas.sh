#!/bin/bash

#index all fastas in a folder

DIR=$1

for file in $DIR/*.fasta
do
samtools faidx $file
done
