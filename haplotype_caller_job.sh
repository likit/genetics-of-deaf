#!/bin/sh -login
#PBS -l nodes=1:ppn=1,mem=24gb,walltime=24:00:00
#PBS -M iamboom@hotmail.co.th
#PBS -m abe
#PBS -N HaplotypeCaller

module load GATK/3.3.0

cd ${PBS_O_WORKDIR}
java -Xmx10g -cp $GATK -jar $GATK/GenomeAnalysisTK.jar -T HaplotypeCaller -R ${genome} -I ${bam} --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 --dbsnp ${snpdb} -o ${output}
