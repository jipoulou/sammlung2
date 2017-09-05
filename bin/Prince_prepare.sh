#!/usr/bin/env bash

#!/bin/bash
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=11500
#SBATCH -o prince_allSRR_1.fastq.gz.jellyfish.job.%j.out

F=R1.bbrepair.fastq.gz
R=R2.bbrepair.fastq.gz


################# BEGIN QUALITY KILLER ##########################################################
function quality33_force {
	paste - - - - | awk 'BEGIN {FS="\t"}; { gsub("[[:alnum:]]","2",$4); gsub("[[:punct:]]","2",$4); print $1"\n"$2"\n"$3"\n"$4}' | seqtk seq -U
}

############################### BEGIN PRINCE-PREP #######################################################
function prince {

	rm -rf prueba
	mkdir prueba
	pigz -p 28 -cd $F | head -n 4000000000 | split - -l 16000000 ./prueba/R1
	pigz -p 28 -cd $R | head -n 4000000000 | split - -l 16000000 ./prueba/R2
	paste <(ls ./prueba/R1*) <(ls ./prueba/R2*) | while read -r f r; do echo "prinseq-lite.pl -fastq $f -fastq2 $r -derep 51 1>$f.prince.log 2>$r.prince.err"; done >./prueba/prince.script
	parallel --gnu -j 32 :::: ./prueba/prince.script
	wait
	paste <(ls ./prueba/R1*good*) <(ls ./prueba/R2*good*) | while read -r f r; do echo "SeqPrep -L 20 -o 50 -f $f -r $r -1 $f.seqprep.gz -2 $r.seqprep.gz -s $r.merged.gz 1>$r.seqprep.log 2>$r.seqprep.err";done >./prueba/prince.script2
	parallel --gnu -j 32 :::: ./prueba/prince.script2
	wait
	bfc -d kmers.bfc -k 33 -t 42 <(pigz -p 32 -cd ./prueba/*fastq.merged.gz ./prueba/R1*.seqprep.gz ./prueba/R2*.seqprep.gz R3.bbrepair.fastq.gz )
	ls ./prueba/*fastq.merged.gz ./prueba/R1*.seqprep.gz ./prueba/R2*.seqprep.gz | while read file; do echo """zcat $file | paste - - - - | gawk 'BEGIN {FS=\"\t\"}; { gsub(\"[[:alnum:]]\",\"2\",\$4); gsub(\"[[:punct:]]\",\"2\",\$4); print \$1\"\n\"\$2\"\n\"\$3\"\n\"\$4}' | seqtk seq -U | pigz -p 4 >$file.Q33"""; done >./prueba/prince.script3
	parallel --gnu -j 32 :::: ./prueba/prince.script3
	wait
	bfc -r kmers.bfc -t 32 <( pigz -p 32 -cd ./prueba/R1*.seqprep.gz.Q33 ) | seqtk seq -U | awk '{print (NR%4 == 1) ? "@1_" ++i  " 1:N:0:1": $0}' | pigz -p 6 >$F.prinseq.seqprep.bfck33.q33.fastq.gz
	bfc -r kmers.bfc -t 32 <( pigz -p 32 -cd ./prueba/R2*.seqprep.gz.Q33 ) | seqtk seq -U | awk '{print (NR%4 == 1) ? "@1_" ++i  " 2:N:0:1": $0}' | pigz -p 6 >$R.prinseq.seqprep.bfck33.q33.fastq.gz
	bfc -r kmers.bfc -t 32 <( pigz -p 32 -cd ./prueba/*fastq.merged.gz.Q33 ) | seqtk seq -U | awk '{print (NR%4 == 1) ? "@1_M_" ++i  " 3:N:0:1": $0}' | pigz -p 6 >$R.prinseq.merged.bfck33.q33.fastq.gz
	wait
	pigz -cd -p 14 ./prueba/*fastq.merged.gz | pigz -p 14 -1  >$R.prinseq.merged.fastq.gz
	pigz -cd -p 14 ./prueba/R1*.seqprep.gz | pigz -p 14 -1  >$F.prinseq.seqprep.fastq.gz
	pigz -cd -p 14 ./prueba/R2*.seqprep.gz | pigz -p 14 -1  >$R.prinseq.seqprep.fastq.gz
	cat ./prueba/R1*bad* | pigz -p 14 -1 >$F.prinseq.bad.fastq.gz
	cat ./prueba/R2*bad* | pigz -p 14 -1 >$R.prinseq.bad.fastq.gz
	cat ./prueba/*prince.log >$R.prince.log
	cat ./prueba/*prince.err >$R.prince.err
	cat ./prueba/*seqprep.log >$R.seqprep.log
	cat ./prueba/*seqprep.err >$R.seqprep.err
	echo "ready"
	wait
#	rm -rf ./prueba
}

############################################################################################
#cat *_1.clean.fq.gz >R1.fq.gz &&
#cat *_2.clean.fq.gz >R2.fq.gz &&
#/datana3/barefoot/codes/bbmap/repair.sh -Xmx300g in=R1.fq.gz in2=R2.fq.gz out=R1.bbrepair.fastq.gz out2=R2.bbrepair.fastq.gz outs=R3.bbrepair.fastq.gz &&
prince
