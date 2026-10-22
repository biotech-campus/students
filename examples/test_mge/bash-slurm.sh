#!/bin/bash
set -e
# shellcheck disable=SC2086

SING_DIR="/mnt/Storage/software/containers/singularity"
REF_DIR="/mnt/Storage/bd/reference"
RESULTS_DIR="/mnt/Storage/results"


IMAGE="${SING_DIR}/megane_1.0.1.sif"

### Params to vary
## HG38
REF_FILE_NAME="GRCh38.d1.vd1.fa"
REF="${REF_DIR}/${REF_FILE_NAME}"
REF_MK="${REF_DIR}/${REF_FILE_NAME}.mk"
INPUT_SUFFIX="MGI.cutadapt.bwa.MarkDuplicates.bam"
## T2T
# REF_FILE_NAME="GCF_009914755.1_T2T-CHM13v2.0_genomic.fna"
# REF="${REF_DIR}/T2T-CHM13v2.0/GCF_009914755.1/${REF_FILE_NAME}"
# INPUT_SUFFIX="MGI.cutadapt.bwa_T2T-CHM13v2.0.MarkDuplicates.bam"



# COHORT_NAME="5_norma"
# OUTPUT_COHORT_DIR="/mnt/Storage/testdata/Temp/MGE/${COHORT_NAME}"
# rm -rvf ${OUTPUT_COHORT_DIR}
# mkdir -p ${OUTPUT_COHORT_DIR}

#### build one time
# TOOL_NAME="megane_build"
# echo "Run ${TOOL_NAME}"
# SLURM_MEMORY=400
# SLURM_CPU=42
# THREADS=${SLURM_CPU}
# MEGANE_BUILD_JOB=$(
#     echo -e "#!/bin/bash\n" \
#     singularity run \
#         --bind ${REF_DIR}:${REF_DIR} \
#         --workdir ${REF_DIR} --pwd ${REF_DIR} \
#         ${IMAGE} \
#             build_kmerset \
#             -fa ${REF} \
#             -outdir ${REF_DIR} |
#     sbatch --parsable --job-name ${TOOL_NAME} \
#         --mem ${SLURM_MEMORY} --cpus-per-task 1 \
#         --time 10:00:00 \
#         -o "${OUTPUT_COHORT_DIR}/${TOOL_NAME}.out" \
#         -e "${OUTPUT_COHORT_DIR}/${TOOL_NAME}.err" \
#         --partition CPU,GPU,DEV --nice=800
# )
# echo -e "Submited ${TOOL_NAME} ${MEGANE_BUILD_JOB}, \n\t REF ${REF}, \n\t REF_DIR ${REF_DIR}"
# rm -vf ${OUTPUT_COHORT_DIR}/dirlist.txt

MEGANE_JOBS=""


COHORT_NAME="9_breast_cancer_buratia"
SAMPLES="000009004370 000009004380 000009004390 000009004400 000009004410 000009004200 000009004430 000009004440 000009004450 000009004460 000009004470 000009004480 000009004490 000009004500 000009004510 000009004520 000009004530 000009004540 000009004550 000009004560 000009004570 000009004580 000009004590 000009004600 000009004610 000009004620 000009004630 000009004640 000009004650 000009004660 000009004670 000009004680 000009004690 000009004700 000009004710 000009004720 000009004730 000009004740 000009005120 000009005130 000009005140 000009005150 000009005160 000009005170 000009005180 000009005190 000009005200 000009005210 000009005220 000009005230 000009005240 000009005250 000009005260 000009005270 000009005280 000009005290 000009005300 000009005310 000009005320 000009005330 000009005340 000009005350 000009005360 000009005370 000009005380 000009005390 000009005400 000009005410 000009005420 000009005430 000009005440 000009005450 000009005460 000009005470 000009005480 000009005490 000009005500 000009005510 000009005520 000009005530 000009005540 000009005550 000009005560 000009005570 000009005580 000009005590 000009005600 000009005610 000009005620 000009005630 000009005640 000009005650 000009005660 000009005670 000009005680 000009005690 000009005700 000009005710 000009005720 000009005730 000009005740 000009005750 000009005760 000009005770 000009005780 000009005790 000009005800 000009005810 000009005820 000009005830"

OUTPUT_COHORT_DIR="/mnt/Storage/testdata/Temp/MGE/${COHORT_NAME}"
rm -rvf ${OUTPUT_COHORT_DIR}
mkdir -p ${OUTPUT_COHORT_DIR}

for SAMPLE in ${SAMPLES}; do
    TOOL_NAME="megane"
    echo "Run ${SAMPLE} ${TOOL_NAME}, depends on ok ${MEGANE_BUILD_JOB}"

    SLURM_MEMORY=100
    SLURM_CPU=12
    THREADS=24

    OUTPUT_SUFFIX="${INPUT_SUFFIX%.*}.${TOOL_NAME}"

    PROJECT=${SAMPLE:0:6}
    SAMPLE_DIR="/mnt/Storage/results/${PROJECT}/${SAMPLE}"
    INPUT_DIR="${SAMPLE_DIR}/Alignments"
    INPUT="${INPUT_DIR}/${SAMPLE}.${INPUT_SUFFIX}"
    OUTPUT_DIR="${SAMPLE_DIR}/Variation"
    OUTPUT="${OUTPUT_DIR}/${SAMPLE}.${OUTPUT_SUFFIX}"
    JOB_NAME="${TOOL_NAME}-${SAMPLE}"

    if [[ ! -n "$(ls -A ${INPUT} 2>/dev/null)" ]]; then echo "!!! No alignment file ${INPUT}, skipped";  continue ; fi
    
    
    ## collect files to merge
    echo "${OUTPUT}" >> "${OUTPUT_COHORT_DIR}/dirlist.txt"

    if [[ -n "$(ls -A ${OUTPUT}/MEI_final_percentile_genotyped.vcf 2>/dev/null)" ]]; then echo "!!! Output exists ${OUTPUT}/MEI_final_percentile_genotyped.vcf, skipped";  continue ; fi

    mkdir -p ${OUTPUT_DIR}

    MEGANE_JOB=$(
        echo -e "#!/bin/bash\n" \
        singularity run \
            --bind ${REF_DIR}:${REF_DIR}:ro \
            --bind ${INPUT_DIR}:${INPUT_DIR}:ro \
            --bind ${OUTPUT_DIR}:${OUTPUT_DIR} \
            --workdir ${OUTPUT_DIR} --pwd ${OUTPUT_DIR} \
            ${IMAGE} \
                call_genotype_38 \
                    -i ${INPUT}\
                    -fa ${REF} \
                    -mk ${REF_MK} \
                    -outdir ${OUTPUT} \
                    -p ${THREADS} |
        sbatch --parsable --job-name ${JOB_NAME} \
            --mem ${SLURM_MEMORY} --cpus-per-task ${SLURM_CPU} \
            --time 2-0 \
            -o "${SAMPLE_DIR}/Logs/${SAMPLE}.${OUTPUT_SUFFIX}.out" \
            -e "${SAMPLE_DIR}/Logs/${SAMPLE}.${OUTPUT_SUFFIX}.err" \
            --partition CPU,GPU,DEV --nice=800
    )
    echo -e "Submited ${JOB_NAME} ${MEGANE_JOB}, \n\t INPUT ${INPUT}, \n\t OUTPUT ${OUTPUT}"
    MEGANE_JOBS="${MEGANE_JOBS}:${MEGANE_JOB}"

done


## merge one time
TOOL_NAME="megane_join"
echo "Run ${TOOL_NAME}, depends on ok ${MEGANE_JOBS}"

INPUT="${OUTPUT_COHORT_DIR}/dirlist.txt"

SLURM_MEMORY=400
SLURM_CPU=42
THREADS=${SLURM_CPU}
JOB_NAME="${TOOL_NAME}-${COHORT_NAME}"

MEGANE_MERGE_JOB=$(
    echo -e "#!/bin/bash\n" \
    singularity run \
        --bind ${REF_DIR}:${REF_DIR}:ro \
        --bind ${RESULTS_DIR}:${RESULTS_DIR}:ro \
        --bind ${OUTPUT_COHORT_DIR}:${OUTPUT_COHORT_DIR} \
        --workdir ${OUTPUT_COHORT_DIR} --pwd ${OUTPUT_COHORT_DIR} \
        ${IMAGE} \
            joint_calling_hs \
            -merge_mei  \
            -f ${INPUT} \
            -fa ${REF} \
            -cohort_name ${COHORT_NAME} \
            -p ${THREADS} |
    sbatch --parsable --job-name ${JOB_NAME} \
        --mem ${SLURM_MEMORY} --cpus-per-task ${SLURM_CPU} \
        --time 4-0 \
        -o "${OUTPUT_COHORT_DIR}/${TOOL_NAME}.out" \
        -e "${OUTPUT_COHORT_DIR}/${TOOL_NAME}.err" \
        --partition CPU,GPU,DEV --nice=800 \
        --kill-on-invalid-dep=yes --dependency=afterok${MEGANE_JOBS}
)
echo -e "Submited ${TOOL_NAME} ${MEGANE_MERGE_JOB}, \n\t INPUT ${INPUT}, \n\t OUTPUT_COHORT_DIR ${OUTPUT_COHORT_DIR}, \n\t LOGS ${OUTPUT_COHORT_DIR}/${TOOL_NAME}.err"
