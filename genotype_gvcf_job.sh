#!/bin/sh -login
#PBS -l nodes=1:ppn=1,mem=24gb,walltime=24:00:00
#PBS -M iamboom@hotmail.co.th
#PBS -m abe
#PBS -N GenotypeGVCF_${PBS_JOBID}

module load GATK/3.3.0

cd ${PBS_O_WORKDIR}
java -Xmx10g -cp $GATK -jar $GATK/GenomeAnalysisTK.jar -T GenotypeGVCFs -R hg19.fa --variant sample63.raw.snps.indels.g.vcf --variant sample96.raw.snps.indels.g.vcf --variant sample7.raw.snps.indels.g.vcf -o output.vcf
