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

VOLUME_OPTIONS="--volume ${REF_DIR}:${REF_DIR}:ro \
        --volume ${IN_DIR}:${IN_DIR}:ro \
        --volume ${OUT_DIR}:${OUT_DIR}"


if [ "${TOOL}" = "cnvpytor" ]
then 
    docker run \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            python3 cnvpytor_launch.py \
                --bam ${IN_DIR}/${BAM_FILE}.bam \
                -o ${OUT_DIR} \
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
                    ${OUT_DIR}/${BAM_FILE} \
                    ${IN_DIR}/${BAM_FILE}.bam \
                && \
                spectre CNVCaller \
                    --threads ${CPU} \
                    --coverage ${OUT_DIR}/${BAM_FILE}.regions.bed.gz \
                    --sample-id ${BAM_FILE} \
                    --output-dir ${OUT_DIR}/spectre_output/ \
                    --reference ${REF_DIR}/hg38.fa \
                    --min-cnv-len 80000 \
                    --blacklist ${IN_DIR}/data/grch38_blacklist.bed\
                    --metadata ${IN_DIR}/data/grch38.mdr \
                    --only-chr ${CHROMS}"
fi


if [ "${TOOL}" = "vcftoolz" ]
then 
    docker run \
        --cpus=${CPU} \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            sh -c "
            cd ${OUT_DIR}/pbsv_phased && \
            vcftoolz compare \
                ${OUT_DIR}//HG002_GRCh38_ONT-UL_GIAB_20200204_10000.vcf.gz \
                ${OUT_DIR}/HG002_GRCh38_ONT-UL_GIAB_20200204.vcf.gz \
                ${OUT_DIR}/HG002.GRCh38.pbsv.phased.vcf.gz \
                > ${OUT_DIR}/pbsv_phased/summary.txt"
fi


if [ "${TOOL}" = "svim" ]
then 
    docker run \
        --cpus=${CPU} \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            svim alignment \
                ${OUT_DIR} \
                ${IN_DIR}/${BAM_FILE}.bam \
                ${REF_DIR}/hg38.fa  \
                --min_mapq 14 \
                --min_sv_size 1000 \
                --types=DEL,INS,DUP:TANDEM 
fi


if [ "${TOOL}" = "cnvkit" ]
then 
    docker run \
        --cpus=${CPU} \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            cnvkit.py batch \
                ${IN_DIR}/${BAM_FILE} -n \
                -f ${REF_DIR}/hg38.fa \
                --access ${OUT_DIR}/access.hg38.bed \
                --output-reference ${OUT_DIR}/flat_reference.cnn \
                -d ${OUT_DIR}/ \
                -m wgs \
                -p ${CPU}
fi