 #!/usr/bin/env nextflow

// enable dsl2
nextflow.preview.dsl = 2

// import modules

include {fastpTrimming} from '../modules/illumina.nf'
include {krakenSamples} from '../modules/illumina.nf'

include {multiQC} from '../modules/illumina.nf
