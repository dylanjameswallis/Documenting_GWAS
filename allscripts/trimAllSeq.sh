#!/bin/bash

#script that feeds names of sequence files to trimmerator.sh with specified outputs

WORKDIR=$1
OUTPUTDIR=$2
reg1=$3
reg2=$4
cd ${WORKDIR}

declare -a fwdArray=($(ls ${WORKDIR}/$reg1))
declare -a revArray=($(ls ${WORKDIR}/$reg2))
arrayLength=${#fwdArray[*]}
echo $arrayLength

cd ${OUTPUTDIR}

for (( i=1; i<${arrayLength}+1; i++ ));
do
#Using "base" names
	outputName=$(basename ${fwdArray[$i-1]})
	#outputName=$(echo $outputName | cut -c 29-30,34-37,43-)
	#outputFile=$(echo $outputName | cut -c 29-30,34-37,43-46)
	sbatch -c 8 /mnt/home4/djwallis/gcrz11/trimmerator.sh $outputName.txt ${fwdArray[$i-1]} ${revArray[$i-1]} $outputName
done
