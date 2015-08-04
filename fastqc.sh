 for f in trimmed_data/$1.fastq.gz
 do
     qsub -v input="$f",outdir="fastqc_output" protocol/fastqc_job.sh
 done
