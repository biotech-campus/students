CPU=8

HLA_DNA_REF="/mnt/data/gvykhodtsev/HLA_typing/References/hlaidx/_dna_seq.fa"
KIR_DNA_REF="/mnt/data/gvykhodtsev/HLA_typing/References/kiridx/_dna_seq.fa"

# INPUT_FASTQ_1="/mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/Trim_align/filt_chrom_R1.fq.gz"
# INPUT_FASTQ_2="/mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/Trim_align/filt_chrom_R2.fq.gz"
INPUT_FASTQ="/mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/Trim_align/ONT_filt_chrom.fq.gz"

OUTPUT_DIR="/mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/T1K/ont_filt_fastq"

# rm -rf $OUTPUT_DIR/HLA
# mkdir -p $OUTPUT_DIR/HLA
# run-t1k -1 $INPUT_FASTQ_1 \
#         -2 $INPUT_FASTQ_2 \
#         -f $HLA_DNA_REF \
#         --preset hla-wgs -t $CPU \
#         --od $OUTPUT_DIR/HLA \
#         2> $OUTPUT_DIR/HLA/t1k_out.err 1> $OUTPUT_DIR/HLA/t1k_out.log

# rm -rf $OUTPUT_DIR/KIR
# mkdir -p $OUTPUT_DIR/KIR
# run-t1k -1 $INPUT_FASTQ_1 \
#         -2 $INPUT_FASTQ_2 \
#         -f $KIR_DNA_REF \
#         --preset kir-wgs -t $CPU \
#         --od $OUTPUT_DIR/KIR \
#         2> $OUTPUT_DIR/KIR/t1k_out.err 1> $OUTPUT_DIR/KIR/t1k_out.log



rm -rf $OUTPUT_DIR/HLA
mkdir -p $OUTPUT_DIR/HLA
run-t1k -u $INPUT_FASTQ \
        -f $HLA_DNA_REF \
        --preset hla-wgs -t $CPU \
        --od $OUTPUT_DIR/HLA \
        2> $OUTPUT_DIR/HLA/t1k_out.err 1> $OUTPUT_DIR/HLA/t1k_out.log

rm -rf $OUTPUT_DIR/KIR
mkdir -p $OUTPUT_DIR/KIR
run-t1k -u $INPUT_FASTQ \
        -f $KIR_DNA_REF \
        --preset kir-wgs -t $CPU \
        --od $OUTPUT_DIR/KIR \
        2> $OUTPUT_DIR/KIR/t1k_out.err 1> $OUTPUT_DIR/KIR/t1k_out.log
