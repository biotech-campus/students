#!/bin/bash 
CPU=8
TET_TOOLS="/mnt/data/common_private/sing_containers/tetools_latest.sif"
# ASSEMBLY="/mnt/data/common_private/polar_bear/assembly.fasta"
ASSEMBLY="/mnt/data/common/GCF_017311325.1/GCF_017311325.1_ASM1731132v1_genomic.fna"
# REPMOD_OUT_DIR="/mnt/data/gvykhodtsev/genomes/BTC_polar_bear/RepeatModeler"
REPMOD_OUT_DIR="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/RepeatModeler"
# REPMASK_OUT_DIR="/mnt/data/gvykhodtsev/genomes/BTC_polar_bear/RepeatMasker"
REPMASK_OUT_DIR="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/RepeatMasker"
SPECIES="Ursus_maritimus"


singularity exec \
    -B ${ASSEMBLY}:${ASSEMBLY}:ro \
    -B ${REPMOD_OUT_DIR}:${REPMOD_OUT_DIR} \
    ${TET_TOOLS} \
    sh -c " \
        cd ${REPMOD_OUT_DIR} && \
        BuildDatabase -name ${SPECIES} -engine ncbi ${ASSEMBLY} && \
        RepeatModeler -engine ncbi -threads ${CPU} -srand 777 -database ${SPECIES} \
        2> RepeatModeler_out.err 1> RepeatModeler_out.log 
    "

# -srand - random seed

singularity exec \
    -B ${ASSEMBLY}:${ASSEMBLY}:ro \
    -B ${REPMOD_OUT_DIR}:${REPMOD_OUT_DIR} \
    -B ${REPMASK_OUT_DIR}:${REPMASK_OUT_DIR} \
    ${TET_TOOLS} \
    RepeatMasker -engine ncbi -pa ${CPU} -xsmall -gff -nolow \
    -lib ${REPMOD_OUT_DIR}/RM_*/consensi.fa.classified -dir ${REPMASK_OUT_DIR} \
    ${ASSEMBLY} 2> ${REPMASK_OUT_DIR}/RepeatMasker_out.err 1> ${REPMASK_OUT_DIR}/RepeatMasker_out.log

# -xsmall - softmasking, -nolow - not mask low complexity repeats, -gff - additional GFF file

# singularity shell \
#     -B ${ASSEMBLY}:${ASSEMBLY}:ro \
#     -B ${OUT_DIR}:${OUT_DIR} \
#     ${TET_TOOLS}