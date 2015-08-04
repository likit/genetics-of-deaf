#!/bin/sh -login
#PBS -l nodes=1:ppn=1,mem=24gb,walltime=8:00:00
#PBS -M preeyano@msu.edu
#PBS -m abe
#PBS -N Recalibrate

module load GATK/3.3.0

cd ${PBS_O_WORKDIR}
java -Xmx10g -cp $GATK -jar $GATK/GenomeAnalysisTK.jar -T BaseRecalibrator -R hg19.fa -I ${input} -knownSites snpdata/dbsnp.hg19.vcf -o ${input}.table 
