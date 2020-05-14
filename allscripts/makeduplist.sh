#!/bin/bash

#looks like it makes a list of files names in a directory and adds different extensions to them (.duped.bam and .duped.txt), probably for feeding into another program?

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
        outputFile=$outputName.duped.bam
	textfile=$outputName.duped.txt
        echo "$1 ${fwdArray[$i-1]} $outputFile $textfile"
done

