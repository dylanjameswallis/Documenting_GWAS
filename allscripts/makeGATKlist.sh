#!/bin/bash

#makes list of files with .g.vcf extension for feeding into another program

WORKDIR=$2
OUTPUTDIR=$3
SRCH=$4
LEN=$5
cd ${WORKDIR}

declare -a fwdArray=($(ls -r  ${WORKDIR}/$SRCH))
arrayLength=${#fwdArray[*]}

for (( i=1; i<${arrayLength}+1; i++ ));
do
        outputName=$(echo ${fwdArray[$i-1]:$5:6})
        outputFile=$outputName.g.vcf
        opName="${OUTPUTDIR}/$outputFile"
	echo "$1 ${fwdArray[$i-1]} $opName"
done

