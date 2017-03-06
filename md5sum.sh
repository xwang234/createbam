#!/usr/bin/env bash

#SBATCH -t 0-1
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

myfile=${1?"filename"}
md5sum $myfile > $myfile.md5new.txt
echo "done"
