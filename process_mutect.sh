#! /usr/bin/env bash
#SBATCH -t 0-2
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

#script used to transfer mutect ouput to annovar format
transformat=/fh/fast/dai_j/CancerGenomics/Tools/wang/trans_Mutect_Annovar.pl
annovardir=/fh/fast/dai_j/CancerGenomics/Tools/annovar

#wgsnormals=(SRR1002719 SRR999433 SRR999687 SRR1000378 SRR1002786 SRR999559 SRR1001730 SRR10018461 SRR1002703 SRR999599 SRR1002792 SRR1001839 SRR9994281 SRR1002710 SRR9995631 SRR1021476)
#wgstumors=(SRR1001842 SRR1002713 SRR999423 SRR1001466 SRR1002670 SRR1001823 SRR999489 SRR1002343 SRR1002722 SRR1002656 SRR1002929 SRR999438 SRR1001915 SRR999594 SRR1001868 SRR1001635)
wgsnormals=(2A 4A 6A 8A 10A 12A)
wgstumors=(1A 3A 5A 7A 9A 11A)

wesnormals=(SRR910050 SRR915212 SRR913342 SRR912683 SRR912544 SRR915497 SRR910232 SRR911791 SRR913772 SRR910119 SRR908454 SRR910787 SRR912469 SRR912166 SRR915607)
westumors=(SRR909464 SRR910419 SRR914911 SRR912894 SRR919221 SRR908821 SRR908517 SRR909068 SRR918759 SRR914696 SRR909091 SRR919178 SRR911504 SRR914192 SRR917160)

#i=${1?"the pair number"}
#wgsflag=${2?"wgs=1"}
wgsflag=1
if [[ $wgsflag -eq 1 ]]
then
	normals=(${wgsnormals[@]})
	tumors=(${wgstumors[@]})
else
	normals=(${wesnormals[@]})
	tumors=(${westumors[@]})
fi

folder=mutect
#for file in *.Mutect_out.txt
#for (( i=0;i<${#normals[@]};i++ ))
for i in {3,4}
do
	#SRR=$(echo $file | sed "s/\(SRR[0-9]\{4,\}\).Mutect_out.txt/\1/")
	#SRR=${file/.Mutect_out.txt/}
	##SRR=${file%.Mutect*}
	SRR=${tumors[$i]}
	file=$folder/$SRR.Mutect_out.txt
	echo $SRR	
	grep -v REJECT $file | grep -v UNCOVERED - | awk '{if (NR>1) print }' - > $folder/$SRR.Mutect_out_keep.txt
	perl $transformat $folder/$SRR.Mutect_out_keep.txt >$folder/$SRR.Mutect_annovar.txt
	perl $annovardir/annotate_variation.pl -out $folder/$SRR -build hg19 $folder/$SRR.Mutect_annovar.txt $annovardir/humandb/	
done
