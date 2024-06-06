#!/bin/bash
set -e
# shellcheck disable=SC2086

SING_DIR="/mnt/Storage/testdata/Temp/sing_containers"
REF_DIR="/mnt/Storage/databases/reference"


SLURM_MEMORY=100
SLURM_CPU=12
THREADS=${SLURM_CPU}

TOOL_NAME="modkit"
IMAGE="${SING_DIR}/modkit_0.2.8.sif"


### Params to vary
## HG38
REF="${REF_DIR}/GRCh38.d1.vd1.fa"
INCLUDE_BED="--include-bed ${REF_DIR}/GRCh38.d1.vd1.main.bed"
INPUT_SUFFIX="ONT.all_chem.dorado_hac@v5.0_CG@v1.minimap2.MarkDuplicates.bam"
## T2T
# REF="${REF_DIR}/T2T-CHM13v2.0/GCF_009914755.1/GCF_009914755.1_T2T-CHM13v2.0_genomic.fna"
# INCLUDE_BED=""
# INPUT_SUFFIX="ONT.all_chem.dorado_hac@v5.0_CG@v1.minimap2_T2T-CHM13v2.0.MarkDuplicates.bam"

OUTPUT_SUFFIX=${INPUT_SUFFIX%.*}

SUBCOMMAND="pileup"
# SUBCOMMAND="pileup-hemi"

## only-tabs
OUTPUT_FORMAT="--only-tabs"
OUTPUT_SUFFIX="${OUTPUT_SUFFIX}.modkit_${SUBCOMMAND}_onlytabs.bedmethyl"

## bedgraph
# OUTPUT_FORMAT="--bedgraph"
# OUTPUT_SUFFIX="${OUTPUT_SUFFIX}.modkit_${SUBCOMMAND}_bedgraph"

## no
# OUTPUT_FORMAT=""
# OUTPUT_SUFFIX="${OUTPUT_SUFFIX}.modkit_${SUBCOMMAND}"

FILTER_THRESHOLD="--filter-threshold C:0.75 --filter-threshold A:0.85"
INTERVAL_SIZE=""
# INTERVAL_SIZE="--interval-size 10000"
###

SAMPLES="000027000010 000027000020 000027000030 000027000040 000027000050 000027000060 000027000110 000027000120 000027000130 000027000140 000027000150 000027000160 000027000180 000027000190 000027000200 000027000210 000027000220 000027000250 000027000260 000027000270 000027000280 000027000290 000027000300 000027000310 000027000330 000027000340 000027000360 000027000380"
# SAMPLES="000027000010 "

for SAMPLE in ${SAMPLES}; do
    echo "Run ${SAMPLE} ${TOOL_NAME}"
    
    PROJECT=${SAMPLE:0:6}
    SAMPLE_DIR="/mnt/Storage/testdata/Results/${PROJECT}/${SAMPLE}"
    INPUT_DIR="${SAMPLE_DIR}/Alignments"
    INPUT="${INPUT_DIR}/${SAMPLE}.${INPUT_SUFFIX}"
    OUTPUT_DIR="${SAMPLE_DIR}/Epigenetics"
    OUTPUT="${OUTPUT_DIR}/${SAMPLE}.${OUTPUT_SUFFIX}"

    ## create if not exists
    if [[ ! -d ${OUTPUT_DIR} ]]; then 
        mkdir -p ${OUTPUT_DIR}
    fi

    ## do / do not rewrite 
    # if [ ! -f ${OUTPUT} ]; then
        MODKIT_JOB=$(
            echo -e "#!/bin/bash\n" \
            singularity run \
                --bind ${REF_DIR}:${REF_DIR}:ro \
                --bind ${INPUT_DIR}:${INPUT_DIR}:ro \
                --bind ${OUTPUT_DIR}:${OUTPUT_DIR} \
                --workdir ${OUTPUT_DIR} \
                ${IMAGE} \
                modkit ${SUBCOMMAND} --cpg \
                    --ref ${REF} \
                    --threads ${THREADS} \
                    ${INTERVAL_SIZE} \
                    ${FILTER_THRESHOLD} \
                    ${INCLUDE_BED} \
                    ${OUTPUT_FORMAT} \
                    ${INPUT} \
                    ${OUTPUT} |
            sbatch --parsable --job-name ${TOOL_NAME}-${SAMPLE} \
                --mem ${SLURM_MEMORY} --cpus-per-task ${SLURM_CPU} \
                --time 10:00:00 \
                -o "${SAMPLE_DIR}/Logs/${SAMPLE}.${OUTPUT_SUFFIX}.out" \
                -e "${SAMPLE_DIR}/Logs/${SAMPLE}.${OUTPUT_SUFFIX}.err" \
                --partition CPU,GPU --nice=800
        )
	    echo -e "Submited ${JOB_NAME} ${MODKIT_JOB}, \n\t INPUT ${INPUT}, \n\t OUTPUT ${OUTPUT}"
    # fi
done
