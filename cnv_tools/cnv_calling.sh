docker build -t cnv_calling:latest .

# CNV
CONTAINER="cnv_calling:latest"
TOOL="cnvpytor"
WORKDIR="/home"

# Input
REF_DIR="/mnt/data/common/hg38"
IN_DIR="/mnt/data/ayamoncheryaev/"
OUT_DIR="/mnt/data/ayamoncheryaev/${TOOL}"
# BAMFILE="/HG002_GRCh38_ONT-UL_GIAB_20200122.phased.bam"
BAMFILE="/HG002.GRCh38.2x250.bam"

CPU=5

docker run -it --rm\
    --volume ${REF_DIR}:"${WORKDIR}/reference":ro \
    --volume ${IN_DIR}:"${WORKDIR}/input":ro \
    --volume ${OUT_DIR}:"${WORKDIR}/output" \
    --workdir ${WORKDIR} \
    ${CONTAINER} \
        python3 script.py cnvpytor \
        --bam="${WORKDIR}/input/${BAMFILE}"


        