#! /usr/bin/env bash
#SBATCH -t 1-5
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=xwang234@fhcrc.org

normals=(SRR1002719 SRR999433 SRR999687 SRR1000378 SRR1002786 SRR999559 SRR1001730 SRR10018461 SRR1002703 SRR999599 SRR1002792 SRR1001839 SRR9994281 SRR1002710 SRR9995631 SRR1021476)
tumors=(SRR1001842 SRR1002713 SRR999423 SRR1001466 SRR1002670 SRR1001823 SRR999489 SRR1002343 SRR1002722 SRR1002656 SRR1002929 SRR999438 SRR1001915 SRR999594 SRR1001868 SRR1001635)
swcdir=/Dulak_EA/bamfiles/wgs

#swc ls $swcdir
for numpair in {0..15}
do
	normal=${normals[$numpair]}
	tumor=${tumors[$numpair]}
	echo $numpair
	echo $normal
		
	swc download $swcdir/$normal.dedup.realigned.recal.bam  .
	swc download $swcdir/$normal.dedup.realigned.recal.bai  .
	echo $tumor	
	swc download $swcdir/$tumor.dedup.realigned.recal.bam  .
	swc download $swcdir/$tumor.dedup.realigned.recal.bai  .
done
