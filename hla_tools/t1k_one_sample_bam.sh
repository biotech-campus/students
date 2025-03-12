CPU=8

OUTPUT_DIR="/mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/T1K/bam_docker"
INPUT_BAM="/mnt/data/common_private/platinum/Alignment/000000000500.MGI.cutadapt.bwa.MarkDuplicates.bam"

REF_PATH="/mnt/data/gvykhodtsev/HLA_typing/References"
HLA_REF_DIR="${REF_PATH}/hlaidx"
# KIR_REF_DIR="${REF_PATH}/kiridx"

rm -rf $OUTPUT_DIR/HLA
mkdir -p $OUTPUT_DIR/HLA
docker run -d --rm --cpus=${CPU} \
        -v ${INPUT_BAM}:${INPUT_BAM}:ro \
        -v ${HLA_REF_DIR}:${HLA_REF_DIR}:ro \
        -v ${OUTPUT_DIR}:${OUTPUT_DIR} \
        t1k run-t1k -b $INPUT_BAM \
                    -f $HLA_REF_DIR/_dna_seq.fa \
                    -c $HLA_REF_DIR/_dna_coord.fa \
                    --preset hla-wgs -t $CPU \
                    --od $OUTPUT_DIR/HLA \
                    2> $OUTPUT_DIR/HLA/t1k_out.err 1> $OUTPUT_DIR/HLA/t1k_out.log

# rm -rf $OUTPUT_DIR/KIR
# mkdir -p $OUTPUT_DIR/KIR
# docker run -d --rm --cpus=${CPU} \
#         -v ${INPUT_BAM}:${INPUT_BAM}:ro \
#         -v ${KIR_REF_DIR}:${KIR_REF_DIR}:ro \
#         -v ${OUTPUT_DIR}:${OUTPUT_DIR} \
#         t1k run-t1k -b $INPUT_BAM \
#                     -f $KIR_REF_DIR/_dna_seq.fa \
#                     -c $KIR_REF_DIR/_dna_coord.fa \
#                     --preset kir-wgs -t $CPU \
#                     --od $OUTPUT_DIR/KIR \
#                     2> $OUTPUT_DIR/KIR/t1k_out.err 1> $OUTPUT_DIR/KIR/t1k_out.log


           