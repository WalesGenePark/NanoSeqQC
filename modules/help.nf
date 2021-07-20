def printHelp() {
  log.info"""
  Usage:
    nextflow run WalesGenePark/NanoSeqQC -profile (singularity,slurm) ( --illumina ) --prefix [prefix] [workflow-options]
  Description:
    Peorm QC metrics on Illumina sequencing reads including read-depth, read-quality, perorm quality trimming, generate associated metric associations with laboratory measurements and kraken2 analysis.
    
    All options set via CLI can be set in conf directory
  Nextflow arguments (single DASH):
    -profile                  Allowed values: singularity, slurm
  Mandatory workflow arguments (mutually exclusive):
    --illumina                Run the Illumina workflow
    --nanopore                In development!
  
  Illumina workflow options:
    Mandatory:
      --prefix                A (unique) string prefix for output files.
                              Sequencing run name is a good choice e.g DDMMYY_MACHINEID_RUN_FLOWCELLID.
      --directory             Path to a directory containing paired-end Illumina reads. 
                              Reads will be found and paired RECURSIVELY beneath this directory.
    Optional:
      --outdir                Output directory (Default: ./results)
      
      --illuminaKeepLen       Length (bp) of reads to keep after primer trimming (Default: 20)
      --illuminaQualThreshold Sliding window quality threshold for keeping 
                              reads after primer trimming (Default: 20)
      
  """.stripIndent()
}
