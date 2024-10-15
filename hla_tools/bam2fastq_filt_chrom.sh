CPU=8
SEED=77
SUBSAMP_FRAC=0.0001

# INPUT_BAM="/mnt/data/common_private/platinum/Alignment/000000000500.MGI.cutadapt.bwa.MarkDuplicates.bam"
INPUT_BAM="/mnt/data/common_private/platinum/Alignment/000000000500.ONT.all_chem.dorado_sup@v4.3_C@v1_A@v2.minimap2.MarkDuplicates.bam"
# INPUT_BAM="/mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/Trim_align/ont_small.bam"
INPUT_BED="/home/gvykhodtsev/projects/HLA_typing/HLA_KIR_chrom.bed"
OUTPUT_PREF="/mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/Trim_align/ONT_filt_chrom"
TMPDIR="/mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/Trim_align/tmp"
mkdir -p $TMPDIR

# Extract FASTQ reads
## Filter BAM with BED
### Pair-end reads
# samtools merge -@ $CPU -o - <(samtools view -@ $CPU -b -h -L $INPUT_BED $INPUT_BAM) \
#                             <(samtools view -@ $CPU -b -h -f 13 $INPUT_BAM) | \
# {   samtools collate -@ $CPU -u -O /dev/fd/1 $TMPDIR/tmp ; \
#     samtools idxstats /dev/fd/1 &> ${OUTPUT_PREF}_idxstats.txt ; } | \
# samtools fastq -@ $CPU -1 ${OUTPUT_PREF}_R1.fq.gz -2 ${OUTPUT_PREF}_R2.fq.gz -0 /dev/null -s /dev/null -n

# samtools idxstats $INPUT_BAM > ${OUTPUT_PREF}_ref_idxstats.txt
# samtools merge -@ $CPU -o - <(samtools view -@ $CPU -b -h -L $INPUT_BED $INPUT_BAM) \
#                             <(samtools view -@ $CPU -b -h -f 13 $INPUT_BAM) > ${OUTPUT_PREF}.bam
# samtools idxstats ${OUTPUT_PREF}.bam > ${OUTPUT_PREF}_idxstats.txt
# samtools collate -@ $CPU -u -O ${OUTPUT_PREF}.bam $TMPDIR/tmp | \
# samtools fastq -@ $CPU -1 ${OUTPUT_PREF}_R1.fq.gz -2 ${OUTPUT_PREF}_R2.fq.gz -0 /dev/null -s /dev/null 

### Single end 
samtools idxstats $INPUT_BAM > ${OUTPUT_PREF}_ref_idxstats.txt
samtools merge -@ $CPU -o - <(samtools view -@ $CPU -b -h -L $INPUT_BED $INPUT_BAM) \
                            <(samtools view -@ $CPU -b -h -f 4 $INPUT_BAM) > ${OUTPUT_PREF}.bam
samtools idxstats ${OUTPUT_PREF}.bam > ${OUTPUT_PREF}_idxstats.txt
samtools fastq -@ $CPU ${OUTPUT_PREF}.bam | gzip > ${OUTPUT_PREF}.fq.gz

## Random subsample BAM
# samtools view -@ $CPU --subsample $SUBSAMP_FRAC --subsample-seed $SEED -b -h $INPUT_BAM | \
# samtools collate -@ $CPU -u -O /dev/stdin $TMPDIR | \
# samtools fastq -@ $CPU -1 ${OUTPUT_PREF}_R1.fq.gz -2 ${OUTPUT_PREF}_R2.fq.gz -0 /dev/null -s /dev/null -n

############
