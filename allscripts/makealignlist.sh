#!/bin/bash

#makes a list of forward and reverse sequences for feeding to alignment program

WORKDIR=$2
OUTPUTDIR=$3
FWDSRCH=$4
RVSRCH=$5
LEN=$6
cd ${WORKDIR}

declare -a fwdArray=($(ls ${WORKDIR}/$FWDSRCH))
declare -a revArray=($(ls ${WORKDIR}/$RVSRCH))
arrayLength=${#fwdArray[*]}

for (( i=1; i<${arrayLength}+1; i++ ));
do
        outputName=$(echo ${fwdArray[$i-1]:$6:6})
        outputFile=$outputName.sam
        opArray+=("${OUTPUTDIR}/$outputFile")
	echo "$1 ${fwdArray[$i-1]} ${revArray[$i-1]} ${opArray[$i-1]}"
done

