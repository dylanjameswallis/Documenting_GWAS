#!/bin/bash

#makes a list of files from a directory with .chr20.g.vcf ext for feeding to some part of GATK as output file names

WORKDIR=$2
OUTPUTDIR=$3
SRCH=$4
LEN=$5
cd ${WORKDIR}

declare -a fwdArray=($(ls ${WORKDIR}/$SRCH))
arrayLength=${#fwdArray[*]}

for (( i=1; i<${arrayLength}+1; i++ ));
do
        outputName=$(echo ${fwdArray[$i-1]:$5:6})
        outputFile=$outputName.chr20.g.vcf
        opName="${OUTPUTDIR}/$outputFile"
	echo "$1 ${fwdArray[$i-1]} $opName"
done

