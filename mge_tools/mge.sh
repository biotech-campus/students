# QUAST
#docker build dockerfile_mge
docker pull shoheikojima/megane:v1.01.beta
CONTAINER = "mge_tools:latest"
REF_DIR="/mnt/data/common/hg38"
IN_DIR="/mnt/data/sychev/input/"
OUT_DIR="/mnt/data/sychev/output/"
BAM_FILE="HG002_GRCh38_ONT-UL_GIAB_20200204"
TOOL = $1
OUT_DIR="/mnt/data/sychev/${TOOL}"
CPU=40
MEMORY=200G
WORKDIR = "/home"
if ["${TOOL}" = "megane"]
then
  docker run -it --rm \
        -v ${IN_DIR}:${WORKDIR}/input:ro \
        -v ${OUT_DIR}:${WORKDIR}/output \
        -v ${REF_DIR}:${WORKDIR}/reference:ro \
        build_kmerset \
        -fa ${WORKDIR}/reference \
        -prefix ${WORKDIR}/reference/hg38.fa
        -outdir ${WORKDIR}/output/megane_kmer_set \
        call_genotype_38  \
        -i ${WORKDIR}/input \
        -fa ${WORKDIR}/reference \
        -mk ${WORKDIR}/output/megane_kmer_set \
        -outdir ${WORKDIR}/output/megane_result_test \
        -sample_name test_sample \
        -p 4
