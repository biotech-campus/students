docker build -t cnv_calling:latest .

CONTAINER="cnv_calling:latest"
TOOL="$1"
WORKDIR="/home"
CPU=6

# Input
REF_DIR="/mnt/data/common/hg38"
IN_DIR="/mnt/data/ayamoncheryaev/input"
BAM_FILE="HG002_GRCh38_ONT-UL_GIAB_20200204" # Long reads
# BAM_FILE="HG002.GRCh38.2x250.bam" # Short reads
TARGET_GRCh38_BED=GRCh38.d1.vd1.main.bed
CHROMS=$(cat ${REF_DIR}/chroms.txt)

# Output
OUT_DIR="/mnt/data/ayamoncheryaev/${TOOL}"

VOLUME_OPTIONS="--volume ${REF_DIR}:${WORKDIR}/reference:ro \
        --volume ${IN_DIR}:${WORKDIR}/input:ro \
        --volume ${OUT_DIR}:${WORKDIR}/output"

if [ "${TOOL}" = "cnvpytor" ]
then 
    docker run \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            python3 cnvpytor_launch.py \
                --bam ${WORKDIR}/input/${BAM_FILE}.bam \
                -o ${WORKDIR}/output \
                --cpu ${CPU} \
                --chroms ${CHROMS}
fi

if [ "${TOOL}" = "spectre" ]
then 
    WINDOW_SIZE=1000
    docker run \
        --cpus=${CPU} \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            sh -c "
                mosdepth \
                    -x -n \
                    -t ${CPU} \
                    -Q 20 \
                    -b 1000 \
                    ${WORKDIR}/output/${BAM_FILE} \
                    ${WORKDIR}/input/${BAM_FILE}.bam \
                && \
                spectre CNVCaller \
                    --threads ${CPU} \
                    --coverage ${WORKDIR}/output/${BAM_FILE}.regions.bed.gz \
                    --sample-id ${BAM_FILE} \
                    --output-dir ${WORKDIR}/output/spectre_output/ \
                    --reference ${WORKDIR}/reference/hg38.fa \
                    --min-cnv-len 80000 \
                    --blacklist ${WORKDIR}/input/data/grch38_blacklist.bed\
                    --metadata ${WORKDIR}/input/data/grch38.mdr \
                    --only-chr ${CHROMS}"
fi
                
if [ "${TOOL}" = "vcftoolz" ]
then 
    docker run \
        --cpus=${CPU} \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            sh -c "
            cd ${WORKDIR}/output && \
            vcftoolz compare \
                ${WORKDIR}/output/HG002_GRCh38_ONT-UL_GIAB_20200204_10000.vcf.gz \
                ${WORKDIR}/output/HG002_GRCh38_ONT-UL_GIAB_20200204.vcf.gz \
                ${WORKDIR}/output/HG002.GRCh38.deepvariant.g.vcf.gz \
                > ${WORKDIR}/output/summary.txt"
fi
