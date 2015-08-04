for f in trimmed_data/$1*R1*pe*.fastq.gz
do
    right=$(echo $f | sed s/R1/R2/)
    left=$f
    output=$(basename $f _R1.trimmed.pe.fastq.gz)
    qsub -v left="$left",right="$right",output="$output",sample="$output",libtype="$1" protocol/bwa_job.sh
done
