#!/bin/bash

#makes list of bams to sort 

WORKDIR=$2
LEN=$3
SRCH=$4
cd ${WORKDIR}

declare -a fwdArray=(${WORKDIR}/$SRCH)
arrayLength=${#fwdArray[*]}

#echo ${fwdArray[@]}

for (( i=1; i<${arrayLength}+1; i++ ));
do
        outputName=$(echo ${fwdArray[$i-1]:$3:6})
        outputFile=$outputName.sorted.bam
	#textfile=$outputName.sorted.txt
        echo "$1 ${fwdArray[$i-1]} $outputFile SORT_ORDER=coordinate"
done

