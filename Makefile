mark-duplicate:
	java -jar $$PICARD/MarkDuplicates.jar INPUT=sample63.bam OUTPUT=dedup_sample63.bam  METRICS_FILE=sample63_metrics.txt
	# java -jar $$PICARD/MarkDuplicates.jar INPUT=sample96.bam OUTPUT=dedup_sample96.bam  METRICS_FILE=sample96_metrics.txt
	# java -jar $$PICARD/MarkDuplicates.jar INPUT=sample7.bam OUTPUT=dedup_sample7.bam  METRICS_FILE=sample7_metrics.txt
BuildBamIndex:
	java -jar $$PICARD/BuildBamIndex.jar INPUT=dedup_sample63.bam
	# java -jar $$PICARD/BuildBamIndex.jar INPUT=dedup_sample96.bam
	# java -jar $$PICARD/BuildBamIndex.jar INPUT=dedup_sample7.bam
CreateSequenceDictionary:
	java -jar $$PICARD/CreateSequenceDictionary.jar REFERENCE=hg19.fa OUTPUT=hg19.dict
RealignerTargetCreator:
	java -Xmx10g -cp $GATK -jar $$GATK/GenomeAnalysisTK.jar -T RealignerTargetCreator -R hg19.fa -o output.intervals -known nist_known_var_mod.vcf
IndelRealigner:
	java -Xmx10g -cp $GATK -Djava.io.tmpdir=/usr/tmp -jar $$GATK/GenomeAnalysisTK.jar -I dedup_sample63.bam -R hg19.fa -T IndelRealigner -targetIntervals output.intervals -o sample63_realignedBam.bam -known nist_known_var_mod.vcf --consensusDeterminationModel KNOWNS_ONLY -LOD 0.4
	# java -Xmx10g -cp $GATK -Djava.io.tmpdir=/usr/tmp -jar $$GATK/GenomeAnalysisTK.jar -I dedup_sample96.bam -R hg19.fa -T IndelRealigner -targetIntervals output.intervals -o sample96_realignedBam.bam -known nist_known_var_mod.vcf --consensusDeterminationModel KNOWNS_ONLY -LOD 0.4
	# java -Xmx10g -cp $GATK -Djava.io.tmpdir=/usr/tmp -jar $$GATK/GenomeAnalysisTK.jar -I dedup_sample7.bam -R hg19.fa -T IndelRealigner -targetIntervals output.intervals -o sample7_realignedBam.bam -known nist_known_var_mod.vcf --consensusDeterminationModel KNOWNS_ONLY -LOD 0.4
