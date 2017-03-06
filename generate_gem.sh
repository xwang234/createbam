#! /usr/bin/env bash
#SBATCH -t 1-1
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

wgsflag=1
len=101
mismatch=4

#Can run in rhino,not gizmod
#GEM has two version for i3 and 2
#GEMdir=/fh/fast/dai_j/CancerGenomics/Tools/GEM/GEM-binaries-Linux-x86_64-core_i3-20130406-045632/bin
GEMdir=/fh/fast/dai_j/CancerGenomics/Tools/GEM/GEM-binaries-Linux-x86_64-core_2-20130406-045632/bin

if [[ $wgsflag -eq 1 ]]
then 
	reference=/fh/fast/dai_j/CancerGenomics/Tools/database/reference/full/ucsc.hg19.fasta	
else
	reference=/fh/fast/dai_j/CancerGenomics/Tools/database/reference/compact/ucsc.hg19.compact.fasta
fi

#wesreference=/fh/fast/dai_j/CancerGenomics/Tools/database/reference/compact/ucsc.hg19.compact.fasta


cd $GEMdir
export PATH=$PATH:$GEMdir
#./gem-indexer -i $reference -o $reference

gem-mappability -I $reference.gem -l $len -m $mismatch -o $reference.l${len}m$mismatch -T 8

gem-2-wig -I $reference.gem -i $reference.l${len}m$mismatch.mappability -o $reference.l${len}m$mismatch

#wig2bed format
wig2beddir=/fh/fast/dai_j/CancerGenomics/Tools/bedops/bin
export PATH=$PATH:$wig2beddir
wig2bed -m 8G <$reference.l${len}m$mismatch.wig > $reference.l${len}m$mismatch.bed
cut -f 1,2,3,5 $reference.l${len}m$mismatch.bed >$reference.l${len}m$mismatch.bed1
mv $reference.l${len}m$mismatch.bed1 $reference.l${len}m$mismatch.bed

