#/usr/bin/env bash

#sample=${1?"13A-42A"}
step=2
samples=(3A 4A 11A 12A 13A 14A 15A 16A 17A 18A 25A 26A 29A 30A 33A 34A 37A 38A 41A 42A)
for sample in ${samples[@]}
do
  echo $sample
  fastq_names=()
  for file in $sample/*.sorted.bam
  do
    #echo $file
    file1=$(basename $file)
    len=${#file1}
    ((len=len-11))
    file2=${file1:0:$len}
    #echo $file2
    fastq_names+=($file2)
  done
 
  for ((i=0;i<${#fastq_names[@]};i++))
  do
    fastq_name=${fastq_names[$i]}
    echo $sample
    echo $fastq_name
    sleep 1    
    echo sbatch /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/process1_new.sh $sample $fastq_name $step
    sbatch /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/process1_new.sh $sample $fastq_name $step

  done  
done


#  i=1
#  folder=${folders[$i]#$sample}
#  folder=${folder//\//}
#  
#  echo $sample
#  echo $folder
#  sleep 1    
#  #sbatch ./process.sh $sample $folder $direction
#  ./process.sh $sample $folder
  

