#!/bin/bash 
CPU=8

MASKED_ASSEMBLY_DIR="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/data/masked_assembly"
MASKED_ASSEMBLY="GCF_017311325.1_ASM1731132v1_genomic.fna.masked"
RNA_SEQ_DIR="/mnt/data/common_private/data01/Bear/rna/SRR20746745"
SRA_IDS="SRR20746745"
OUT_DIR="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/braker2/mode2_rnaseq"
SPECIES="Ursus_maritimus"

WORKDIR_BRAKER="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/braker2"

docker run --rm -d -u 0:100 --cpus=${CPU} \
        -v ${MASKED_ASSEMBLY_DIR}:${MASKED_ASSEMBLY_DIR}:ro \
        -v ${RNA_SEQ_DIR}:${RNA_SEQ_DIR}:ro \
        -v ${OUT_DIR}:${OUT_DIR} \
        -v ${WORKDIR_BRAKER}:${WORKDIR_BRAKER} \
        teambraker/braker3:latest \
            sh -c "cp ${WORKDIR_BRAKER}/.gm_key ~/.gm_key && \
            braker.pl --genome ${MASKED_ASSEMBLY_DIR}/${MASKED_ASSEMBLY} \
                      --species=${SPECIES} \
                      --rnaseq_sets_ids ${SRA_IDS} \
                      --rnaseq_sets_dir ${RNA_SEQ_DIR} \
                      --workingdir ${OUT_DIR} \
                      --threads ${CPU}"
                