#! /usr/bin/env bash
#SBATCH -t 15-10
#SBATCH --mem=32G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

#merge bams in different lanes

sample=${1?"1A-12A"}
picard_dir=/fh/fast/dai_j/CancerGenomics/Tools/picard-tools-1.112
#picard_opts="VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true MAX_RECORDS_IN_RAM=500000"
picard_opts="VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true MAX_RECORDS_IN_RAM=1000000"
#java_opts="-Xms64m -Xmx4g -Djava.io.tmpdir=`pwd`/tmp"
java_opts="-Xms64m -Xmx16g -Djava.io.tmpdir=`pwd`/tmp"
reference=/fh/fast/dai_j/CancerGenomics/Tools/database/reference/full/ucsc.hg19.fasta

echo ${SCRATCH_LOCAL}
output_dir=$sample

echo $sample
#if [[ ! -s $output_dir/$sample.merged.bam ]]
#then	
	files=($(ls $output_dir/*.dedup.recal.bam))
	#echo "samtools merge $output_dir/$sample.merged.bam ${files[@]}"
	#samtools merge $output_dir/$sample.merged.bam ${files[@]}
	INPUTS=""		
	for ((i=0;i<${#files[@]};i++))
	do
		INPUTS="$INPUTS INPUT=${files[$i]}"
	done 
	echo "java $java_opts -jar $picard_dir/MergeSamFiles.jar $INPUTS OUTPUT=$output_dir/$sample.merged.bam $picard_opts"
	java $java_opts -jar $picard_dir/MergeSamFiles.jar $INPUTS OUTPUT=${SCRATCH_LOCAL}/$sample.merged.bam $picard_opts
#fi


#duplicate mark
echo "Mark duplicates..."
#if [[ ! -s $output_dir/$sample.merged.dedup.bam && -s $output_dir/$sample.merged.bam ]]
#then
	java $java_opts -jar $picard_dir/MarkDuplicates.jar INPUT=${SCRATCH_LOCAL}/$sample.merged.bam OUTPUT=$output_dir/$sample.merged.dedup.bam $picard_opts  METRICS_FILE=$output_dir/$sample.merged.duplicate_report.txt REMOVE_DUPLICATES=true
#fi
#if [[ -s $output_dir/${fastq_name}.dedup.bam ]];then rm $output_dir/${fastq_name}.sorted.bam; rm $output_dir/${fastq_name}.sorted.bai; fi

