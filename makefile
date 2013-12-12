merge-insert:
	python protocols/insert-size-dist.py DF5-70_S66_L001_R1_001.fastq.gz.sorted.bam \
	> DF5-70_S66_L001_R1_001.fastq.gz.insert-size.bed
	sort -t$'\t' -n -k2,1 DF5-70_S66_L001_R1_001.fastq.gz.insert-size.bed \
	> DF5-70_S66_L001_R1_001.fastq.gz.insert-size.sorted.bed
	mergeBed -n -i DF5-70_S66_L001_R1_001.fastq.gz.insert-size.sorted.bed \
	> DF5-70_S66_L001_R1_001.fastq.gz.insert-size.merged.bed
