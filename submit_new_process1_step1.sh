#/usr/bin/env bash

#sample=${1?"13A-42A"}
step=1

samples=(13A 14A 15A 16A 17A 18A 25A 26A 29A 30A 33A 34A 37A 38A 41A 42A)
#samples=(3A 4A 11A 12A)
for sample in ${samples[@]}
do
	echo $sample
	fastq_name=()
	for file in $sample/*.fq.gz #for new format	
	#for file in $sample/*/*.fq.gz #for 3 4 11 12 old format
	do
		#echo $file
		file1=$(basename $file)
		len=${#file1}
		((len=len-8))
		file2=${file1:0:$len}
		#echo $file2
		fastq_name+=($file2)
	done
	fastq_name_uniq=($(printf "%s\n" "${fastq_name[@]}" | sort -u))

	for ((i=0;i<${#fastq_name_uniq[@]};i++))
	do
		fastq_name=${fastq_name_uniq[$i]}
		echo $sample
		echo $fastq_name
		   
		sleep 1		
		echo sbatch -n 1 -c 1 /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/process1_new.sh $sample $fastq_name $step
		sbatch -n 1 -c 1 /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/process1_new.sh $sample $fastq_name $direction $step
#		#./process.sh $sample $folder
	done	
	
done


#	i=1
#	folder=${folders[$i]#$sample}
#	folder=${folder//\//}
#	
#	echo $sample
#	echo $folder
#	sleep 1		
#	#sbatch ./process.sh $sample $folder $direction
#	./process.sh $sample $folder
	

