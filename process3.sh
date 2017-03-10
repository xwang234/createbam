#! /usr/bin/env bash
#SBATCH -t 12-10
#SBATCH --mem=32G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

#realignment on merged bams
tumor=${1?"tumor name"}
normal=${2?"normal name"}
tumorbam=${3?"tumor merged bam"}
normalbam=${4?"normal merged bam"}
gatk_dir=/fh/fast/dai_j/CancerGenomics/Tools/GATK/GATKv3.4-46-gbc02625
gatk_dir=/fh/fast/dai_j/CancerGenomics/Tools/GATK/GATK3.7
module load java/jdk1.8.0_31 #for gatk3.6
picard_dir=/fh/fast/dai_j/CancerGenomics/Tools/picard-tools-1.112
#picard_opts="VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true MAX_RECORDS_IN_RAM=5000000"
picard_opts="VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true MAX_RECORDS_IN_RAM=10000000"
#java_opts="-Xms64m -Xmx8g -Djava.io.tmpdir=`pwd`/tmp"
java_opts="-Xms64m -Xmx16g -Djava.io.tmpdir=`pwd`/tmp"
reference=/fh/fast/dai_j/CancerGenomics/Tools/database/reference/full/ucsc.hg19.fasta
vcf_indel_1000G=/fh/fast/dai_j/CancerGenomics/Tools/database/vcf/1000G_phase1.indels.hg19.sorted.vcf
vcf_indel_Mills_and_100G=/fh/fast/dai_j/CancerGenomics/Tools/database/vcf/Mills_and_1000G_gold_standard.indels.hg19.sorted.vcf

#output_dir=/fh/scratch/delete30/dai_j/henan

echo $tumor
echo $normal
#Local realignment around indels



echo "Local realignment around indels..."
#if [[ ! -s $output_dir/$tumor.dedup.bam.list ]]
#then

	#java $java_opts -jar $gatk_dir/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $reference -known $vcf_indel_1000G -known $vcf_indel_Mills_and_100G -o $output_dir/$tumor.dedup.bam.list -I $normal/$normal.merged.dedup.bam -I $tumor/$tumor.merged.dedup.bam
	java $java_opts -jar $gatk_dir/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $reference -known $vcf_indel_1000G -known $vcf_indel_Mills_and_100G -o $tumor.dedup.bam.list -I $normalbam -I $tumorbam

#fi

#if [ ! -s $output_dir/$tumor.merged.dedup.realigned.bam || ! -s $output_dir/$normal.merged.dedup.realigned.bam ]
#then
	#java $java_opts -jar $gatk_dir/GenomeAnalysisTK.jar -T IndelRealigner -I $normal/$normal.merged.dedup.bam -I $tumor/$tumor.merged.dedup.bam -R $reference -targetIntervals $output_dir/$tumor.dedup.bam.list -known $vcf_indel_1000G -known $vcf_indel_Mills_and_100G -nWayOut realigned.bam --filter_bases_not_stored
	java $java_opts -jar $gatk_dir/GenomeAnalysisTK.jar -T IndelRealigner -I $normalbam -I $tumorbam -R $reference -targetIntervals $tumor.dedup.bam.list -known $vcf_indel_1000G -known $vcf_indel_Mills_and_100G -nWayOut realigned.bam --filter_bases_not_stored
#fi

#if [ -s $output_dir/${fastq_name}.dedup.realigned.bam ]
#then 
#	rm $output_dir/${fastq_name}.dedup.bam
#	rm $output_dir/${fastq_name}.dedup.bai
#	rm $output_dir/${fastq_name}.dedup.bam.list
#fi

