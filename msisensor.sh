#!/usr/bin/env bash
#SBATCH -t 1-0
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

normalbam=${1?"normalbam"}
tumorbam=${2?"tumorbam"}
output=${3?"output"}

msisensor=/fh/fast/dai_j/CancerGenomics/Tools/msisensor/binary/msisensor_Linux_x86_64

$msisensor msi -d /fh/fast/dai_j/CancerGenomics/Tools/msisensor/hg19.microsate.sites -n $normalbam -t $tumorbam -q 2 -b 4 -f 0.1 -o $output
