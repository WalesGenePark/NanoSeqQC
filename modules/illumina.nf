process fastpTrimming {
  /**
  * Runs fastp on samples, which performs a QC check on input fastq pairs, trims reads, and rechecks QC on trimmed reads (https://github.com/OpenGene/fastp)
  * @input tuple(sampleName, path(forward), path(reverse))
  * @output fastpTrimming.out.trimmed tuple(sampleName, path("*_val_1.fq.gz"), path("_val_2.fq.gz"))
  */
  
  tag { sampleName }
  
  publishDir "${params.outdir}/${task.process.replaceAll(":","_")}", pattern: '*_val_{1,2}.fq', mode: 'copy'
  
  cpus 2
  
  input:
  tuple(sampleName, path(forward), path(reverse))
  
  output:
  tuple(sampleName, path("*_val_1.f"), path("_val_1.fq")) optional true
  
  script:
  """if {{ \$(gunzip -c ${forward} | head -n4 | wc -l) -eq 0 ]]; then
    exit 0
  else
    fastp --in1 $forward --in2 $reverse --out1 ${sampleName}_val_1.fq --out2 ${sampleName}_val_1.fq --thread 2 -h ${sampleName}.html -j ${sampleName}.json
  fi
  """
}


process krakenSamples {
  /**
  * Runs Kraken2 on samples (https://github.com/DerrickWood/kraken2) (https://github.com/jenniferlu717/KrakenTools) (https://github.com/marbl/Krona/releases).
  */
  
  tag { sampleName }
  
  cpus 2
  
  publishDir "$params.outdir/$task.process.replaceAll(":","_")}", pattern: "${sampleName}.krona.html", mode: 'copy'
  
  input:
    tuple sampleName, path(forward), path(reverse)
    
  output:
    tuple(sampleName, path("${sampleName}.krona.html"))

  script:
    """
    kraken2 --db params.krakendb $forward $reverse --threads 2 --use-names --output ${sampleName}.krona.txt --report ${sampleName}.krona.report.txt --unclassified-out ${sampleName}.unclassified.fastq --classified-out ${sampleName}.classified.fastq
    python kreport2krona.py -r ${sampleName}.krona.report.txt -o ${sampleName}.krona.out
    ktImportText ${sampleName}.krona.report.out -o ${sampleName}.krona.html
    """
 }

process multiQC {
  /**
  * Runs MultiQC on the outputs from fastp reports, performing additional comparison metrics from lab-derived measurements e.g. RIN number
  */
  
  tag { outdir }
  
  cpus 2
  
  publishDir "${params.outdir}/${task.process.replaceAll(":","_")}", pattern: "${outdir}.MultiQC.html", mode: 'copy'
  
  input:
  tuple outdir, path(sampleName.html)
  
  output:
  tuple(outdir, path("${outdir}.MultiQC.html"))
  
  script:
  """
  multiqc ${outdir}
  """
}