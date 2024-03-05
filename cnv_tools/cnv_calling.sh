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

# Output
OUT_DIR="/mnt/data/ayamoncheryaev/${TOOL}"

VOLUME_OPTIONS="--volume ${REF_DIR}:${WORKDIR}/reference:ro \
        --volume ${IN_DIR}:${WORKDIR}/input:ro \
        --volume ${OUT_DIR}:${WORKDIR}/output"


if [ "${TOOL}" = "cnvpytor" ]
then 
    docker run --rm \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            python3 script.py ${TOOL} \
            --bam ${WORKDIR}/input/${BAM_FILE}.bam \
            -o ${WORKDIR}/output \ 
            --cpu ${CPU}
fi

if [ "${TOOL}" = "cnvkit" ]
then 
    docker run \
        --cpus=${CPU} \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            cnvkit.py batch \
                ${WORKDIR}/input/${BAM_FILE} -n \
                -f ${WORKDIR}/reference/hg38.fa \
                --access ${WORKDIR}/output/access.hg38.bed \
                --output-reference ${WORKDIR}/output/flat_reference.cnn \
                -d ${WORKDIR}/output/ \
                -m wgs \
                -p ${CPU}
fi


if [ "${TOOL}" = "sniffles" ]
then 
    docker run \
        --cpus=${CPU} \
        ${VOLUME_OPTIONS} \
        ${CONTAINER} \
            sniffles --input ${WORKDIR}/input/${BAM_FILE}.bam \
                --vcf ${WORKDIR}/output/${BAM_FILE}.vcf \
                --snf ${WORKDIR}/output/${BAM_FILE}.snf \
                --threads ${CPU} \
                --reference ${WORKDIR}/reference/hg38.fa \
                --allow-overwrite            
fi