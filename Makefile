Trimmomatic-agilent:
	sh protocol/trimmomatic_run.sh agilent

Trimmomatic-truseq:
	sh protocol/trimmomatic_run.sh truseq

Fastqc-agilent-R1-pe:
	if ! [ -d fastqc_output ]; then mkdir fastqc_output; fi
	sh protocol/fastqc.sh agilent*R1*pe*

Fastqc-agilent-R2-pe:
	if ! [ -d fastqc_output ]; then mkdir fastqc_output; fi
	sh protocol/fastqc.sh agilent*R2*pe*

Fastqc-agilent-R1-se:
	if ! [ -d fastqc_output ]; then mkdir fastqc_output; fi
	sh protocol/fastqc.sh agilent*R1*se*

Fastqc-agilent-R2-se:
	if ! [ -d fastqc_output ]; then mkdir fastqc_output; fi
	sh protocol/fastqc.sh agilent*R2*se*

Fastqc-truseq-R1-pe:
	if ! [ -d fastqc_output ]; then mkdir fastqc_output; fi
	sh protocol/fastqc.sh truseq*R1*pe*

Fastqc-truseq-R2-pe:
	if ! [ -d fastqc_output ]; then mkdir fastqc_output; fi
	sh protocol/fastqc.sh truseq*R2*pe*

Fastqc-truseq-R1-se:
	if ! [ -d fastqc_output ]; then mkdir fastqc_output; fi
	sh protocol/fastqc.sh truseq*R1*se*

Fastqc-truseq-R2-se:
	if ! [ -d fastqc_output ]; then mkdir fastqc_output; fi
	sh protocol/fastqc.sh truseq*R2*se*


BWAMapping:
	bwa mem -M -R '@RG\tID:group63\tSM:sample63\tPL:illumina\tLB:Agilent' -p hg19.fa trimmed_data/sample63_R1.trimmed.pe.fastq.gz trimmed_data/sample63_R2.trimmed.pe.fastq.gz > sample63.sam
	# bwa mem -M -R '@RG\tID:group96\tSM:sample96\tPL:illumina\tLB:Agilent' -p hg19.fa trimmed_data/sample96_R1.trimmed.pe.fastq.gz trimmed_data/sample96_R2.trimmed.pe.fastq.gz > sample96.sam
	# bwa mem -M -R '@RG\tID:group7\tSM:sample7\tPL:illumina\tLB:Agilent' -p hg19.fa trimmed_data/sample7_R1.trimmed.pe.fastq.gz trimmed_data/sample7_R2.trimmed.pe.fastq.gz > sample7.sam

BWAMapping-agilent:
	sh protocol/bwa_run.sh agilent

BWAMapping-truseq:
	sh protocol/bwa_run.sh truseq

SortSam:
	for f in mapout/*.sam; do sh protocol/sortsam_run.sh $$f; done

MarkDuplicates:
	# for f in mapout/*.bam; do qsub -v input="$$f" protocol/markduplicates_job.sh; done
	for f in $$(cat mapout/agilent-rerun); do qsub -v input="mapout/$$f" protocol/markduplicates_job.sh; done

BuildBamIndex:
	for f in mapout/agilent*.bam.dedup; do java -jar $$PICARD/BuildBamIndex.jar INPUT=$$f; done

CreateSequenceDictionary:
	java -jar $$PICARD/CreateSequenceDictionary.jar REFERENCE=hg19.fa OUTPUT=hg19.dict

RealignerTargetCreator:
	java -Xmx10g -cp $$GATK -jar $$GATK/GenomeAnalysisTK.jar -T RealignerTargetCreator -R hg19.fa -o output.intervals -known snpdata/1000G_indels.hg19.vcf

IndelRealigner:
	# rename all dedup files
	for f in mapout/*dedup; do mv $$f $$(basename $$f .bam.dedup).dedup.bam; done
	for f in mapout/*dedup.bai; do mv $$f $$(basename $$f .bam.dedup.bai).dedup.bam.bai; done
	# for f in mapout/*dedup.bam; do  qsub -v bam="$$f" protocol/realign_job.sh; done
	for f in $$(cat mapout/agilent-rerun); do qsub -v bam="mapout/$$f" protocol/realign_job.sh; done

BaseRecalibrator:
	# for f in mapout/*realignedBam.bam; do qsub -v input="$$f" protocol/recalibrate_job.sh; done
	for f in $$(cat mapout/agilent-rerun); do qsub -v input="mapout/$$f" protocol/recalibrate_job.sh; done

BaseRecalibrator2:	
	# for f in mapout/*realignedBam.bam; do qsub -v input="$$f" protocol/recalibrate2_job.sh; done
	for f in $$(cat mapout/agilent-rerun); do qsub -v input="mapout/$$f" protocol/recalibrate2_job.sh; done

AnalyzeCovariates:
	for f in mapout/agilent*.realignedBam.bam; do java -Xmx10g -cp $$GATK -jar $$GATK/GenomeAnalysisTK.jar -T AnalyzeCovariates -R hg19.fa -before $$f.table -after $$f.postcal.table -plots $$f.pdf; done

	# for f in mapout/truseq*.realignedBam.bam; do java -Xmx10g -cp $$GATK -jar $$GATK/GenomeAnalysisTK.jar -T AnalyzeCovariates -R hg19.fa -before $$f.table -after $$f.postcal.table -plots $$f.pdf; done

PrintReads:
	# for f in mapout/truseq*.realignedBam.bam; do java -Xmx10g -cp $$GATK -jar $$GATK/GenomeAnalysisTK.jar -T PrintReads -R hg19.fa -I $$f -BQSR $$f.table -o $$f.recal.bam; done
	for f in mapout/agilent*.realignedBam.bam; do java -Xmx10g -cp $$GATK -jar $$GATK/GenomeAnalysisTK.jar -T PrintReads -R hg19.fa -I $$f -BQSR $$f.table -o $$f.recal.bam; done

HaplotypeCallerAgilent:
	for f in mapout/agilent*recal.bam; do qsub -v bam="$$f" protocol/haplotype_caller_job.sh; done

HaplotypeCallerTruseq:
	for f in mapout/truseq*recal.bam; do qsub -v bam="$$f" protocol/haplotype_caller_job.sh; done

CombineGVCFs:
	qsub protocol/combined_gvcf.sh

GenotypeGVCF:
	qsub protocol/genotype_gvcf_job.sh

SelectVariantsSNPs:
	java -Xmx10g -cp $$GATK -jar $$GATK/GenomeAnalysisTK.jar -T SelectVariants -R hg19.fa -V output.vcf -selectType SNP -o raw_snps.vcf

VariantFiltrationSNPs:
	java -Xmx10g -cp $$GATK -jar $$GATK/GenomeAnalysisTK.jar -T VariantFiltration -R hg19.fa -V raw_snps.vcf --filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filterName "my_snp_filter" -o filtered_snps.vcf

SelectVariantsIndels:
	java -Xmx10g -cp $$GATK -jar $$GATK/GenomeAnalysisTK.jar -T SelectVariants -R hg19.fa -V output.vcf -selectType INDEL -o raw_indels.vcf

VariantFiltrationIndels:
	java -Xmx10g -cp $$GATK -jar $$GATK/GenomeAnalysisTK.jar -T VariantFiltration -R hg19.fa -V raw_indels.vcf --filterExpression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" --filterName "my_indel_filter" -o filtered_indels.vcf
