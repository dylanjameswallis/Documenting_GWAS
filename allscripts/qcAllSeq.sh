#!/bin/bash

#fastqcs all fastq files in a folder

WORKDIR=$1
declare -a fwdArray=($(ls ${WORKDIR}/*P.fastq.gz))
arrayLength=${#fwdArray[*]}

for (( i=1; i<${arrayLength}+1; i++ ));
do
	fastqc -t 8 ${fwdArray[$i-1]}
done

