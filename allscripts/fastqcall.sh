#!/usr/bin/env bash

#loop that does fastqc for all files in a directory

RUN_PATH=$1
OUTPUT=$2
cd $RUN_PATH
for file in $(ls $RUN_PATH)
do
    SAMPLE=`basename $file`
    fastqc -t 5 ${SAMPLE} -o $OUTPUT
done

