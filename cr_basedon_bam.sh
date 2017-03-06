#! /usr/bin/env bash
#SBATCH -t 5-5
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

normalfile=${1?"normalbam"}
tumorfile=${2?"tumorbam"}

windowsize=10000

dictfile=/fh/fast/dai_j/CancerGenomics/Tools/database/reference/compact/ucsc.hg19.compact.dict
tmp=($(awk '{ if (NR>1) print $3 }' $dictfile ))
declare -a chrlen
for (( i=0;i<${#tmp[@]};i++ ))
do
	tmp1=${tmp[$i]}	
	chrlen[$i]=${tmp1:3}
done
chrs=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y)

echo $normalfile
echo $tumorfile
if [[ ! -f $normalfile || ! -f $tumorfile ]];then exit 1;fi
output=$tumorfile.$windowsize.crq1.txt #samtools -q 1
#if [[ -f $output ]];then rm $output;fi
if [[ ! -s $output ]]
then
	echo -e "chr\tstart\tend\tnormalcount\ttumorcount\tratio" >$output
	for (( i=0; i<${#chrlen[@]}; i++ ))
	do
		chr=chr${chrs[$i]}
		start=1
		while [[ $start -lt ${chrlen[$i]} ]]
		do
			((end=start+windowsize-1))
			L=$chr:${start}-${end}
			ncount=$(samtools view -c -F 0xD04 -q 1 $normalfile $L)
			tcount=$(samtools view -c -F 0xD04 -q 1 $tumorfile $L)
			if [[ $ncount -eq 0 ]]
			then
				ratio="NA"
			else
				ratio=$(perl -E "say $tcount/$ncount")
			fi
			echo -e "$chr\t${start}\t${end}\t$ncount\t$tcount\t$ratio">>$output
			((start=start+windowsize))
		done
	done
else
	#continue with what have been done	
	line=$(tail -1 $output)
	echo $line
	startchr=$(echo $line |awk '{print $1}' - )
	idxchr=${startchr:3}
	#current idx of chr	
	((idxchr=idxchr-1))
	if [[ $startchr == "chrX" ]];then idxchr=22;elif [[ $startchr == "chrY" ]];then idxchr=23;fi 
	echo $idxchr
	startpos=$(echo $line |awk '{print $2}' -)
	((startpos=startpos+windowsize))
	echo $startpos
	#complete the current chr
	chr=chr${chrs[$idxchr]}
	start=$startpos
	while [[ $start -lt ${chrlen[$idxchr]} ]]
	do
		((end=start+windowsize-1))
		L=$chr:${start}-${end}
		ncount=$(samtools view -c -F 0xD04 -q 1 $normalfile $L)
		tcount=$(samtools view -c -F 0xD04 -q 1 $tumorfile $L)
		if [[ $ncount -eq 0 ]]
		then
			ratio="NA"
		else
			ratio=$(perl -E "say $tcount/$ncount")
		fi
		echo -e "$chr\t${start}\t${end}\t$ncount\t$tcount\t$ratio">>$output
		((start=start+windowsize))
	done
	((chridx=idxchr+1))
	for (( i=chridx; i<${#chrlen[@]}; i++ ))
	do
		chr=chr${chrs[$i]}
		start=1
		while [[ $start -lt ${chrlen[$i]} ]]
		do
			((end=start+windowsize-1))
			L=$chr:${start}-${end}
			ncount=$(samtools view -c -F 0xD04 -q 1 $normalfile $L)
			tcount=$(samtools view -c -F 0xD04 -q 1 $tumorfile $L)
			if [[ $ncount -eq 0 ]]
			then
				ratio="NA"
			else
				ratio=$(perl -E "say $tcount/$ncount")
			fi
			echo -e "$chr\t${start}\t${end}\t$ncount\t$tcount\t$ratio">>$output
			((start=start+windowsize))
		done
	done
fi
