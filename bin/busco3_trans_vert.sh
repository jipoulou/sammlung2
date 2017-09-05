#!/usr/bin/env bash

FNAME=$1
BUSCO=/datana3/barefoot/codes/busco3.0.2.b/scripts/run_BUSCO.py
LINEAGE=/datana3/barefoot/codes/busco3.0.2.b/tetrapoda_odb9

echo "'""
#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=1600
#SBATCH -o $FNAME.Busco_trans_vertebrate.job.%j.out
#SBATCH -e $FNAME.Busco_trans_vertebrate.job.%j.err
#SBATCH -J BUSCO.$FNAME

python3 $BUSCO \
--cpu 32 \
-o $FNAME.busco.out \
-i $FNAME -f \
-l $LINEAGE \
-m trans \
1>$FNAME.vertebrates.busco.log \
2>$FNAME.vertebrates.busco.err

##################################################################################################################################################################
##################################################################################################################################################################
##################################################################################################################################################################
### usage: python BUSCO.py -i [SEQUENCE_FILE] -l [LINEAGE] -o [OUTPUT_NAME] -m [MODE] [OTHER OPTIONS]
###
### Welcome to BUSCO 3.0.2: the Benchmarking Universal Single-Copy Ortholog assessment tool.
### For more detailed usage information, please review the README file provided with this distribution and the BUSCO user guide.
###
### optional arguments:
###   -i FASTA FILE, --in FASTA FILE
###                         Input sequence file in FASTA format. Can be an assembled genome or transcriptome (DNA), or protein sequences from an annotated gene set.
###   -c N, --cpu N         Specify the number (N=integer) of threads/cores to use.
###   -o OUTPUT, --out OUTPUT
###                         Give your analysis run a recognisable short name. Output folders and files will be labelled with this name. WARNING: do not provide a path
###   -e N, --evalue N      E-value cutoff for BLAST searches. Allowed formats, 0.001 or 1e-03 (Default: 1e-03)
###   -m MODE, --mode MODE  Specify which BUSCO analysis mode to run.
###                         There are three valid modes:
###                         - geno or genome, for genome assemblies (DNA)
###                         - tran or transcriptome, for transcriptome assemblies (DNA)
###                         - prot or proteins, for annotated gene sets (protein)
###   -l LINEAGE, --lineage_path LINEAGE
###                         Specify location of the BUSCO lineage data to be used.
###                         Visit http://busco.ezlab.org for available lineages.
###   -f, --force           Force rewriting of existing files. Must be used when output files with the provided name already exist.
###   -r, --restart         Restart an uncompleted run. Not available for the protein mode
###   -sp SPECIES, --species SPECIES
###                         Name of existing Augustus species gene finding parameters. See Augustus documentation for available options.
###   --augustus_parameters AUGUSTUS_PARAMETERS
###                         Additional parameters for the fine-tuning of Augustus run. For the species, do not use this option.
###                         Use single quotes as follow: '--param1=1 --param2=2', see Augustus documentation for available options.
###   -t PATH, --tmp_path PATH
###                         Where to store temporary files (Default: ./tmp/)
###   --limit REGION_LIMIT  How many candidate regions (contig or transcript) to consider per BUSCO (default: 3)
###   --long                Optimization mode Augustus self-training (Default: Off) adds considerably to the run time, but can improve results for some non-model organisms
###   -q, --quiet           Disable the info logs, displays only errors
###   -z, --tarzip          Tarzip the output folders likely to contain thousands of files
###   --blast_single_core   Force tblastn to run on a single core and ignore the --cpu argument for this step only. Useful if inconsistencies when using multiple threads are noticed
###   -v, --version         Show this version and exit
###   -h, --help            Show this help message and exit
""'" >$FNAME.Busco_trans_vertebrate.job \
&& \
echo "sbatch $FNAME.Busco_trans_vertebrate.job"

