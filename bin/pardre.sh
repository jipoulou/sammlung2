#!/usr/bin/env bash



### Usage: ParDRe -i readFile1 [-p readFile2] [options]
### Input:
### 	-i <string> readFile1 (sequence file in FASTA/FASTQ format)
### 	-p <string> readFile2 (sequence file in FASTA/FASTQ format for paired scenarios)
### Computation:
### 	-m <int> (number of allowed missmatches, default = 0)
### 	-l <int> (prefix length used for computation, default = 20)
### 	-q <int> (quality threshold under which bases are considered 'N', default = 3)
### 	-b <int> (number of sequences that will be read in a block, default = 50000)
### 	-t <int> (number of threads per process, default = 1)
### Others:
### 	-h <print out the usage of the program)
###