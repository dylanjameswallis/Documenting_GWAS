#!/bin/bash

#makes list of files in a directory for some reason?

WORKDIR=$2
SRCH=$3
cd ${WORKDIR}

declare -a fwdArray=(${WORKDIR}/$SRCH)
arrayLength=${#fwdArray[*]}

#echo ${fwdArray[@]}

for (( i=1; i<${arrayLength}+1; i++ ));
do
        echo "$1 ${fwdArray[$i-1]}"
done

