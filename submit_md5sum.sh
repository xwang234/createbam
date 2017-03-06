#!/usr/bin/env bash

#for id in {31,36,38,39,40,41,42}
#do
#	sample=${id}A	
#	echo $sample
#	fastq_name=()
#	for file in $sample/*.fq.gz
#	do
		#echo $file
#		file1=$(basename $file)
#		len=${#file1}
#		((len=len-8))
#		file2=${file1:0:$len}
#		#echo $file2
#		fastq_name+=($file2)
#	done
#	fastq_name_uniq=($(printf "%s\n" "${fastq_name[@]}" | sort -u))
#
#	for ((i=0;i<${#fastq_name_uniq[@]};i++))
#	do
#		echo sbatch ./fastqc.sh $sample/${fastq_name}_1.fq.gz
#		sbatch ./fastqc.sh $sample/${fastq_name}_1.fq.gz
#		echo sbatch ./fastqc.sh $sample/${fastq_name}_2.fq.gz
#		sbatch ./fastqc.sh $sample/${fastq_name}_2.fq.gz
#		echo sbatch ./fastqc.sh $sample/${fastq_name}.dedup.realigned.recal.bam
#		sbatch ./fastqc.sh $sample/${fastq_name}.dedup.realigned.recal.bam
#		sleep 1
#	done
#done

#wgsnormals=(2A 4A 6A 8A 10A 12A 14A 16A 18A 20A 22A 24A 26A 28A 30A 32A 34A 36A 38A 40A 42A)
#wgstumors=(1A 3A 5A 7A 9A 11A 13A 15A 17A 19A 21A 23A 25A 27A 29A 31A 33A 35A 37A 39A 41A)

wgsnormals=(4A 12A 14A 16A 18A 26A 30A 34A 38A 42A)
wgstumors=(3A 11A 13A 15A 17A 25A 29A 33A 37A 41A)
#           0  1   2   3   4   5   6   7   8   9

#Tumors: 3,11,13,15,17,23,25,29,33,35,37,41
#for i in {1,5,6,7,8,11,12,14,16,17,18,20}
#do
#	normal=${wgsnormals[$i]}
#	tumor=${wgstumors[$i]}
#	echo "$normal $tumor"
#	#sbatch ./flagstat.sh $normal.merged.deduprealigned.bam
#	#sbatch ./flagstat.sh $tumor.merged.deduprealigned.bam
#done


#for id in {13,14,15,16,17,18,23,24,25,26,29,30,33,34,35,36,37,38,41,42}
#for id in {13,14,15,16,17,18,25,26,29,30,33,34,37,38,41,42}
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
		echo sbatch ./md5sum.sh $sample/${fastq_name}_1.fq.gz
		sbatch ./md5sum.sh $sample/${fastq_name}_1.fq.gz
		echo sbatch ./md5sum.sh $sample/${fastq_name}_2.fq.gz
		sbatch ./md5sum.sh $sample/${fastq_name}_2.fq.gz
		#echo sbatch ./flagstat.sh $sample/$fastq_name.sam
		#sbatch ./flagstat.sh $sample/$fastq_name.sam
		
		sleep 1
	done
done
