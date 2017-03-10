#!/usr/bin/env bash
#SBATCH -t 3-10
#SBATCH --mem=32G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

tumorbam=${1?"tumor merged bam"}
normalbam=${2?"normal merged bam"}
tumor=${3?"tumor name,used as preface of output"}
gatk_dir=/fh/fast/dai_j/CancerGenomics/Tools/GATK/GATK3.7
module load java/jdk1.8.0_31 #for gatk3.6
#java_opts="-Xms64m -Xmx8g -Djava.io.tmpdir=`pwd`/tmp"
java_opts="-Xms64m -Xmx16g -Djava.io.tmpdir=`pwd`/tmp"
reference=/fh/fast/dai_j/CancerGenomics/Tools/database/reference/full/ucsc.hg19.fasta

echo $tumorbam
echo $normalbam
echo $tumor
java $java_opts -jar $gatk_dir/GenomeAnalysisTK.jar -T ContEst -R $reference -I:eval $tumorbam -I:genotype $normalbam --popfile /fh/fast/dai_j/CancerGenomics/Tools/contest/hg19_population_stratified_af_hapmap_3.3.vcf -o $tumor.contest.txt
