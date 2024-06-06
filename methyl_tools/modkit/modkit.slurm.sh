#!/bin/bash

SING_DIR="/mnt/Storage/testdata/Temp/sing_containers"
REF_DIR="/mnt/Storage/databases/reference"

### HG38
REF="${REF_DIR}/GRCh38.d1.vd1.fa"
INCLUDE_BED="--include-bed ${REF_DIR}/GRCh38.d1.vd1.main.bed"
INPUT_BAM_SUFFIX="ONT.all_chem.dorado_hac@v5.0_CG@v1.minimap2.MarkDuplicates.bam"
REF_NAME=""
### T2T
# REF="${REF_DIR}/T2T-CHM13v2.0/GCF_009914755.1/GCF_009914755.1_T2T-CHM13v2.0_genomic.fna"
# REF_NAME="T2T-CHM13v2.0"
# INPUT_BAM_SUFFIX="ONT.all_chem.dorado_hac@v5.0_CG@v1.minimap2_T2T-CHM13v2.0.MarkDuplicates.bam"

SLURM_MEMORY=100
SLURM_CPU=12
THREADS=${SLURM_CPU}

TOOL_NAME="modkit"
IMAGE="${SING_DIR}/modkit_0.2.8.sif"

OUTPUT_SUFFIX=${INPUT_BAM_SUFFIX%.*}


### Params to vary
# SUBCOMMAND="pileup-hemi"
SUBCOMMAND="pileup"

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
# INTERVAL_SIZE="--interval-size 10000"
###

SAMPLES="000027000010 000027000020 000027000030 000027000040 000027000050 000027000060 000027000110 000027000120 000027000130 000027000140 000027000150 000027000160 000027000180 000027000190 000027000200 000027000210 000027000220 000027000250 000027000260 000027000270 000027000280 000027000290 000027000300 000027000310 000027000330 000027000340 000027000360 000027000380"

for SAMPLE in ${SAMPLES}; do
	PROJECT=${SAMPLE:0:6}
	SAMPLE_DIR="/mnt/Storage/testdata/Results/${PROJECT}/${SAMPLE}"
    INPUT_DIR="${SAMPLE_DIR}/Alignments"
    OUTPUT_DIR="${SAMPLE_DIR}/Epigenetics"
    OUTPUT="${OUTPUT_DIR}/${OUTPUT_SUFFIX}"

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
                --ref ${REF_DIR}/${REF_FASTA} \
                --threads ${THREADS} \
                 ${INTERVAL_SIZE} \
                 ${FILTER_THRESHOLD} \
                ${INCLUDE_BED} \
                ${OUTPUT_FORMAT} \
                ${BAM_DIR}/${BAMFILE} \
                ${OUT_DIR}/modkit_pileup_bedgraph \
                --log-filepath ${OUT_DIR}/modkit_debug.log |
		sbatch --parsable --job-name ${TOOL_NAME}-${SAMPLE} \
			--mem ${SLURM_MEMORY} --cpus-per-task ${SLURM_CPU} \
			--time 10:00:00 \
			-o "${WORK_DIR}/Logs/${SAMPLE}.telseq.out" \
			-e "${WORK_DIR}/Logs/${SAMPLE}.telseq.err" \
			--partition CPU --nice
		)
		echo "Submit JOB=${TELSEQ_JOB} ${TOOL_NAME}"
	# fi
done
