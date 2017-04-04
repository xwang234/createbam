#!/usr/bin/env bash

#SBATCH -t 10-16
#SBATCH --mem=32G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

sample=${1?"1A-12A"}
fastq_name=${2?"fastqname"}
step=${3?"1-3"}

#set 8 threads for step 1
if [[ $step -eq 1 ]]
then 
	echo $SLURM_CPUS_ON_NODE
fi

cosmic=/fh/fast/dai_j/CancerGenomics/Tools/database/vcf/hg19_cosmic_v54_120711.sorted.vcf
dbsnp=/fh/fast/dai_j/CancerGenomics/Tools/database/vcf/dbsnp_138.hg19.compact.sorted.vcf
gatk_dir=/fh/fast/dai_j/CancerGenomics/Tools/GATK/GATKv3.4-46-gbc02625
gatk_dir=/fh/fast/dai_j/CancerGenomics/Tools/GATK/GATK3.7
picard_dir=/fh/fast/dai_j/CancerGenomics/Tools/picard-tools-1.112
#picard_opts="VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true MAX_RECORDS_IN_RAM=500000"
picard_opts="VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true MAX_RECORDS_IN_RAM=1000000"
#java_opts="-Xms64m -Xmx8g -Djava.io.tmpdir=`pwd`/tmp"
java_opts="-Xms64m -Xmx16g -Djava.io.tmpdir=`pwd`/tmp"
java_opts1="-Xms64m -Xmx12g -Djava.io.tmpdir=`pwd`/tmp"
reference=/fh/fast/dai_j/CancerGenomics/Tools/database/reference/full/ucsc.hg19.fasta
vcf_indel_1000G=/fh/fast/dai_j/CancerGenomics/Tools/database/vcf/1000G_phase1.indels.hg19.sorted.vcf
vcf_indel_Mills_and_100G=/fh/fast/dai_j/CancerGenomics/Tools/database/vcf/Mills_and_1000G_gold_standard.indels.hg19.sorted.vcf

#source /etc/profile.d/fh_path.sh
#module load java/jdk1.7.0_25
module load java/jdk1.8.0_31 #for gatk3.6
module load bwa


#fastq_dir=1A/S81_09B_WHYD15073368-A_L001
#note here !!!
fastq_dir1=$sample
fastq_dir2=$sample/$fastq_name

#fastq_name=FCHMNH2CCXX_L7_wHAXPI028273-13 for 13A

output_dir=$sample

echo $sample
echo $fastq_name


if [[ -f $fastq_dir1/${fastq_name}_1.fq.gz ]]
then
	fastq_dir=$fastq_dir1
        fastq1=$fastq_dir/${fastq_name}_1.fq.gz
	fastq2=$fastq_dir/${fastq_name}_2.fq.gz
elif [[ -f $fastq_dir2/${fastq_name}_1.fq.gz ]]
then
	fastq_dir=$fastq_dir2	
	fastq1=$fastq_dir/${fastq_name}_1.fq.gz
	fastq2=$fastq_dir/${fastq_name}_2.fq.gz
fi

echo $fastq1
echo $fastq2
echo $step

#if [[ $step -eq 1 ]]
#then
#	#if [[ $direction -eq 1 && ! -s $output_dir/${fastq_name}_1.sai ]]
#	if [[ $direction -eq 1 ]]
#	then
#		bwa aln -t ${SLURM_CPUS_ON_NODE} $reference $fastq1 > $output_dir/${fastq_name}_1.sai
#	#elif [[ $direction -eq 2 && ! -s $output_dir/${fastq_name}_2.sai ]]
#	elif [[ $direction -eq 2 ]]
#	then
#		bwa aln -t ${SLURM_CPUS_ON_NODE} $reference $fastq2 > $output_dir/${fastq_name}_2.sai
#	fi
#fi

#if [[ $step -eq 2 ]]
#then
#	echo "Generate sam file..."
#	#if [[ -s $output_dir/${fastq_name}_1.sai && -s $output_dir/${fastq_name}_2.sai && ! -s $output_dir/${fastq_name}.sam ]]
#	if [[ -s $output_dir/${fastq_name}_1.sai && -s $output_dir/${fastq_name}_2.sai ]]
#	then
#		bwa sampe -r "@RG\tID:${fastq_name}\tLB:LB\tSM:$sample\tPL:ILLUMINA" $reference $output_dir/${fastq_name}_1.sai $output_dir/${fastq_name}_2.sai $fastq1 $fastq2 >$output_dir/${fastq_name}.sam
#	fi
#fi
echo ${SCRATCH_LOCAL}

fixfastqscore=1 #illumina old format Phred+64
encodefile=${fastq1/%.gz/}_fastqc/fastqc_data.txt
if [[ $step -eq 1 ]]
then
  if [[ ! -s $encodefile ]]
  then
    echo "run fastqc..."
    /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/fastqc.sh $fastq1
    /fh/fast/dai_j/CancerGenomics/Tools/wang/createbam/fastqc.sh $fastq2
    #check encoding
    encodefile=${fastq1/%.gz/}_fastqc/fastqc_data.txt
    line=$(head -6 $encodefile |tail -1)
    encode=$(echo $line | awk '{print $5}' -)
    if [[ $encode == 1.9 || $encode == 1.8 ]] #Phred+33
    then
      fixfastqscore=0
    fi
  fi
fi

if [[ $step -eq 1 ]]
then
	#running bwa-mem with "-a", printing all found hits. These are mostly repetitive hits and should have mapQ=0
	echo "bwa mem -M -R @RG\tID:${fastq_name}\tLB:$sample\tSM:$sample\tPL:ILLUMINA -t ${SLURM_CPUS_ON_NODE} $reference $fastq1 $fastq2 > ${SCRATCH_LOCAL}/${fastq_name}.sam" #write big sam to scratch	
	bwa mem -M -R "@RG\tID:${fastq_name}\tLB:$sample\tSM:$sample\tPL:ILLUMINA" -t ${SLURM_CPUS_ON_NODE} $reference $fastq1 $fastq2 > ${SCRATCH_LOCAL}/${fastq_name}.sam
fi

if [[ $step -eq 1 ]];then
	echo "Generate sorted bam file..."
	#if [[ ! -s $output_dir/${fastq_name}.sorted.bam ]]
	#then
		#java -Xmx16g $java_opts -jar $picard_dir/SortSam.jar INPUT=$output_dir/${fastq_name}.sam OUTPUT=$output_dir/${fastq_name}.sorted.bam SORT_ORDER=coordinate $picard_opts
		samtools view -bhS ${SCRATCH_LOCAL}/${fastq_name}.sam | samtools sort - ${SCRATCH_LOCAL}/${fastq_name}.sorted
	#fi

	#if [[ -s $output_dir/${fastq_name}.sorted.bam ]];then rm $output_dir/${fastq_name}.sam;fi
fi

#Do realignment on each bam files
if [[ $step -eq 1 ]];then
	echo "Mark and remove duplicates..."
	if [ ! -s ${SCRATCH_LOCAL}/${fastq_name}.dedup.bam ]
	then
		java $java_opts -jar $picard_dir/MarkDuplicates.jar INPUT=${SCRATCH_LOCAL}/${fastq_name}.sorted.bam OUTPUT=${SCRATCH_LOCAL}/${fastq_name}.dedup.bam $picard_opts  METRICS_FILE=$output_dir/${fastq_name}.duplicate_report.txt REMOVE_DUPLICATES=true
	fi
	#if [[ -s $output_dir/${fastq_name}.sorted.bam ]];then rm $output_dir/${fastq_name}.sam;fi	
	#if [[ -s $output_dir/${fastq_name}.dedup.bam ]];then rm $output_dir/${fastq_name}.sorted.bam; rm $output_dir/${fastq_name}.sorted.bai; fi
fi
 
#Local realignment around indels


#if [[ $step -eq 3 ]];then
#	echo "Local realignment around indels..."
	##if [[ ! -s $output_dir/${fastq_name}.dedup.bam.list ]]
	##then
		#java $java_opts -jar $gatk_dir/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $reference -known $vcf_indel_1000G -known $vcf_indel_Mills_and_100G -o $output_dir/${fastq_name}.dedup.bam.list -I $output_dir/${fastq_name}.dedup.bam -fixMisencodedQuals
#		java $java_opts -jar $gatk_dir/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $reference -known $vcf_indel_1000G -known $vcf_indel_Mills_and_100G -o $output_dir/${fastq_name}.dedup.bam.list -I $output_dir/${fastq_name}.dedup.bam

	##fi

	##if [ ! -s $output_dir/${fastq_name}.dedup.realigned.bam ]
	##then
		#java $java_opts -jar $gatk_dir/GenomeAnalysisTK.jar -T IndelRealigner -I $output_dir/${fastq_name}.dedup.bam -R $reference -targetIntervals $output_dir/${fastq_name}.dedup.bam.list -known $vcf_indel_1000G -known $vcf_indel_Mills_and_100G -o $output_dir/${fastq_name}.dedup.realigned.bam -fixMisencodedQuals
#		java $java_opts -jar $gatk_dir/GenomeAnalysisTK.jar -T IndelRealigner -I $output_dir/${fastq_name}.dedup.bam -R $reference -targetIntervals $output_dir/${fastq_name}.dedup.bam.list -known $vcf_indel_1000G -known $vcf_indel_Mills_and_100G -o $output_dir/${fastq_name}.dedup.realigned.bam --disable_auto_index_creation_and_locking_when_reading_rods
	##fi

	#if [ -s $output_dir/${fastq_name}.dedup.realigned.bam ]
	#then 
	#	rm $output_dir/${fastq_name}.dedup.bam
	#	rm $output_dir/${fastq_name}.dedup.bai
	#	rm $output_dir/${fastq_name}.dedup.bam.list
	#fi
#fi

#When using paired end data, the mate information must be fixed, as alignments may change during the realignment process.
#java $java_opts -jar $picard_dir/FixMateInformation.jar INPUT=SAMPLE.dedup.realigned.bam OUTPUT=SAMPLE.dedup.realigned.fixed.bam SO=coordinate $picard_opts

#Base quality score recalibration


if [[ $step -eq 1 ]]
then
	echo "Base quality score recalibration..."
	#check encoding
	encodefile=${fastq1/%.gz/}_fastqc/fastqc_data.txt
	line=$(head -6 $encodefile |tail -1)
	echo $line
	encode=$(echo $line | awk '{print $5}' -)
	if [[ $encode == 1.9 || $encode == 1.8 ]] #Phred+33
	then
	  fixfastqscore=0
	fi
	
	if [ ! -s $output_dir/${fastq_name}.recal.table ]
	then
		if [[ $fixfastqscore == 1 ]]
		then
			java $java_opts1 -jar $gatk_dir/GenomeAnalysisTK.jar -T BaseRecalibrator -I ${SCRATCH_LOCAL}/${fastq_name}.dedup.bam -R $reference -knownSites $dbsnp -knownSites $vcf_indel_1000G  -knownSites $vcf_indel_Mills_and_100G -o $output_dir/${fastq_name}.recal.table -fixMisencodedQuals -allowPotentiallyMisencodedQuals
		else
			java $java_opts1 -jar $gatk_dir/GenomeAnalysisTK.jar -T BaseRecalibrator -I ${SCRATCH_LOCAL}/${fastq_name}.dedup.bam -R $reference -knownSites $dbsnp -knownSites $vcf_indel_1000G  -knownSites $vcf_indel_Mills_and_100G -o $output_dir/${fastq_name}.recal.table -allowPotentiallyMisencodedQuals
		fi
	fi

	if [ ! -s $output_dir/${fastq_name}.post_recal.table ]
	then
		java $java_opts1 -jar $gatk_dir/GenomeAnalysisTK.jar -T BaseRecalibrator -R $reference -I ${SCRATCH_LOCAL}/${fastq_name}.dedup.bam -knownSites $dbsnp -knownSites $vcf_indel_1000G  -knownSites $vcf_indel_Mills_and_100G -BQSR $output_dir/${fastq_name}.recal.table -o $output_dir/${fastq_name}.post_recal.table #-allowPotentiallyMisencodedQuals
	fi

	if [ ! -s $output_dir/${fastq_name}.dedup.recal.bam ]
	then
		java $java_opts1 -jar $gatk_dir/GenomeAnalysisTK.jar -T PrintReads -R $reference -I ${SCRATCH_LOCAL}/${fastq_name}.dedup.bam -BQSR $output_dir/${fastq_name}.recal.table -o $output_dir/${fastq_name}.dedup.recal.bam  --filter_bases_not_stored #-allowPotentiallyMisencodedQuals
	fi
fi

#if [ -s $output_dir/${fastq_name}.dedup.recal.bam ]
#then 
#	rm $output_dir/${fastq_name}.dedup.realigned.bam
#	rm $output_dir/${fastq_name}.dedup.realigned.bai
#	rm $output_dir/${fastq_name}.recal.table
#	rm $output_dir/${fastq_name}.post_recal.table
#fi
#generate alignment summary
#	java $java_opts -jar $picard_dir/CollectAlignmentSummaryMetrics.jar INPUT=$output_dir/${fastq_name}.dedup.realigned.recal.bam OUTPUT=$output_dir/${fastq_name}.dedup.realigned.recal.bam.qulity R=$reference $picard_opts
echo "${fastq_name} Done"




