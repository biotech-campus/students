CPU=8

OUTPUT_DIR="/mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/T1K/ONT_bam"
# INPUT_BAM="/mnt/data/common_private/platinum/Alignment/000000000500.MGI.cutadapt.bwa.MarkDuplicates.bam"
INPUT_BAM="/mnt/data/common_private/platinum/Alignment/000000000500.ONT.all_chem.dorado_sup@v4.3_C@v1_A@v2.minimap2.MarkDuplicates.bam"

HLA_DNA_REF="/mnt/data/gvykhodtsev/HLA_typing/References/hlaidx/_dna_seq.fa"
HLA_DNA_REF_COORD="/mnt/data/gvykhodtsev/HLA_typing/References/hlaidx/_dna_coord.fa"
KIR_DNA_REF="/mnt/data/gvykhodtsev/HLA_typing/References/kiridx/_dna_seq.fa"
KIR_DNA_REF_COORD="/mnt/data/gvykhodtsev/HLA_typing/References/kiridx/_dna_coord.fa"

rm -rf $OUTPUT_DIR/HLA
mkdir -p $OUTPUT_DIR/HLA
run-t1k -b $INPUT_BAM \
        -f $HLA_DNA_REF \
        -c $HLA_DNA_REF_COORD \
        --preset hla-wgs -t $CPU \
        --od $OUTPUT_DIR/HLA \
        2> $OUTPUT_DIR/HLA/t1k_out.err 1> $OUTPUT_DIR/HLA/t1k_out.log


rm -rf $OUTPUT_DIR/KIR
mkdir -p $OUTPUT_DIR/KIR
run-t1k -b $INPUT_BAM \
        -f $KIR_DNA_REF \
        -c $KIR_DNA_REF_COORD \
        --preset kir-wgs -t $CPU \
        --od $OUTPUT_DIR/KIR \
        2> $OUTPUT_DIR/KIR/t1k_out.err 1> $OUTPUT_DIR/KIR/t1k_out.log
