 # for f in data/*.fastq.gz
 # do
 #     qsub -v input="$f" protocol/fastqc_job.sh
 # done

 for f in trimmed_data/*.fastq.gz
 do
     echo $f
     qsub -v input="$f",outdir="fastqc_output" protocol/fastqc_job.sh
 done
 for f in trimmed_data_2/*.fastq.gz
 do
     echo $f
     qsub -v input="$f",outdir="fastqc_output2" protocol/fastqc_job.sh
 done
