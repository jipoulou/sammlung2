#!/usr/bin/env bash
FNAME=$1

source ../functions/LTRharvest.functions
source ../functions/seqtoolkit.functions

cat $FNAME | 7uppercase >$FNAME.fas &&
cat $FNAME | gzip >$FNAME.gz &&
#perl ../aux/fasta_splitter.pl -n-parts-total 32 $FNAME.fas &&
mkdir -p $FNAME.splits &&
cat $FNAME.fas | 7onelinefasta | split - -l 2 ./$FNAME.splits/part_
echo "export SHELL=$(type -p bash) &&
      source ../functions/LTRharvest.functions &&
      export -f 7LTRharvest &&" >$FNAME.fas.LTR.commands
ls $FNAME.splits/part*| while read file ; do echo "7LTRharvest $file " ; done >>$FNAME.fas.LTR.commands
parallel --gnu -j 32 :::: $FNAME.fas.LTR.commands

#wait &
#cat $FNAME*part*.ltr >$FNAME.ltr && rm $FNAME*part*.ltr &&
#cat $FNAME*part*.ltrharvest.log >$FNAME.ltrharvest.log && rm $FNAME*part*.ltrharvest.log &&
#cat $FNAME*part*.ltr.rt.blast >$FNAME.ltr.rt.blast && rm $FNAME*part*.ltr.rt.blast &&
#cat $FNAME*part*.ltr.rtconsensus.blast >$FNAME.ltr.rtconsensus.blast && rm $FNAME*part*.ltr.rtconsensus.blast
#cat $FNAME*part*.ltr.rt.blast.log >$FNAME.ltr.rt.blast.log && rm $FNAME*part*.ltr.rt.blast.log &&
#cat $FNAME*part*.ltr.rt.blast.err >$FNAME.ltr.rt.blast.err && rm $FNAME*part*.ltr.rt.blast.err &&
#cat $FNAME*part*.ltr.rtcon.blast.log >$FNAME.ltr.rtcon.blast.log && rm $FNAME*part*.ltr.rtcon.blast.log &&
#cat $FNAME*part*.ltr.rtcon.blast.err >$FNAME.ltr.rtcon.blast.err && rm $FNAME*part*.ltr.rtcon.blast.err &&
#cat $FNAME*part*.inner >$FNAME.inner && rm $FNAME*part*.inner &&
