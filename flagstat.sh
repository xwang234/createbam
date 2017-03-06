#!/usr/bin/env bash

#SBATCH -t 0-5
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

myfile=${1?"filename"}
samtools flagstat $myfile > $myfile.flagstat.txt
#for sam files
#/fh/fast/dai_j/CancerGenomics/Tools/samstat-1.5.1/src/samstat $myfile
echo "done"
