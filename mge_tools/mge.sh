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
if [ "${TOOL}" = "xtea"]
then
    docker run \
        --volume ${IN_DIR}:${IN_DIR}:ro \
        --volume ${OUT_DIR}:${OUT_DIR} \
        --volume ${REF_DIR}:${REF_DIR}:ro \
        xtea \
        --case_ctrl \
        --tumor -i sample_id.txt\
        -b case_ctrl_bam_list.txt\
        -p ${IN_DIR} \
        -o case_control.sh \
        -l ${IN_DIR}/annotation \
        -r  ${REF_DIR}/hg38.fa \
        -g /home/gene_annotation_file.gff3 \
        --xtea ${IN_DIR}\xtea -y 7 -f 5907 -q short -n 32 -m 250
    docker run \
        --volume ${IN_DIR}:${IN_DIR}:ro \
        --volume ${OUT_DIR}:${OUT_DIR} \
        --volume ${REF_DIR}:${REF_DIR}:ro \
        xtea_long \
        -i sample_id.txt \
        -b long_read_bam_list.txt \
        -p ${IN_DIR} \
        -o long_reads.sh \
        --rmsk ./rep_lib_annotation/LINE/hg38/hg38_L1_larger_500_with_all_L1HS.out \
        -r  ${REF_DIR}/hg38.fa \
        --cns ./rep_lib_annotation/consensus/LINE1.fa \
        --rep ${IN_DIR}/annotation \
        --xtea ${WORKDIR}\xtea_long -f 5907 -y 7 -n 32 -m 250 -q long
