#!/bin/sh -login
#PBS -l nodes=1:ppn=1,mem=24gb,walltime=2:00:00
#PBS -M preeyano@msu.edu
#PBS -m abe
#PBS -N FastQC

cd ${PBS_O_WORKDIR}

module load FastQC/0.11.2
fastqc -o ${outdir} -f fastq --noextract -t 4 ${input}
