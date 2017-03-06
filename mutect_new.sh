#! /usr/bin/env bash
#SBATCH -t 4-5
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

source /etc/profile.d/fh_path.sh
#Mutect not work with jdk1.7
module load java/jdk1.6.0_45

cosmic=/fh/fast/dai_j/CancerGenomics/Tools/database/vcf/hg19_cosmic_v54_120711.sorted.vcf
dbsnp=/fh/fast/dai_j/CancerGenomics/Tools/database/vcf/dbsnp_138.hg19.compact.sorted.vcf
gatk_dir=/fh/fast/dai_j/CancerGenomics/Tools/GATK
exon_interval_file=/fh/fast/dai_j/CancerGenomics/Tools/database/exomecapture/S0293689_Padded.intervals
mutect=/fh/fast/dai_j/CancerGenomics/Tools/Mutect/muTect-1.1.4.jar

#wgsnormals=(SRR1002719 SRR999433 SRR999687 SRR1000378 SRR1002786 SRR999559 SRR1001730 SRR10018461 SRR1002703 SRR999599 SRR1002792 SRR1001839 SRR9994281 SRR1002710 SRR9995631 SRR1021476)
#wgstumors=(SRR1001842 SRR1002713 SRR999423 SRR1001466 SRR1002670 SRR1001823 SRR999489 SRR1002343 SRR1002722 SRR1002656 SRR1002929 SRR999438 SRR1001915 SRR999594 SRR1001868 SRR1001635)
#            0  1  2  3  4  5
#adeno tumors 3 11 13 15 17 23 25 29 33 35 37 41
#12/1 17 41 available, 2, 14, 12/5 0,1,5,8,10,11,12
#wgsnormals=(4A 12A 14A 16A 18A 20A 22A 24A 26A 28A 30A 32A 34A 36A 38A 40A 42A)
#wgstumors=(3A 11A 13A 15A 17A 19A 21A 23A 25A 27A 29A 31A 33A 35A 37A 39A 41A)
wgsnormals=(4A 12A 14A 16A 18A 26A 30A 34A 38A 42A)
wgstumors=(3A 11A 13A 15A 17A 25A 29A 33A 37A 41A)
#	        0  1   2   3   4   5   6   7   8   9
wesnormals=(SRR910050 SRR915212 SRR913342 SRR912683 SRR912544 SRR915497 SRR910232 SRR911791 SRR913772 SRR910119 SRR908454 SRR910787 SRR912469 SRR912166 SRR915607)
westumors=(SRR909464 SRR910419 SRR914911 SRR912894 SRR919221 SRR908821 SRR908517 SRR909068 SRR918759 SRR914696 SRR909091 SRR919178 SRR911504 SRR914192 SRR917160)

i=${1?"the pair number"}
#wgsflag=${2?"wgs=1"}
wgsflag=1

if [[ $wgsflag -eq 1 ]]
then
	bamdir=/fh/scratch/delete30/dai_j/henan
	#ext=dedup.realigned.recal.exome.bam
	ext=merged.deduprealigned.bam
	normals=(${wgsnormals[@]})
	tumors=(${wgstumors[@]})
	reference=/fh/fast/dai_j/CancerGenomics/Tools/database/reference/full/ucsc.hg19.fasta
else
	bamdir=/fh/fast/dai_j/CancerGenomics/EAC/Exome/Dulak/all
	bamdir1=/fh/fast/dai_j/CancerGenomics/EAC/Exome/Dulak/all
	ext=dedup.realigned.recal.bam
	normals=(${wesnormals[@]})
	tumors=(${westumors[@]})
	reference=/fh/fast/dai_j/CancerGenomics/Tools/database/reference/compact/ucsc.hg19.compact.fasta
fi

outdir=/fh/scratch/delete30/dai_j/henan/mutect
cd $outdir
java_opts="-Djava.io.tmpdir=`pwd`/tmp -Xmx8g"

normalfile=$bamdir/${normals[$i]}.$ext
#if [[ ! -f $normalfile ]];then normalfile=$bamdir1/${normals[$i]}.$ext;fi 
tumorfile=$bamdir/${tumors[$i]}.$ext
#if [[ ! -f $tumorfile ]];then tumorfile=$bamdir1/${tumors[$i]}.$ext;fi
echo $normalfile
echo $tumorfile
output=$outdir/${tumors[$i]}.Mutect_out.txt
outputvcf=$outdir/${tumors[$i]}.Mutect.vcf
outputwig=$outdir/${tumors[$i]}.wig.txt
#enable_extended_output get extended output, for failure reasons etc.
if [[ $wgsflag -eq 1 ]]
then
	java $java_opts -jar $mutect --analysis_type MuTect --reference_sequence $reference --cosmic $cosmic --dbsnp $dbsnp --min_qscore 20 --input_file:normal $normalfile --input_file:tumor $tumorfile --out $output --vcf $outputvcf --coverage_file $outputwig --enable_extended_output
else
	java $java_opts -jar $mutect --analysis_type MuTect --reference_sequence $reference --cosmic $cosmic --dbsnp $dbsnp --min_qscore 20 --input_file:normal $normalfile --input_file:tumor $tumorfile --out $output --vcf $outputvcf --coverage_file $outputwig -ip 50 --intervals $exon_interval_file
	#java $java_opts -jar $mutect --analysis_type MuTect --reference_sequence $reference --min_qscore 20 --input_file:normal $normalfile --input_file:tumor $tumorfile --out $output --vcf $outputvcf --coverage_file $outputwig --fraction_contamination 0.25 -ip 50 --intervals $exon_interval_file
fi
