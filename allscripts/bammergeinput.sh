#!/bin/bash

#prints list of bams for merging for picard input

ls /mnt/home4/djwallis/gcrz11/bwarun | grep "s0" >> bamstomerge.txt && #grep files together
awk '{print "I=" $0}' bamstomerge.txt >> bamstomergeinput.txt && #prepend I= for picard
sed ':a;N;$!ba;s/\n/ /g' bamstomergeinput.txt >> bamstomergefinal.txt

# $(cat argsfile) list as command to bowtie
