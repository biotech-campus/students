#!/bin/bash 

docker build -f Dockerfile.telseq -t telseq:latest .
docker build -t tel_calling:latest .

# TELSEQ
TOOL=$1

REF_DIR="/mnt/data/common/hg38"
IN_DIR="/mnt/data/epavlova/input/"
BAM_DIR="/mnt/data/common_private/data01/PG/Alignment"
OUT_DIR="/mnt/data/epavlova/output/"
BAM_FILE="/000000000500.ONT.all_chem.dorado_sup@v4.3_C@v1_A@v2.minimap2.MarkDuplicates"
FASTQ_FILE="/000000000500.ONT.all_chem.dorado_sup@v4.3_C@v1_A@v2.fq"
FASTA_FILE="/000000000500.ONT.all_chem.dorado_sup@v4.3_C@v1_A@v2.fa"

WORKDIR="/home"

VOLUME_OPTIONS="--volume ${REF_DIR}:${REF_DIR}:ro \
        --volume ${IN_DIR}:${IN_DIR}:ro \
        --volume ${BAM_DIR}:${BAM_DIR}:ro \
        --volume ${OUT_DIR}:${OUT_DIR}"

if [ "${TOOL}" = "findtelomeres" ]
then 
    docker run -it --rm \
        ${VOLUME_OPTIONS} \
        tel_calling \
            sh -c "touch ${OUT_DIR}/findteltest.fa && python3 FindTelomeres/FindTelomeres.py ${IN_DIR}/${FASTQ_FILE} > ${OUT_DIR}/findteltest.fa"
fi

if [ "${TOOL}" = "tidehunter" ]
then 
    docker run -it --rm \
        ${VOLUME_OPTIONS} \
        tel_calling \
        sh -c "touch ${OUT_DIR}/tidetest.fq && TideHunter ${IN_DIR}/${FASTQ_FILE} > ${OUT_DIR}/tidetest.fq"
fi

if [ "${TOOL}" = "trf" ]
then 
    trf_flags='2 5 7 80 10 50 2000 -f -d -m'
    docker run -it --rm \
        -w ${OUT_DIR}/trf \
        ${VOLUME_OPTIONS} \
        tel_calling \
            trf ${IN_DIR}/${FASTQ_FILE} ${trf_flags}
fi

if [ "${TOOL}" = "telomerecat" ]
then 
    docker run -it --rm \
        ${VOLUME_OPTIONS} \
        tel_calling \
        telomerecat bam2telbam -v 2 --outbam_dir ${OUT_DIR} ${BAM_DIR}/${BAM_FILE}.bam
fi

if [ "${TOOL}" = "telseq" ]
then 
    docker run -it --rm \
        ${VOLUME_OPTIONS} \
        telseq \
            telseq -o ${OUT_DIR}/telseqtest.txt ${BAM_DIR}/${BAM_FILE}.bam
fi
        
