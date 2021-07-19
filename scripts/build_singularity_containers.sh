
#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BASEDIR=$(dirname $SCRIPTPATH)

WORKFLOWS="illumina"

for WORKFLOW in ${WORKFLOWS}; do 
    singularity build --remote ${BASEDIR}/NanoSeqQC-${WORKFLOW}.sif ${BASEDIR}/environments/${WORKFLOW}/Singularity
done

for WORKFLOW in ${WORKFLOWS}; do
    echo "Built container ${BASEDIR}/NAnoSeqQC-${WORKFLOW}.sif"
done
