#!/bin/bash
# Takes each file in a folder and submits a slurm job using bwamem2p.sh script
# I think?
WORKDIR=/mnt/home4/djwallis/gcrz11/final_g11/AlignmentFiles
OUTPUTDIR=/mnt/home4/djwallis/gcrz11/final_g11/bwalignment
cd ${WORKDIR}

declare -a fwdArray=($(ls ${WORKDIR}/*1P.fastq.gz))
declare -a revArray=($(ls ${WORKDIR}/*2P.fastq.gz))
arrayLength=${#fwdArray[*]}
echo $arrayLength

cd ${OUTPUTDIR}

for (( i=1; i<${arrayLength}+1; i++ ));
do
	outputName=$(basename ${fwdArray[$i-1]})
	outputName=$(echo $outputName | cut -c1-6)
	outputFile=${OUTPUTDIR}/$outputName.sam
	sbatch -c 16 --exclude=node62,node63,node65 /mnt/home4/djwallis/gcrz11/bwamem2P.sh ${fwdArray[$i-1]} ${revArray[$i-1]} $outputFile
done
