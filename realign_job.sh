#!/bin/sh -login
#PBS -l nodes=1:ppn=1,mem=24gb,walltime=4:00:00
#PBS -N RealignIndels
#PBS -M preeyano@msu.edu
#PBS -m abe

cd ${PBS_O_WORKDIR}

module load GATK/3.3.0
java -Xmx10g -cp $GATK -Djava.io.tmpdir=/usr/tmp -jar $GATK/GenomeAnalysisTK.jar -I ${bam} -R hg19.fa -T IndelRealigner -targetIntervals output.intervals -o ${bam}.realignedBam.bam -known snpdata/1000G_indels.hg19.vcf --consensusDeterminationModel KNOWNS_ONLY -LOD 0.4
