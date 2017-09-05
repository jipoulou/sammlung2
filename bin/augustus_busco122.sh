#!/usr/bin/env bash

FNAME=$1

######### path to augustus executable #############
AUGUSTUS=/home/Jose.Grau/augustus/augustus-3.1/src/augustus

##### creates job file with some instructions for configuring parameters.

echo "#!/bin/bash
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=2000
#SBATCH -o $FNAME.augustus.job.%j.out

######### print date ##########
date +%x_%H:%M:%S

###### run parallel augustus ####################################
cat $FNAME | \
parallel --gnu -j 32 --recstart '>' --pipe \
$AUGUSTUS \
--species=schistosoma \
--progress=true /dev/stdin \
--gff3=on \
--uniqueGeneId=true \
>$FNAME.augustus

#### extract from augustus gene predictor #########
perl /home/Jose.Grau/augustus/augustus-3.1/scripts/getAnnoFasta.pl $FNAME.augustus --seqfile=$FNAME

############### BUSCO #############################
python3 /home/Jose.Grau/BUSCO_v1.22/BUSCO_v1.22.py --cpu 32 -o $FNAME.augustus.aa.busco.out --genome $FNAME.augustus.aa  -f -l /home/Jose.Grau/BUSCO_v1.22/metazoa -m OGS

######### print date ##########
date +%x_%H:%M:%S




############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
#####
#####   AUGUSTUS (3.1.0) is a gene prediction tool
#####   written by Mario Stanke, Oliver Keller, Stefanie König and Lizzy Gerischer.
#####
#####   usage:
#####   augustus [parameters] --species=SPECIES queryfilename
#####
#####   'queryfilename' is the filename (including relative path) to the file containing the query sequence(s)
#####   in fasta format.
#####
#####   SPECIES is an identifier for the species. Use --species=help to see a list.
#####
#####   parameters:
#####   --strand=both, --strand=forward or --strand=backward
#####   --genemodel=partial, --genemodel=intronless, --genemodel=complete, --genemodel=atleastone or --genemodel=exactlyone
#####     partial      : allow prediction of incomplete genes at the sequence boundaries (default)
#####     intronless   : only predict single-exon genes like in prokaryotes and some eukaryotes
#####     complete     : only predict complete genes
#####     atleastone   : predict at least one complete gene
#####     exactlyone   : predict exactly one complete gene
#####   --singlestrand=true
#####     predict genes independently on each strand, allow overlapping genes on opposite strands
#####     This option is turned off by default.
#####   --hintsfile=hintsfilename
#####     When this option is used the prediction considering hints (extrinsic information) is turned on.
#####     hintsfilename contains the hints in gff format.
#####   --AUGUSTUS_CONFIG_PATH=path
#####     path to config directory (if not specified as environment variable)
#####   --alternatives-from-evidence=true/false
#####     report alternative transcripts when they are suggested by hints
#####   --alternatives-from-sampling=true/false
#####     report alternative transcripts generated through probabilistic sampling
#####   --sample=n
#####   --minexonintronprob=p
#####   --minmeanexonintronprob=p
#####   --maxtracks=n
#####     For a description of these parameters see section 4 of README.TXT.
#####   --proteinprofile=filename
#####     When this option is used the prediction will consider the protein profile provided as parameter.
#####     The protein profile extension is described in section 7 of README.TXT.
#####   --progress=true
#####     show a progressmeter
#####   --gff3=on/off
#####     output in gff3 format
#####   --predictionStart=A, --predictionEnd=B
#####     A and B define the range of the sequence for which predictions should be found.
#####   --UTR=on/off
#####     predict the untranslated regions in addition to the coding sequence. This currently works only for a subset of species.
#####   --noInFrameStop=true/false
#####     Do not report transcripts with in-frame stop codons. Otherwise, intron-spanning stop codons could occur. Default: false
#####   --noprediction=true/false
#####     If true and input is in genbank format, no prediction is made. Useful for getting the annotated protein sequences.
#####   --uniqueGeneId=true/false
#####     If true, output gene identifyers like this: seqname.gN
#####
#####   For a complete list of parameters, type "augustus --paramlist".
#####   An exhaustive description can be found in the file README.TXT.
#####

####   augustus [parameters] --species=SPECIES queryfilename
####
####   where SPECIES is one of the following identifiers
####
####   identifier                               | species
####   -----------------------------------------|----------------------
####   human                                    | Homo sapiens
####   fly                                      | Drosophila melanogaster
####   arabidopsis                              | Arabidopsis thaliana
####   brugia                                   | Brugia malayi
####   aedes                                    | Aedes aegypti
####   tribolium                                | Tribolium castaneum
####   schistosoma                              | Schistosoma mansoni
####   tetrahymena                              | Tetrahymena thermophila
####   galdieria                                | Galdieria sulphuraria
####   maize                                    | Zea mays
####   toxoplasma                               | Toxoplasma gondii
####   caenorhabditis                           | Caenorhabditis elegans
####   (elegans)                                | Caenorhabditis elegans
####   aspergillus_fumigatus                    | Aspergillus fumigatus
####   aspergillus_nidulans                     | Aspergillus nidulans
####   (anidulans)                              | Aspergillus nidulans
####   aspergillus_oryzae                       | Aspergillus oryzae
####   aspergillus_terreus                      | Aspergillus terreus
####   botrytis_cinerea                         | Botrytis cinerea
####   candida_albicans                         | Candida albicans
####   candida_guilliermondii                   | Candida guilliermondii
####   candida_tropicalis                       | Candida tropicalis
####   chaetomium_globosum                      | Chaetomium globosum
####   coccidioides_immitis                     | Coccidioides immitis
####   coprinus                                 | Coprinus cinereus
####   coprinus_cinereus                        | Coprinus cinereus
####   cryptococcus_neoformans_gattii           | Cryptococcus neoformans gattii
####   cryptococcus_neoformans_neoformans_B     | Cryptococcus neoformans neoformans
####   cryptococcus_neoformans_neoformans_JEC21 | Cryptococcus neoformans neoformans
####   (cryptococcus)                           | Cryptococcus neoformans
####   debaryomyces_hansenii                    | Debaryomyces hansenii
####   encephalitozoon_cuniculi_GB              | Encephalitozoon cuniculi
####   eremothecium_gossypii                    | Eremothecium gossypii
####   fusarium_graminearum                     | Fusarium graminearum
####   (fusarium)                               | Fusarium graminearium
####   histoplasma_capsulatum                   | Histoplasma capsulatum
####   (histoplasma)                            | Histoplasma capsulatum
####   kluyveromyces_lactis                     | Kluyveromyces lactis
####   laccaria_bicolor                         | Laccaria bicolor
####   lodderomyces_elongisporus                | Lodderomyces elongisporus
####   magnaporthe_grisea                       | Magnaporthe grisea
####   neurospora_crassa                        | Neurospora crassa
####   (neurospora)                             | Neurospora crassa
####   phanerochaete_chrysosporium              | Phanerochaete chrysosporium
####   (pchrysosporium)                         | Phanerochaete chrysosporium
####   pichia_stipitis                          | Pichia stipitis
####   rhizopus_oryzae                          | Rhizopus oryzae
####   saccharomyces_cerevisiae_S288C           | Saccharomyces cerevisiae
####   saccharomyces_cerevisiae_rm11-1a_1       | Saccharomyces cerevisiae
####   (saccharomyces)                          | Saccharomyces cerevisiae
####   schizosaccharomyces_pombe                | Schizosaccharomyces pombe
####   ustilago_maydis                          | Ustilago maydis
####   (ustilago)                               | Ustilago maydis
####   yarrowia_lipolytica                      | Yarrowia lipolytica
####   nasonia                                  | Nasonia vitripennis
####   tomato                                   | Solanum lycopersicum
####   chlamydomonas                            | Chlamydomonas reinhardtii
####   amphimedon                               | Amphimedon queenslandica
####   pea_aphid                                | Acyrthosiphon pisum





" >$FNAME.augustus.job

echo "chmod 755 $FNAME.augustus.job && nohup ./$FNAME.augustus.job 1>$FNAME.augustus.job.log 2>$FNAME.augustus.job.err &"
