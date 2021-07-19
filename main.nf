#!/usr/bin/env nextflow

// enable dsl2
nextflow.preview.dsl = 2

// include modules
include {printHelp} from './modules/help.nf'
include {makeFastqSearchPath} from './modules/util.nf'

// import subworkflows
include {NanoSeqQC} from './workflows/NanoSeqQC.nf'

if  (params.help){
    printHelp()
    exit 0
}

if (params.profile){
    println("Profile should have a single dash: -profile")
    System.exit(1)
}

if ( params.illumina ) {
   if ( !params.directory ) {
       println("Please supply a directory containing fastqs or CRAMs with --directory. Specify --cram if supplying a CRAMs directory")
       println("Use --help to print help")
       System.exit(1)
   }
   if ( (params.bed && ! params.ref) || (!params.bed && params.ref) ) {
       println("--bed and --ref must be supplied together")
       System.exit(1)
   }
} else {
       println("Please select a workflow with --illumina or use --help to print help")
       System.exit(1)
}       
       
       
 // main workflow
 workflow {
   if ( params.illumina ) {
       if (params.cram) {
           Channel.fromPath( "${params.directory}/**.cram" )
                  .map { file -> tuple(file.baseName, file) }
                  .set{ ch_cramFiles }
       }
       else {
           fastqSearchPath = makeFastqSearchPath( params.illuminaPrefixes, params.illuminaSuffixes, params.fastq_exts )

	   Channel.fromFilePairs( fastqSearchPath, flat: true)
	          .filter{ !( it[0] =~ /Undetermined/ ) }
	          .set{ ch_filePairs }
       }
   } else {
            println("Couldn't detect whether your profile. Use --directory to point to the fastq files directory.")
            System.exit(1)
   }
}

main:
  if ( params.illumina ) {
    if (params.cram ) {
      IlluminaCram(ch_cramFiles)
    }
    else {
      Illumina(ch_filePairs)
    }
  } else {
    println("Please select a workflow with --illumina")
  }
}
