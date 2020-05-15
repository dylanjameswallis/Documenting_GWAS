#!/bin/bash

WORKDIR=/setpath/
cd ${WORKDIR}

for file in *P.fastq.gz;
do 
	sample=${file:6:4}
	run="_R2_"
	dir=${file: -11}
	newName="$sample$run$dir"
cp $file ~/TrimmedReads/finalTrimmed/$newName;

done 
