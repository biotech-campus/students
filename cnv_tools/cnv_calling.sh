docker build -t cnv_calling:latest .

CONTAINER="cnv_calling:latest"
TOOL="$1"
WORKDIR="/home"
CPU=6

# Input BAM files
IN_DIR="/mnt/data/common_private/data01/PG/Alignment"
if [ "$2" = "short" ]
then
    BAM_FILE="000000000500.MGI.cutadapt.bwa.MarkDuplicates" # Short reads
else
    BAM_FILE="000000000500.ONT.all_chem.dorado_sup@v4.3_C@v1_A@v2.minimap2.MarkDuplicates" # Long reads
fi

# Reference data
REF_DIR="/mnt/data/common/hg38"
TARGET_GRCh38_BED=GRCh38.d1.vd1.main.bed
CHROMS=$(cat ${REF_DIR}/chroms.txt)

# Output
OUT_DIR="/mnt/data/ayamoncheryaev/${TOOL}/${BAM_FILE}"

VOLUME_OPTIONS="--volume ${REF_DIR}:${REF_DIR}:ro \
        --volume ${IN_DIR}:${IN_DIR}:ro \
        --volume ${OUT_DIR}:${OUT_DIR}"


# Create directory for a singular bam output data (.../tool/bam_filename/)
mkdir -p ${OUT_DIR}


if [ "${TOOL}" = "cnvpytor" ]
then 
    docker run \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            python3 cnvpytor_launch.py \
                --bam ${IN_DIR}/${BAM_FILE}.bam \
                -o ${OUT_DIR} \
                --cpu ${CPU} \
                --chroms ${CHROMS} \
                --hists 1000 10000 100000
fi


if [ "${TOOL}" = "spectre" ]
then 
    WINDOW_SIZE=1000
    coverage_call="mkdir -p ${OUT_DIR}/temp && \
                        mosdepth \
                            -x -n \
                            -t ${CPU} \
                            -Q 20 \
                            -b 1000 \
                            ${OUT_DIR}/temp/${BAM_FILE} \
                            ${IN_DIR}/${BAM_FILE}.bam"

    spectre_call="spectre CNVCaller \
                    --threads ${CPU} \
                    --coverage ${OUT_DIR}/temp/${BAM_FILE}.regions.bed.gz \
                    --sample-id ${BAM_FILE} \
                    --output-dir ${OUT_DIR} \
                    --reference ${REF_DIR}/hg38.fa \
                    --min-cnv-len 80000 \
                    --blacklist ${REF_DIR}/data/grch38_blacklist.bed\
                    --metadata ${REF_DIR}/data/grch38.mdr \
                    --only-chr ${CHROMS}"

    command="${coverage_call} && ${spectre_call}"

    docker run \
        --cpus=${CPU} \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            sh -c "${command}"
                
fi


if [ "${TOOL}" = "truvari" ]
then 

    docker run -it --rm \
        --cpus=${CPU} \
        ${VOLUME_OPTIONS} \
        ${CONTAINER}
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
                --min_sv_size 1000 \
                --types=DEL,DUP:TANDEM,DUP:INT \
fi


if [ "${TOOL}" = "cnvkit" ]
then 
    docker run \
        --cpus=${CPU} \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            cnvkit.py batch \
                ${IN_DIR}/${BAM_FILE}.bam -n \
                -f ${REF_DIR}/hg38.fa \
                --output-reference ${OUT_DIR}/flat_reference.cnn \
                --annotate ${REF_DIR}/refFlat.txt \
                -d ${OUT_DIR}/ \
                -m wgs \
                -p ${CPU}
fi
