#!/usr/bin/env bash

if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: 7mafft_degap_PhyML <path/file_name of fasta file>"
else

FNAME=$1

cat > $FNAME.mafft_degap_PhyML.job <<'endmsg'
#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=10000
#SBATCH -o $FNAME.mafft_degap_PhyML.%j.out

mafft --thread 8 --genafpair --maxiterate 1000 --retree 8 --bl 30 $FNAME >$FNAME.mafft 2>$FNAME.mafft.err && 
t_coffee -other_pg seq_reformat -in $FNAME.mafft -action +rm_gap 70 >$FNAME.mafft.gaps70.fas 2>$FNAME.mafft.gaps70.err &&
cat $FNAME.mafft.gaps70.fas | perl -ane 'if(/\>(.*)/){$a++;print ">$a\_$1\n"}else{print;}' >$FNAME.mafft.gaps70.fasta &&
perl ../aux/fasta2phyml.pl $FNAME.mafft.gaps70.fasta &&
PhyML_3.0_linux64 -i $FNAME.mafft.gaps70.fas.phymlAln -d aa --quiet --search BEST 1> $FNAME.mafft.gaps70.fas.phymlAln.log 2> $FNAME.mafft.gaps70.fas.phymlAln.err


###############################################################################################
###############################################################################################
######################################  PhyML  ################################################
###############################################################################################
###############################################################################################
### NAME
### 	- PhyML v3.0_360-500M -
###
### 	''A simple, fast, and accurate algorithm to estimate
### 	large phylogenies by maximum likelihood''
###
### 	Stephane Guindon and Olivier Gascuel,
### 	Systematic Biology 52(5):696-704, 2003.
###
### 	Please cite this paper if you use this software in your publications.
###
### SYNOPSIS:
###
### 	phyml [command args]
###
### 	All the options below are optional (except '-i' if you want to use the command-line interface).
###
###
### Command options:
###
### 	-i (or --input) seq_file_name
### 		seq_file_name is the name of the nucleotide or amino-acid sequence file in PHYLIP format.
###
###
### 	-d (or --datatype) data_type
### 		data_type is 'nt' for nucleotide (default) and 'aa' for amino-acid sequences.
###
###
### 	-q (or --sequential)
### 		Changes interleaved format (default) to sequential format.
###
###
### 	-n (or --multiple) nb_data_sets
### 		nb_data_sets is an integer corresponding to the number of data sets to analyse.
###
###
### 	-p (or --pars)
### 		Use a minimum parsimony starting tree. This option is taken into account when the '-u' option
### 		is absent and when tree topology modifications are to be done.
###
### 	-b (or --bootstrap) int
### 		int >  0 : int is the number of bootstrap replicates.
### 		int =  0 : neither approximate likelihood ratio test nor bootstrap values are computed.
### 		int = -1 : approximate likelihood ratio test returning aLRT statistics.
### 		int = -2 : approximate likelihood ratio test returning Chi2-based parametric branch supports.
### 		int = -4 : SH-like branch supports alone.
###
###
### 	-m (or --model) model
### 		model : substitution model name.
### 		- Nucleotide-based models : HKY85 (default) | JC69 | K80 | F81 | F84 | TN93 | GTR | custom (*)
### 		(*) : for the custom option, a string of six digits identifies the model. For instance, 000000
### 		 corresponds to F81 (or JC69 provided the distribution of nucleotide frequencies is uniform).
### 		 012345 corresponds to GTR. This option can be used for encoding any model that is a nested within GTR.
###
### 		- Amino-acid based models : LG (default) | FLU | WAG | JTT | MtREV | Dayhoff | DCMut | RtREV | CpREV | VT
### 		 Blosum62 | MtMam | MtArt | HIVw |  HIVb | custom
###
###
### 	--aa_rate_file filename
### 		filename is the name of the file that provides the amino acid substitution rate matrix in PAML format.
### 		It is compulsory to use this option when analysing amino acid sequences with the custom' model.
###
###
### 	-f e, m, or fA fC fG fT
### 		e : the character frequencies are determined as follows :
### 		- Nucleotide sequences: (Empirical) the equilibrium base frequencies are estimated by counting
### 		 the occurence of the different bases in the alignment.
### 		- Amino-acid sequences: (Empirical) the equilibrium amino-acid frequencies are estimated by counting
### 		 the occurence of the different amino-acids in the alignment.
###
### 		m : the character frequencies are determined as follows :
### 		- Nucleotide sequences: (ML) the equilibrium base frequencies are estimated using maximum likelihood
### 		- Amino-acid sequences: (Model) the equilibrium amino-acid frequencies are estimated using
### 		 the frequencies defined by the substitution model.
###
### 		fA fC fG fT: only valid for nucleotide-based models. fA, fC, fG and fT are floating numbers that
### 		 correspond to the frequencies of A, C, G and T respectively.
###
###
### 	-t (or --ts/tv) ts/tv_ratio
### 		ts/tv_ratio : transition/transversion ratio. DNA sequences only.
### 		Can be a fixed positive value (ex:4.0) or e to get the maximum likelihood estimate.
###
###
### 	-v (or --pinv) prop_invar
### 		prop_invar : proportion of invariable sites.
### 		Can be a fixed value in the [0,1] range or e to get the maximum likelihood estimate.
###
###
### 	-c (or --nclasses) nb_subst_cat
### 		nb_subst_cat : number of relative substitution rate categories. Default : nb_subst_cat=1.
### 		Must be a positive integer.
###
###
### 	-a (or --alpha) gamma
### 		gamma : distribution of the gamma distribution shape parameter.
### 		Can be a fixed positive value or e to get the maximum likelihood estimate.
###
###
### 	-s (or --search) move
### 		Tree topology search operation option.
### 		Can be either NNI (default, fast) or SPR (a bit slower than NNI) or BEST (best of NNI and SPR search).
###
###
### 	-u (or --inputtree) user_tree_file
### 		user_tree_file : starting tree filename. The tree must be in Newick format.
###
###
### 	-o params
### 		This option focuses on specific parameter optimisation.
### 		params=tlr : tree topology (t), branch length (l) and rate parameters (r) are optimised.
### 		params=tl  : tree topology and branch length are optimised.
### 		params=lr  : branch length and rate parameters are optimised.
### 		params=l   : branch length are optimised.
### 		params=r   : rate parameters are optimised.
### 		params=n   : no parameter is optimised.
###
###
### 	--aa_rate_file aa_rate_file
### 		This option sets the amino-acids rates to use. The matrix must be in PAML format
### 		It is only valid if the chosen model is custom (-m option).
###
###
### 	--rand_start
### 		This option sets the initial tree to random.
### 		It is only valid if SPR searches are to be performed.
###
###
### 	--n_rand_starts num
### 		num is the number of initial random trees to be used.
### 		It is only valid if SPR searches are to be performed.
###
###
### 	--r_seed num
### 		num is the seed used to initiate the random number generator.
### 		Must be an integer.
###
###
### 	--print_site_lnl
### 		Print the likelihood for each site in file *_phyml_lk.txt.
###
###
### 	--print_trace
### 		Print each phylogeny explored during the tree search process
### 		in file *_phyml_trace.txt.
###
###
### 	--run_id ID_string
### 		Append the string ID_string at the end of each PhyML output file.
### 		This option may be useful when running simulations involving PhyML.
###
###
### 	--quiet
### 		No interactive question (for running in batch mode).
###
### PHYLIP-LIKE INTERFACE
###
### 	You can also use PhyML with no argument, in this case change the value of
### 	a parameter by typing its corresponding character as shown on screen.
###
### EXAMPLES
###
### 	DNA interleaved sequence file, default parameters :   ./phyml -i seqs1
### 	AA interleaved sequence file, default parameters :    ./phyml -i seqs2 -d aa
### 	AA sequential sequence file, with customization :     ./phyml -i seqs3 -q -d aa -m JTT -c 4 -a e
###
endmsg
echo "sbatch $FNAME.mafft_degap_PhyML.job"
fi
