#!/bin/bash
#SBATCH -c 8 -o trimmomatic-%j.out
#Using "base" names

#Trimmomatic script

java -jar ~/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 8 -trimlog $1 $2 $3 -baseout $4  ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
