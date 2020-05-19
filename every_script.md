### Markdown file documenting the GWAS pipeline used for Sox7 Analysis
This will help in understanding and conveying what steps were taken and possibly in making a functional pipeline for future experiments

## Lane Information
12 samples were run per lane, 8 lanes in total. (96 samples were run at once; 3 total runs. 12 samples from run 1 were resequenced in run 3. (96*3) - 12 = 276 ). (Just FYI: The rerun samples can be found @ /home4/pthunga/IndelAnalysis/TrimmedReads/finalTrimmed/omittedSequences/)

## Fastq files
Michele’s trimmed read files naming convention:

	lane1-s001-indexRPI1-ATCACG-97_R2-P2-L1-01_S1_L001_R1_001_1U.fastq.gz
	lane1-s001-indexRPI1-ATCACG-97_R2-P2-L1-01_S1_L001_R1_001_2U.fastq.gz

Each sample has 2 fastq.gz files. These files were renamed for simplicity. The renamed files look like: 
	s001_R1_1P.fastq.gz  s001_R1_2P.fastq.gz 
where,
s = sample #
R = Run #
1P and 2P represent the two paired end reads

```bash

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
this was orgincally two scripts (trimmomatic.sh and trimAllSeq.sh). The code chunk below combines these two scripts and should work: 

```bash

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
## Quality Control

fastQC was used to get QC reports on the trimmed reads

(qcAllSeq.sh) was used to do qc on all 276 samples.  
```bash
#fastqcs all fastq files in a folder

WORKDIR=$1
declare -a fwdArray=($(ls ${WORKDIR}/*P.fastq.gz))
arrayLength=${#fwdArray[*]}

for (( i=1; i<${arrayLength}+1; i++ ));
do
	fastqc -t 8 ${fwdArray[$i-1]}
done
```

Checking individual QC reports can be time consuming. Alternatively, go to the directory containing the fastq files and run MultiQC. This would generate one report for all files. 
The command to run MultiQC would look like:

```
multiqc .
```
The qc reports can be found @ /home4/pthunga/IndelAnalysis/TrimmedReads/qcReports as html files. 

### Alignment

## Making Indexes for Alignment

Create an index of the reference genome

```bash
# -a bwtsw option indicates the algorithm to use. Bwtsw is used for larger sequences.
# GRCz11 is the references genome used. GRCz11 is the most recent for zebrafish currently.
bwa index -a bwtsw Danio_rerio.GRCz11.dna.primary_assembly.fa 
```

## Alignment Using BWA

Each FWD and REV sequence needs to be listed and fed to alignment command for BWA

```bash
# Makes a list of forward and reverse sequences for feeding to alignment program
# This can be fed into any alignment program that uses simialr syntax for paired reads.
# The first input in this script will be the alignment scripts

WORKDIR=$2
OUTPUTDIR=$3
FWDSRCH=$4
RVSRCH=$5
LEN=$6
cd ${WORKDIR}

declare -a fwdArray=($(ls ${WORKDIR}/$FWDSRCH))
declare -a revArray=($(ls ${WORKDIR}/$RVSRCH))
arrayLength=${#fwdArray[*]}

for (( i=1; i<${arrayLength}+1; i++ ));
do
        outputName=$(echo ${fwdArray[$i-1]:$6:6})
        outputFile=$outputName.sam
        opArray+=("${OUTPUTDIR}/$outputFile")
	echo "$1 ${fwdArray[$i-1]} ${revArray[$i-1]} ${opArray[$i-1]}"
done
```
and example output from this code looks like:
```
/mnt/home4/pthunga/IndelAnalysis/MappingReads/bwamem2P.sh /mnt/home4/pthunga/IndelAnalysis/TrimmedReads/finalTrimmed/s004_R1_1P.fastq.gz /mnt/home4/pthunga/IndelAnalysis/TrimmedReads/finalTrimmed/s004_R1_2P.fastq.gz /mnt/home4/pthunga/IndelAnalysis/MappingReads/final.bwa.output/s004_R1.sam
```

This script is the bwa code

```bash
#bwa mem alignment for specified forward and reverse sequence files
FWD=$1
REV=$2
OUTPUT=$3
id="${OUTPUT:49:6}" #cuts read groups out of output file name
sm="${OUTPUT:49:6}" 
#lb="${OUTPUT:6}"
bwa mem -M -t 32 -R $(echo "@RG\tID:$id\tSM:$id\tLB:$id\tPL:ILLUMINA") /mnt/home4/djwallis/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa $FWD $REV > $OUTPUT
```
### GATK Preprocessing

## Convert sam files to bam files for analysis

First make a list of all sam files to convert to bam files. The first input can be whatever convert script.

```bash

WORKDIR=$2
SRCH=$3
cd ${WORKDIR}

declare -a fwdArray=(${WORKDIR}/$SRCH)
arrayLength=${#fwdArray[*]}

#echo ${fwdArray[@]}

for (( i=1; i<${arrayLength}+1; i++ ));
do
        echo "$1 ${fwdArray[$i-1]}"
done
```

Send files to samtools for conversion.

```bash

#convert sam to bam

SAM=$1
OUTPUT=$2
samtools view -S -b -@ 16 $SAM > $OUTPUT 
```

## GATK requires sorted bam files so the converted files need to be sorted

Need to make another list of bams to sort

```bash

#makes list of bams to sort 

WORKDIR=$2
LEN=$3
SRCH=$4
cd ${WORKDIR}

declare -a fwdArray=(${WORKDIR}/$SRCH)
arrayLength=${#fwdArray[*]}

#echo ${fwdArray[@]}

for (( i=1; i<${arrayLength}+1; i++ ));
do
        outputName=$(echo ${fwdArray[$i-1]:$3:6})
        outputFile=$outputName.sorted.bam
	#textfile=$outputName.sorted.txt
        echo "$1 ${fwdArray[$i-1]} $outputFile SORT_ORDER=coordinate"
done
```

Use picard to sort files.

```bash

#picard command to sort sam files

IN=$1
OUT=$2
java -jar ~/software/picard.jar SortSam \
      I=$IN \
      O=$OUT \
      SORT_ORDER=coordinate
 ```

## Mark Duplicates in bam files for GATK

This script marks duplicates and can be fed a list of files made the same way as the input script for sorting.
The only difference is that you would pull files by a new extension.

```bash

#picard duplicate marker for bam files

IN=$1
OUT=$2
MET=$3
java -jar ~/software/picard.jar MarkDuplicates \
      I=$IN \
      O=$OUT \
      M=$MET #file name for metrics text file   
```
## Index bam files after processing

This script also can be easily fed a list of file names generated similarly to previous steps

```bash
IN=$1

#picard bam indexer

java -jar ~/software/picard.jar BuildBamIndex I=$IN
```

### Finally variant calling

## GATK
Note that GATK requires a certain version of Java, so be sure to export it to your path!

First generate a list of bam files to be called

```bash

WORKDIR=/mnt/home4/pthunga/IndelAnalysis/bamFiles/markedDups
OUTDIR=/mnt/home4/pthunga/IndelAnalysis/calledVariants
cd ${WORKDIR}

for file in *.bam;
do

        outputName=$(echo ${WORKDIR}/${file%.*})
        echo "/mnt/home4/pthunga/IndelAnalysis/scripts/GATK_HC.sh $outputName.bam $OUTDIR/${file%.*}.g.vcf"
done
```
Use GATK to call variants and generate gvcf files for each sample
On full sequence:

```bash
IN=$1
OUT=$2

#GATK HaplotypeCaller in gvcf mode

export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH 
java -jar ~/software/GenomeAnalysisTK.jar -T HaplotypeCaller \
	--emitRefConfidence GVCF \
        -R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
        -I $IN \
        -o $OUT 
```

Or on a single chr:

```bash
IN=$1
OUT=$2

#GATK haplotype caller script specifically for chr20

java -jar ~/software/GenomeAnalysisTK.jar -T HaplotypeCaller \
	--emitRefConfidence GVCF \
        -R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
	-L 20 \
        -I $IN \
        -o $OUT \
```

These gvcf files can then be merged. This scripts takes a list as well. I think we know how to generate these by now.

```bash
#combines gvcf files from GATK
#takes list of gvcfs as .list file

export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH

java -jar ~/software/GenomeAnalysisTK.jar -T CombineGVCFs \
    -R /home5/djwallis/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
    --variant /home5/djwallis/GATK/completegcfs/abamectin_grcz11.list  \
    -o /home5/djwallis/GATK/completegcfs/abamectin_GRCz11_full.g.vcf
```

Joint Genotyping is then done on the combined gvcf file.
Joint Genotyping allows easy incorporation and removal of files as needed without having to redo all files.

```bash
#combines gvcf files from GATK
#takes list of gvcfs as .list file

export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH

java -jar ~/software/GenomeAnalysisTK.jar -T CombineGVCFs \
    -R /home5/djwallis/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
    --variant /home5/djwallis/GATK/completegcfs/abamectin_grcz11.list  \
    -o /home5/djwallis/GATK/completegcfs/abamectin_GRCz11_full.g.vcf
```

Once genotyping is complete you can separate indels and SNPs for analysis

INDELS:
```bash
FILE=$1
OUT=$2

#filters indels using specified paramters

export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH
java -jar ~/software/GenomeAnalysisTK.jar \
   -T VariantFiltration \
   -R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
   -V $FILE \
   --filterExpression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" \
   --filterName "GATK_BP" \
   -o $OUT 
```

SNPS:
```bash
FILE=$1
OUT=$2

#filters SNPs using specified parameters

export PATH=/usr/lib/jvm/java-8-oracle/jre/bin:$PATH 
java -jar ~/software/GenomeAnalysisTK.jar \
   -T VariantFiltration \
   -R ~/gcrz11/Danio_rerio.GRCz11.dna.primary_assembly.fa \
   -V $FILE \
   --filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" \
   --filterName "GATK_BP" \
   -o $OUT 
```

## Association analysis
PLINK was used for analysis to find SNPs and INDELs of interest

In order to run association analysis, we need to make bed, bim and fam files from the VCF files. 

To generate these, first take filtered INDELS from /home5/pthunga/IndelAnalysis/Apr16/vcfs and get the necessary bed bim and fam files using the following code:

```bash
plink1.9 --noweb --vcf ~/IndelAnalysis/Apr16/vcfs/chr20INDEL_filtered.vcf --out ~/IndelAnalysis/Apr16/plink/chr20INDEL_filtered
```

Since the variants we generated above are not annotated, the bim file outputted here was taken to R and the variants were numbered as 'indel1', 'indel2' and so on. This HAS to be done because while adjusting for multiple test correction later, the output file will not contain base pair location info. It will only have chr number, variant ID and p values. The updated bim file was loaded back here and renamed to chr20INDEL_filtered.bim before running the next step.

Next, the fam file outputted here was also taken to R and phenotype info was added. The FID & Individual ID were corrected and fixed fam file was uploaded back here and renamed as chr20INDEL_filtered.fam

R code i used for that: OneDrive/ReifLab/IndelAnalysis/plink/plink_indel

```r
setwd("C:/Users/thung/OneDrive/")

#Step 1: Fixing bim file i.e. add variant ID in bim file
bim = read.table('chr20INDEL_filtered.bim')
var.ID = paste0('indel',1:nrow(bim))
bim$V2 = var.ID
##checking to see if indel of interest is present
# bim[bim$V4 == 19065990,]

write.table(bim,'chr20final.bim', col.names = FALSE, row.names = FALSE, quote = FALSE, sep="\t")

#Step 2: Fixing fam file i.e. add phenotype info to the generated fam files
#David shared this info with Dylan and Preethi over email (Subject of the email: "GxE Abamectin Affected/Unaffected status information")
#Use that info to map the phenotypes back to the samples

#Step 3: Once all required files are ready, run association analysis. This can be done from R by invoking the shell or directly on the terminal. 
#To run it from R itself: 
shell(paste0('plink --bed chr20INDEL_filtered.bed --bim chr20INDEL_filtered.bim --fam chr20INDEL_filtered.fam --assoc fisher --adjust --allow-no-sex'))

```
Or run, 

```r
plink1.9 --bed chr20INDEL_filtered.bed --bim chr20INDEL_filtered.bim --fam chr20INDEL_filtered.fam --assoc fisher --adjust --allow-no-sex
plink1.9 --bed chr20SNPs_filtered.bed --bim chr20SNPs_filtered.bim --fam chr20SNPs_filtered.fam --assoc fisher --adjust --allow-no-sex
```
assoc.fisher output file generated and then, this is converted to csv.

```bash
cat plink.assoc.fisher | sed -r 's/^\s+//g' | sed -r 's/\s+/,/g' > plink.assoc.fisher.csv
cat plink.assoc.fisher.adjusted | sed -r 's/^\s+//g' | sed -r 's/\s+/,/g' > plink.assoc.fisher.adjusted.csv
```
Or can directly be loaded into R for analysis
```r
##Load output
assoc.fish = read.table('plink.assoc.fisher')
```
