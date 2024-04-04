#!/bin/bash 

# docker build -f Dockerfile.telseq -t telseq:latest .
# docker build -t tel_calling:latest .


# TOOL=$1
CPU=8

MASKED_ASSEMBLY_DIR="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/data/masked_assembly"
MASKED_ASSEMBLY="GCF_017311325.1_ASM1731132v1_genomic.fna.masked"
RNA_SEQ_DIR="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/data/RNA_seq"
OUT_DIR="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/braker2/mode2_rnaseq"

WORKDIR_BRAKER="/home/jovyan"

docker run -d --user 1000:$(id -g) --cpus=${CPU} \
        -v ${MASKED_ASSEMBLY_DIR}:${WORKDIR_BRAKER}/masked_assembly:ro \
        -v ${RNA_SEQ_DIR}:${WORKDIR_BRAKER}/RNA_seq:ro \
        -v ${OUT_DIR}:${WORKDIR_BRAKER}/output \
        teambraker/braker3:latest \
            braker.pl --genome ${WORKDIR_BRAKER}/masked_assembly/${MASKED_ASSEMBLY} \
                      --rnaseq_sets_ids $(cat ${RNA_SEQ_DIR}/SRR_id.txt) \
                      --workingdir ${WORKDIR_BRAKER}/output \
                      --threads ${CPU}
                
        