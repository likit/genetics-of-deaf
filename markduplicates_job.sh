#!/bin/sh -login
#PBS -l nodes=1:ppn=1,mem=24gb,walltime=4:00:00
#PBS -N MarkDuplicates
#PBS -M preeyano@msu.edu
#PBS -m abe

cd ${PBS_O_WORKDIR}

module load picardTools/1.89
echo 'This is the fucking input file:' ${input}
java -jar $PICARD/MarkDuplicates.jar INPUT=${input} OUTPUT=${input}.dedup  METRICS_FILE=${input}.mat
