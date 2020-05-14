#!/bin/bash

#assembles a list of sequence files to give to bowtie as input

ls /mnt/home4/mmeisne/Zebrafish/TrimmedReads/ | grep "_1P" >> trimmed1.txt && #grep files together
ls /mnt/home4/mmeisne/Zebrafish/TrimmedReads/ | grep "_2P" >> trimmed2.txt &&
awk '{print "/mnt/home4/mmeisne/Zebrafish/TrimmedReads/" $0}' trimmed1.txt >> trimmedprepend1.txt && #prepend dir to names
awk '{print "/mnt/home4/mmeisne/Zebrafish/TrimmedReads/" $0}' trimmed2.txt >> trimmedprepend2.txt &&
awk -v ORS=, '{ print $1 }' trimmedprepend1.txt | sed 's/,$/\n/' >> trimmed1commas.txt && #change file, adds commas
awk -v ORS=, '{ print $1 }' trimmedprepend2.txt | sed 's/,$/\n/' >> trimmed2commas.txt

# $(cat argsfile) list as command to bowtie
