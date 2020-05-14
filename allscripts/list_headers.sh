#!/bin/bash

#???

extension=$1
for f in "$extension"/*.fastq
do
  echo "$f"      
  head -n 1 $f
done

for f in "$extension"/*.bz2
do
  echo "$f"	 
  bzcat $(echo "$f") | head -n 1
done 

for f in "$extension"/*.gz
do
  echo "$f"      
  zcat $(echo "$f") | head -n 1
done

