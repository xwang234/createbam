#! /usr/bin/env bash

#tumors=(13 15 17 23 25 29 33 35 37 41)
#normals=(14 16 18 24 26 30 34 36 38 42)
#tumors=(17 23 25 29 37 41)
#normals=(18 24 26 30 38 42)
tumors=(3 11 13 15 17 25 29 33 37 41)
normals=(4 12 14 16 18 26 30 34 38 42)

#for id in {0..9}
#for id in {3,4,7,8,9}
for id in {2,5,6}
do
	tumor=${tumors[$id]}A
	normal=${normals[$id]}A
	tumorbam=/fh/scratch/delete30/dai_j/henan/$tumor/$tumor.merged.dedup.bam
	normalbam=/fh/scratch/delete30/dai_j/henan/$normal/$normal.merged.dedup.bam
	echo sbatch /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/process3.sh $tumor $normal $tumorbam $normalbam
	sbatch /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/process3.sh $tumor $normal $tumorbam $normalbam
done
