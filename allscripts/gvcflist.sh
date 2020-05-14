#!/bin/bash
DIR=$1
OUT=$2
find $DIR -name "*.g.vcf" > $OUT.list 
