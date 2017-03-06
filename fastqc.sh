#!/usr/bin/env bash

#SBATCH -t 0-5
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

myfile=${1?"filename"}
fastqc $myfile
echo "done"
