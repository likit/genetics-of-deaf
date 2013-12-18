#!/bin/sh -login
#PBS -l nodes=1:ppn=1,mem=24gb,walltime=24:00:00
#PBS -M preeyano@msu.edu
#PBS -m abe
#PBS -N BLAT_${PBS_JOBID}

module load BLAT

cd ${PBS_O_WORKDIR}
protocols/run-blat-indel.sh ${genome} ${input} ${outdir}
