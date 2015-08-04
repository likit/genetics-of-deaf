#!/bin/bash
for f in data/$1*_R1.fastq
do
    qsub -v input="$f",out_dir="trimmed_data",data_dir="data" protocol/trimmomatic_job.sh
    # echo $f
done
