!#/bin/bash
# adds read groups to bam files for GATK which requires them 
# see GATK website for which RGs are required and what they each mean
directory=$1
for file in $directory;
do
	filename=$(echo "$file") 
	shortname="${file##*/}" # uses file name without extension 
	readname=$(echo $shortname| cut -c 1-6) # cuts off all but the sample name
	#echo $filename (these are for testing)
	#echo $shortname
	#echo $readname
	java -jar ~/software/picard.jar AddOrReplaceReadGroups I=$(echo $file) O=$(echo $filename) RGID=$(echo $readname) RGLB=$(echo $readname) RGPL=illumina RGPU=$(echo $readname) RGSM=$(echo $readname) 
done
