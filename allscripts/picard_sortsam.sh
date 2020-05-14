#!/bin/bash

#picard command to sort sam files

IN=$1
OUT=$2
java -jar ~/software/picard.jar SortSam \
      I=$IN \
      O=$OUT \
      SORT_ORDER=coordinate
