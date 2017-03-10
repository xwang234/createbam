#! /usr/bin/env bash

#for id in {3,4,11,12,13,14,15,16,17,18,25,26,29,30,33,34,37,38,41,42}
for id in {11,12,13,14,15,16,17,18,25,26,29,30,33,34,37,38,41,42}
do
	sample=${id}A
	echo sbatch /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/process2.sh $sample
	sbatch /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/process2.sh $sample
done



