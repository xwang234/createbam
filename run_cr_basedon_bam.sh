#!/usr/bin/env bash

data="escc"

echo $data
sleep 10

if [[ $data == "henan" ]]
then
  folder=/fh/scratch/delete30/dai_j/henan
  tumors=()
  tumors=(3A 11A 13A 15A 17A 25A 29A 33A 37A 41A)
  normals=(4A 12A 14A 16A 18A 26A 30A 34A 38A 42A)
  normalfiles=()
  tumorfiles=()
  for ((i=0;i<${#tumors[@]};i++))
  do
    normalfiles[$i]=/fh/scratch/delete30/dai_j/henan/${normals[$i]}.merged.deduprealigned.bam
    tumorfiles[$i]=/fh/scratch/delete30/dai_j/henan/${tumors[$i]}.merged.deduprealigned.bam
  done
fi

if [[ $data == "dulak" ]]
then
  folder=/fh/scratch/delete30/dai_j
  normals=(SRR1002719 SRR999433 SRR999687 SRR1000378 SRR1002786 SRR999559 SRR1001730 SRR10018461 SRR1002703 SRR999599 SRR1002792 SRR1001839 SRR9994281 SRR1002710 SRR9995631 SRR1021476)
  tumors=(SRR1001842 SRR1002713 SRR999423 SRR1001466 SRR1002670 SRR1001823 SRR999489 SRR1002343 SRR1002722 SRR1002656 SRR1002929 SRR999438 SRR1001915 SRR999594 SRR1001868 SRR1001635)
  normalfiles=()
  tumorfiles=()
  for ((i=0;i<${#tumors[@]};i++))
  do
    normalfiles[$i]=/fh/scratch/delete30/dai_j/dulak/${normals[$i]}.dedup.realigned.recal.bam
    tumorfiles[$i]=/fh/scratch/delete30/dai_j/dulak/${tumors[$i]}.dedup.realigned.recal.bam
  done
fi

if [[ $data == "escc" ]]
then
  folder=/fh/scratch/delete30/dai_j
  ids=( {{1..6},{8..18}} )
  normals=()
  tumors=()
  for ((i=0;i<${#ids[@]};i++))
  do
    normals[$i]=N${ids[$i]}
    tumors[$i]=T${ids[$i]}
  done
  normalfiles=()
  tumorfiles=()
  for ((i=0;i<${#tumors[@]};i++))
  do
    normalfiles[$i]=/fh/scratch/delete30/dai_j/escc/${normals[$i]}.merged.deduprealigned.bam
    tumorfiles[$i]=/fh/scratch/delete30/dai_j/escc/${tumors[$i]}.merged.deduprealigned.bam
  done
fi

cd $folder
for ((i=0;i<${#tumors[@]};i++))
do
  sbatch /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/cr_basedon_bam.sh ${normalfiles[$i]} ${tumorfiles[$i]}
  sleep 1
done




