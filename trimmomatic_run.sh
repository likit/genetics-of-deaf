#!/bin/bash
for f in data/*_R1.fastq.gz
do
    qsub -v input="$f",out_dir="trimmed_data",data_dir="data" protocol/trimmomatic_job.sh
done
