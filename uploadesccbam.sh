#!/usr/bin/env bash
module load python2/2.7.8

origdir=/fh/scratch/delete30/dai_j/escc

destdir=/fasqfiles/bamfiles
echo "start upload..."

for file in $origdir/*.bai
do
    file1=$(basename $file)
    echo $file1
    swc upload $file $destdir/$file1
done



#remember to remove files in tmpdir
