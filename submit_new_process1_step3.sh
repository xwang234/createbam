#/usr/bin/env bash

#sample=${1?"13A-42A"}
step=3
direction=1 # just pick 1 or 2
#for id in {{21..26},{28..30},32,{34..37}}
#for id in {13,14,15,16,17,18,23,24,25,26,29,30,33,34,35,36,37,38,41,42}
for id in {13,14,15,16,33,34}
do
	sample=${id}A	
	echo $sample
	fastq_name=()
	for file in $sample/*.fq.gz
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
		echo sbatch ./process1_new.sh $sample $fastq_name $direction $step
		sbatch ./process1_new.sh $sample $fastq_name $direction $step

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
	

