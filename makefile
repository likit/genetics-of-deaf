run-fastqc:
	fastqc --noextract -t 8 -o fastqc UF02_S6_L001_R1_001.fastq.gz
	fastqc --noextract -t 8 -o fastqc UF02_S6_L001_R2_001.fastq.gz
	fastqc --noextract -t 8 -o fastqc UF13_S41_L001_R1_001.fastq.gz
	fastqc --noextract -t 8 -o fastqc UF13_S41_L001_R2_001.fastq.gz
	fastqc --noextract -t 8 -o fastqc UF24_S64_L001_R1_001.fastq
	fastqc --noextract -t 8 -o fastqc UF24_S64_L001_R2_001.fastq
	fastqc --noextract -t 8 -o fastqc DF5-20_S59_L001_R1_001.fastq.gz
	fastqc --noextract -t 8 -o fastqc DF5-20_S59_L001_R2_001.fastq.gz
	fastqc --noextract -t 8 -o fastqc DF5-70_S66_L001_R1_001.fastq.gz
	fastqc --noextract -t 8 -o fastqc DF5-70_S66_L001_R2_001.fastq.gz

find-intersection:
	intersectBed -a DF5-70_S66_L001_R1_001.fastq.gz.snps_tol.sorted.flt.vcf \
		-b DF5-70_S66_L001_R1_001.fastq.gz.sorted.flt.vcf -wo \
		| cut -f 1,2,4,5,6,15,16 | python protocols/diff-snps.py

run-blat:
	blat -dots=1000 -noHead human_g1k_v37.fasta DF5-70_S66_L001_R1_001.fasta DF5-70_S66_L001_R1_001.fasta.psl
	sort -k 10 DF5-70_S66_L001_R1_001.fasta.psl > DF5-70_S66_L001_R1_001.fasta.sorted.psl
	pslReps -nohead -noIntrons -singleHit DF5-70_S66_L001_R1_001.fasta.sorted.psl DF5-70_S66_L001_R1_001.fasta.flt.psl info

filter-small-indels:
	awk '$7<2' DF5-70_S66_L001_R1_001.fasta.flt.psl | awk '$8>10000' > DF5-70_S66_L001_R1_001.fasta.flt.large.ins.psl

merge-insert:
	python protocols/insert-size-dist.py DF5-70_S66_L001_R1_001.fastq.gz.sorted.bam \
	> DF5-70_S66_L001_R1_001.fastq.gz.insert-size.bed
	sort -t$'\t' -n -k2,1 DF5-70_S66_L001_R1_001.fastq.gz.insert-size.bed \
	> DF5-70_S66_L001_R1_001.fastq.gz.insert-size.sorted.bed
	mergeBed -n -i DF5-70_S66_L001_R1_001.fastq.gz.insert-size.sorted.bed \
	> DF5-70_S66_L001_R1_001.fastq.gz.insert-size.merged.bed
