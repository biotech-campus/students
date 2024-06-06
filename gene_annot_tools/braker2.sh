#!/bin/bash 
CPU=8

MASKED_ASSEMBLY="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/RepeatMasker/GCF_017311325.1_ASM1731132v1_genomic.fna.masked"
RNA_SEQ_DIR="/mnt/data/common_private/polar_bear/rna"
SRA_IDS="SRR20746745"
OUT_DIR="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/BRAKER2"
SPECIES="Ursus_maritimus"
GM_KEY="/home/gvykhodtsev/projects/arctic_genomes/.gm_key"

docker run --rm -d -u 0:100 --cpus=${CPU} \
        -v ${MASKED_ASSEMBLY}:${MASKED_ASSEMBLY}:ro \
        -v ${RNA_SEQ_DIR}:${RNA_SEQ_DIR}:ro \
        -v ${GM_KEY}:${GM_KEY}:ro \
        -v ${OUT_DIR}:${OUT_DIR} \
        teambraker/braker3:latest \
            sh -c " \
                cp ${GM_KEY} ~/.gm_key && \
                braker.pl --genome ${MASKED_ASSEMBLY} \
                          --species ${SPECIES} \
                          --rnaseq_sets_ids ${SRA_IDS} \
                          --rnaseq_sets_dir ${RNA_SEQ_DIR} \
                          --workingdir ${OUT_DIR} \
                          --threads ${CPU}
            "

# docker run --rm -it -u 0:100 --cpus=${CPU} \
#         -v ${MASKED_ASSEMBLY}:${MASKED_ASSEMBLY}:ro \
#         -v ${RNA_SEQ_DIR}:${RNA_SEQ_DIR}:ro \
#         -v ${GM_KEY}:${GM_KEY}:ro \
#         -v ${OUT_DIR}:${OUT_DIR} \
#         teambraker/braker3:latest \
#             sh -c "cp ${GM_KEY} ~/.gm_key && bash"