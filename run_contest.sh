#!/usr/bin/env bash

data=dulak
echo $data
sleep 10
if [ $data == "henan" ]
then
	wgstumors=(3A 11A 13A 15A 17A 25A 29A 33A 37A 41A)
	wgsnormals=(4A 12A 14A 16A 18A 26A 30A 34A 38A 42A)
	bamdir=/fh/scratch/delete30/dai_j/henan
	ext=.merged.deduprealigned.bam
	for ((i=0;i<${#wgstumors[@]};i++))
	do
		normalbam=$bamdir/${wgsnormals[$i]}$ext
		tumorbam=$bamdir/${wgstumors[$i]}$ext
		echo sbatch /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/constest.sh $tumorbam $normalbam ${wgstumors[$i]}
		sbatch /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/constest.sh $tumorbam $normalbam ${wgstumors[$i]}
		sleep 1
	done
fi

if [ $data == "dulak" ]
then
	wgsnormals=(SRR1002719 SRR999433 SRR999687 SRR1000378 SRR1002786 SRR999559 SRR1001730 SRR10018461 SRR1002703 SRR999599 SRR1002792 SRR1001839 SRR9994281 SRR1002710 SRR9995631 SRR1021476)
	wgstumors=(SRR1001842 SRR1002713 SRR999423 SRR1001466 SRR1002670 SRR1001823 SRR999489 SRR1002343 SRR1002722 SRR1002656 SRR1002929 SRR999438 SRR1001915 SRR999594 SRR1001868 SRR1001635)

	bamdir=/fh/scratch/delete30/dai_j/dulak
	ext=.dedup.realigned.recal.bam
	for ((i=0;i<${#wgstumors[@]};i++))
	do
		normalbam=$bamdir/${wgsnormals[$i]}$ext
		tumorbam=$bamdir/${wgstumors[$i]}$ext
		
		echo sbatch /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/constest.sh $tumorbam $normalbam ${wgstumors[$i]}
		sbatch /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/constest.sh $tumorbam $normalbam ${wgstumors[$i]}
		sleep 1
	done
fi
