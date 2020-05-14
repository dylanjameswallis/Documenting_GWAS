#!/bin/bash
filepath=$1

#creates a list of fastq sequence files and lists ones without duplicates???

for f in $filepath/*fastq*
	do echo "${f%%.*}" >> ~/tmp.txt  
done
uniq -d ~/tmp.txt 
rm ~/tmp.txt
