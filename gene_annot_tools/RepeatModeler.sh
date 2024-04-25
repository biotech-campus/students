#!/bin/bash 
CPU=8
TET_TOOLS="/mnt/data/common_private/sing_containers/tetools_latest.sif"
# ASSEMBLY="/mnt/data/common_private/polar_bear/assembly.fasta"
ASSEMBLY="/mnt/data/common/GCF_017311325.1/GCF_017311325.1_ASM1731132v1_genomic.fna"
# OUT_DIR="/mnt/data/gvykhodtsev/genomes/BTC_polar_bear/RepeatModeler"
OUT_DIR="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/RepeatModeler"
SPECIES="Ursus_maritimus"


singularity exec \
    -B ${ASSEMBLY}:${ASSEMBLY}:ro \
    -B ${OUT_DIR}:${OUT_DIR} \
    ${TET_TOOLS} \
    sh -c " \
        cd ${OUT_DIR} && \
        BuildDatabase -name ${SPECIES} -engine ncbi ${ASSEMBLY} && \
        RepeatModeler -engine ncbi -threads ${CPU} -srand 777 -LTRStruct -database ${SPECIES} > RepeatModeler_out.log 
    "

# singularity shell \
#     -B ${ASSEMBLY}:${ASSEMBLY}:ro \
#     -B ${OUT_DIR}:${OUT_DIR} \
#     ${TET_TOOLS}