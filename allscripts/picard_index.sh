#!/bin/bash
IN=$1

#picard bam indexer

java -jar ~/software/picard.jar BuildBamIndex I=$IN
