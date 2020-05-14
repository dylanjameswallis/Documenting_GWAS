#!/bin/bash

# adds a file name without extension to a fasta header

for i in *.consensus.fa; do 
  sed "1s/.*/>${i%.fa}/" $i; 
done
