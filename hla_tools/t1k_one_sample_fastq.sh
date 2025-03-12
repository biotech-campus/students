# Run T1K for all samples
CPU=8
REF_PATH="/mnt/data/gvykhodtsev/HLA_typing/References"
HLA_DNA_REF="${REF_PATH}/hlaidx/_dna_seq.fa"
# KIR_DNA_REF="${REF_PATH}/kiridx/_dna_seq.fa"


SAMP_PATH="/mnt/data/gvykhodtsev/000001"
SAMP_ID="000001011090"
INPUT_FASTQ_1="${SAMP_PATH}/${SAMP_ID}.MGI.unmapped+viral+mhc.read1.fastq.gz"
INPUT_FASTQ_2="${SAMP_PATH}/${SAMP_ID}.MGI.unmapped+viral+mhc.read2.fastq.gz"
OUTPUT_DIR="${SAMP_PATH}/${SAMP_ID}.MGI.T1K"

docker run -d --cpus=${CPU} \
        -v ${SAMP_PATH}:${SAMP_PATH} \
        -v ${REF_PATH}:${REF_PATH} \
        t1k \
            sh -c " \
                rm -rf ${OUTPUT_DIR}/HLA && \
                mkdir -p ${OUTPUT_DIR}/HLA && \
                run-t1k -1 ${INPUT_FASTQ_1} \
                        -2 ${INPUT_FASTQ_2} \
                        -f ${HLA_DNA_REF} \
                        --preset hla-wgs -t ${CPU} \
                        --od ${OUTPUT_DIR}/HLA \
                        2> ${OUTPUT_DIR}/HLA/t1k_out.err 1> ${OUTPUT_DIR}/HLA/t1k_out.log \
            "

# docker run -d --cpus=${CPU} \
#         -v ${SAMP_PATH}:${SAMP_PATH} \
#         -v ${REF_PATH}:${REF_PATH} \
#         t1k \
#             sh -c " \
#                 rm -rf ${OUTPUT_DIR}/KIR && \
#                 mkdir -p ${OUTPUT_DIR}/KIR && \
#                 run-t1k -1 ${INPUT_FASTQ_1} \
#                         -2 ${INPUT_FASTQ_2} \
#                         -f ${KIR_DNA_REF} \
#                         --preset kir-wgs -t ${CPU} \
#                         --od ${OUTPUT_DIR}/KIR \
#                         2> ${OUTPUT_DIR}/KIR/t1k_out.err 1> ${OUTPUT_DIR}/KIR/t1k_out.log \
#             "

