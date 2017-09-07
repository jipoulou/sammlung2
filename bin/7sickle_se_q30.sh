#!/usr/bin/env bash

FNAME=$1
#(readlink -f $1)
# uses sickle to trim sequences according to quality threshold


source $FUNCTIONS/open.functions

sickle se -f <( 7fastq_open $FNAME) --quiet -t sanger -q 30 -l 30 -o /dev/stdout | pigz -1 -p 30 >$FNAME.sickleq30l50.fastq.gz