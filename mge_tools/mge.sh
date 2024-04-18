# QUAST
docker build -t mge_tools:latest .
CONTAINER="mge_tools:latest"
REF_DIR="/mnt/data/common/hg38"
IN_DIR="/mnt/data/common_private/data01/PG/Alignment"
BAM_FILE="000000000500.MGI.cutadapt.bwa.MarkDuplicates"
TOOL=$1
OUT_DIR="/mnt/data/sychev/output"
CPU=40
MEMORY=200G
WORKDIR="/home"
if [ "${TOOL}" = "megane" ]
then
    docker pull shoheikojima/megane:v1.0.1.beta
    docker run \
        --volume ${IN_DIR}:${IN_DIR}:ro \
        --volume ${OUT_DIR}:${OUT_DIR} \
        --volume ${REF_DIR}:${REF_DIR}:ro \
        shoheikojima/megane:v1.0.1.beta #\
        build_kmerset \
        -fa ${REF_DIR}/hg38.fa \
        -outdir ${OUT_DIR}/megane_kmer_set
    docker run \
        --volume ${IN_DIR}:${IN_DIR}:ro \
        --volume ${OUT_DIR}:${OUT_DIR} \
        --volume ${REF_DIR}:${REF_DIR}:ro \
        shoheikojima/megane:v1.0.1.beta \
        call_genotype_38 \
        -i ${IN_DIR}/${BAM_FILE}.bam \
        -fa ${REF_DIR}/hg38.fa \
        -mk ${OUT_DIR}/megane_kmer_set/hg38.fa.mk \
        -outdir ${OUT_DIR}/megane_result_test/${BAM_FILE} \
        -sample_name test_sample \
         -p 4
    #docker run \
    #    --volume ${IN_DIR}:${IN_DIR}:ro \
    #    --volume ${OUT_DIR}:${OUT_DIR} \
    #    --volume ${REF_DIR}:${REF_DIR}:ro \
    #    ls ${OUT_DIR}/megane_result_test > dirlist.txt
    #docker run \
    #    --volume ${IN_DIR}:${IN_DIR}:ro \
    #    --volume ${OUT_DIR}:${OUT_DIR} \
    #    --volume ${REF_DIR}:${REF_DIR}:ro \
    #    shoheikojima/megane:v1.0.1.beta \
    #    joint_calling_hs \
    #    -merge_mei \
    #    -f dirlist.txt \
    #    -fa ${REF_DIR}/hg38.fa \
    #    -cohort_name test
fi
