#!/bin/bash

# put all STAR and RSEM results in outside dir that is mounted inside the container
# no files should be created inside the docker
echo "Cutadapt 1.9: Trimming Adapters..."
cutadapt -a AGATCGGAAGAG -m 35 -A AGATCGGAAGAG -o /data/R1_cutadapt.fastq -p /data/R2_cutadapt.fastq "$@"

echo "STAR 2.4.2a: Algining with HG38 Index..."
STAR --runThreadN 160 \
	--genomeDir /data/starIndex \
	--outFileNamePrefix /data/star/ \
	--outSAMunmapped Within \
	--quantMode TranscriptomeSAM \
	--outSAMattributes NH HI AS NM MD \
	--outFilterType BySJout \
	--outFilterMultimapNmax 20 \
	--outFilterMismatchNmax 999 \
	--outFilterMismatchNoverReadLmax 0.04 \
	--alignIntronMin 20 \
	--alignIntronMax 1000000 \
	--alignMatesGapMax 1000000 \
	--alignSJoverhangMin 8 \
	--alignSJDBoverhangMin 1 \
	--sjdbScore 1 \
	--limitBAMsortRAM 49268954168 \
	--outSAMtype BAM Unsorted \
	--readFilesIn /data/R1_cutadapt.fastq /data/R2_cutadapt.fastq

echo "RSEM 1.2.25: Transcript quantification..."
rsem-calculate-expression --paired-end \
	--quiet \
	--no-qualities \
	-p 16 \
	--forward-prob 0.5 \
	--seed-length 25 \
	--fragment-length-mean \
	-1.0 \
	--bam /data/star/Aligned.toTranscriptome.out.bam /data/rsem_ref_hg38/hg38 /data/rsem

echo "Finished!"
