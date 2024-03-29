#!/bin/bash 

docker build -f Dockerfile.telseq -t telseq:latest .
docker build -t tel_calling:latest .

# TELSEQ
TOOL=$1

REF_DIR="/mnt/data/common/hg38"
IN_DIR="/mnt/data/epavlova/input/"
OUT_DIR="/mnt/data/epavlova/output/"
BAM_FILE="/HG002_GRCh38_ONT-UL_GIAB_20200122.phased.bam"
FASTQ_FILE="/HG002_NA24385_son_UCSC_Ultralong_OxfordNanopore_Promethion_GM24385_1.fastq"
FASTA_FILE="/HG002_NA24385_son_UCSC_Ultralong_OxfordNanopore_Promethion_GM24385_1.fasta"

WORKDIR="/home"

if [ "${TOOL}" = "findtelomeres" ]
then 
    docker run -it --rm \
        -v ${IN_DIR}:${WORKDIR}/input:ro \
        -v ${OUT_DIR}:${WORKDIR}/output \
        -v ${REF_DIR}:${WORKDIR}/ref:ro \
        tel_calling \
            sh -c "touch ${WORKDIR}/output/findteltest.fa && python3 FindTelomeres/FindTelomeres.py ${WORKDIR}/input/${FASTA_FILE} > ${WORKDIR}/output/findteltest.fa"
fi

if [ "${TOOL}" = "tidehunter" ]
then 
    docker run -it --rm \
        -v ${IN_DIR}:${WORKDIR}/input:ro \
        -v ${OUT_DIR}:${WORKDIR}/output \
        -v ${REF_DIR}:${WORKDIR}/ref:ro \
        tel_calling \
        sh -c "touch ${WORKDIR}/output/tidetest.fa && TideHunter ${WORKDIR}/input/${FASTA_FILE} > ${WORKDIR}/output/tidetest.fa"
fi

if [ "${TOOL}" = "trf" ]
then 
    trf_flags='2 5 7 80 10 50 2000 -f -d -m'
    docker run -it --rm \
        -v ${IN_DIR}:${WORKDIR}/input:ro \
        -v ${OUT_DIR}:${WORKDIR}/output \
        -v ${REF_DIR}:${WORKDIR}/ref:ro \
        tel_calling \
            trf ${WORKDIR}/input/${FASTA_FILE} ${trf_flags}
fi

if [ "${TOOL}" = "telomerecat" ]
then 
    docker run -it --rm \
        -v ${IN_DIR}:${WORKDIR}/input:ro \
        -v ${OUT_DIR}:${WORKDIR}/output \
        -v ${REF_DIR}:${WORKDIR}/ref:ro \
        tel_calling \
        telomerecat bam2telbam -v 2 --outbam_dir ${WORKDIR}/output ${WORKDIR}/input/${BAM_FILE} 
fi

if [ "${TOOL}" = "telseq" ]
then 
    docker run -it --rm \
        -v ${IN_DIR}:${WORKDIR}/input:ro \
        -v ${OUT_DIR}:${WORKDIR}/output \
        -v ${REF_DIR}:${WORKDIR}/ref:ro \
        telseq \
            telseq -o ${WORKDIR}/output ${WORKDIR}/input/${BAM_FILE} 
fi
        
