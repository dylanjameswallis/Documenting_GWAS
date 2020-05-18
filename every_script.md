###### Markdown file documenting the GWAS pipeline used for Sox7 Analysis
This will help in understanding and conveying what steps were taken and possibly in making a functional pipeline for future experiments

## Lane Information

12 samples were run per lane, 8 lanes in total. (96 samples were run at once; 3 total runs. 12 samples from run 1 were resequenced in run 3. (96*3) - 12 = 276 ).

Michele’s trimmed read files naming convention:

lane1-s001-indexRPI1-ATCACG-97_R2-P2-L1-01_S1_L001_R1_001_1U.fastq.gz
lane1-s001-indexRPI1-ATCACG-97_R2-P2-L1-01_S1_L001_R1_001_2U.fastq.gz

Each sample has 2 fastq.gz files.

files were renamed for simplicity

```bash
#!/bin/bash

WORKDIR=/setpath/
cd ${WORKDIR}

for file in *P.fastq.gz;
do 
	sample=${file:6:4}
	run="_R2_"
	dir=${file: -11}
	newName="$sample$run$dir"
cp $file ~/TrimmedReads/finalTrimmed/$newName;

done 
```

## Trimming Sequences

Each sequence was trimmed using trimmomatic
this was orgincally two scripts (trimmomatic.sh and trimAllSeq.sh) which I combined below and should work

```bash
#!/bin/bash

#script that feeds names of sequence files to trimmomatic with specified outputs

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
	sbatch -c 8 java -jar ~/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE \
  -threads 8 -trimlog  \
  $outputName.txt \
  ${fwdArray[$i-1]} ${revArray[$i-1]} \
  -baseout $outputName  \
  ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done
```

fastQC was then used to get QC on the trimmed reads

a script (qcAllSeq.sh) was used to do qc on all 276 scripts at once

```bash
#!/bin/bash

#fastqcs all fastq files in a folder

WORKDIR=$1
declare -a fwdArray=($(ls ${WORKDIR}/*P.fastq.gz))
arrayLength=${#fwdArray[*]}

for (( i=1; i<${arrayLength}+1; i++ ));
do
	fastqc -t 8 ${fwdArray[$i-1]}
done
```

## Making Indexes for Alignment

Create an index of the reference genome

```bash
# -a bwtsw option indicates the algorithm to use. Bwtsw is used for larger sequences.
# GRCz11 is the references genome used. GRCz11 is the most recent for zebrafish currently.
bwa index -a bwtsw Danio_rerio.GRCz11.dna.primary_assembly.fa 
```



