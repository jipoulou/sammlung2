#!/usr/bin/env bash

#make soap dir with date
NEWSOAPDIR='SOAP_assembly-'`date +%F`
mkdir -p $NEWSOAPDIR;
#move files into new folder
#but withNEWSOAPDIR overwriting
mv -n \
	*map.log \
	*.readOnContig.gz \
	*.peGrads \
	*.readInGap.gz \
	*map.err \
	*scaff.log \
	*.newContigIndex \
	*.links \
	*.bubbleInScaff \
	*.scaf \
	*.scaf_gap \
	*.gapSeq \
	*.scafSeq \
	*.contigPosInscaff \
	*.scafStatistics \
	*scaff.err \
	*gapcloser3.err \
	*.scafSeq.gapclosed3.fas.fill \
	*.scafSeq.gapclosed3.fas \
	*gapcloser3.log \
	./$NEWSOAPDIR &&
#echo that all files were moved
echo "all mapping, scaffolding and gapfilling files
	moved to $NEWSOAPDIR"
