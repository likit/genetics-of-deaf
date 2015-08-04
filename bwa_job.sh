#!/bin/sh -login
#PBS -l nodes=1:ppn=1,mem=24gb,walltime=1:00:00
#PBS -N BWA-mapping

cd ${PBS_O_WORKDIR}

module load bwa
readgroup=$( echo '@RG\tID:sample\tSM:sample\tPL:illumina\tLB:libtype' | sed s/sample/${sample}/g)
readgroup=$( echo $readgroup | sed s/libtype/${libtype}/)
bwa mem -M -R ${readgroup} hg19.fa ${left} ${right} > mapout/${output}.sam
