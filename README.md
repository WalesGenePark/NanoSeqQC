# NanoSeqQC
A Nextflow pipeline for automatically running QC on Nano runs

WARNING - UNDER CURRENT DEVELOPMENT AND NOT FULLY FUNCTIONAL

large sections of nextflow coding are based off the excellent ncov2019-artic-nf pipeline `connor-lab/ncov2019-artic-nf`

#### Introduction
------------

The running of this will automatically take fastq reads from a Nano sequencing read, run FastP read diagnostics and trimming before performing some comparative statistics based on library metadata such as RIN and concentration.
Additionally, reads will be run through Kraken2 to confirm species profile (and lack of contamination!)

#### Quick-start

##### Illumina

`nextflow run WalesGenePark/NanoSeqQC --profile singularity,slurm --prefix "job_output" --directory /path/to/reads --outdir /path/to/outfile`  
  
Options  
--fastpInputVer (paired, single, merged)


------------

#### Installation

An up-to-date version of Nextflow is required because the pipeline is written in DSL2. Following the instructions at https://www.nextflow.io/ to download and install Nextflow should get you a recent-enough version.

1: git clone the repository  
2: chmod +x the two scripts in NanoSeqQC/scripts/  
3: run the singularity build  

#### Executor

By default, the pipeline runs locally unless specifying `-profile slurm` to send to a SLURM cluster.

#### Config

Common config options are set in 'conf/base.config'.
