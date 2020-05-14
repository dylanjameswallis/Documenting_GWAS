#renames all speified files with information about sample

WORKDIR=$1
OUTPUTDIR=$2
cd ${WORKDIR}

for file in *P.fastq.gz;
do 
	sample=${file:6:4}
	run=$3
	dir=${file: -11}
	newName="$sample$run$dir"
cp $file $OUTPUTDIR/$newName;

done 
