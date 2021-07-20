 #!/usr/bin/env nextflow

// enable dsl2
nextflow.preview.dsl = 2

// import modules

include {fastpTrimming} from '../modules/illumina.nf'
include {krakenSamples} from '../modules/illumina.nf'

include {multiQC} from '../modules/illumina.nf'

// check kraken index exists
workflow checkReferenceFiles {
if ( params.krakendb ) {
 Channel.fromPath(params.krakendb)
   .set{ ch_krakendbfolder }
} else {
 println "No Kraken database detected" && exit 0
}

emit:
 krakendb = ch_krakendbfolder
 }
 
 workflow sequenceAnalysis {
  take:
    ch_filePairs
    ch_krakendbfolder
    
  main:
   fastpTrimming(ch_filePairs)
   
   krakenSamples(fastpTrimming.out.trimmed(ch_krakendbfolder))
   
   multiQC(fastpTrimming.out.trimmed(ch_krakendbfolder))
   }
