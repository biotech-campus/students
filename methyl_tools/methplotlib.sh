docker build -t methplotlib -f Dockerfile_methplotlib .

CONTAINER=methplotlib
OUT_DIR="/mnt/data/mshokodko/output/methplotlib"

BEDMETHYL_DIR="/mnt/data/mshokodko/output/modkit_pileup_bedmethyl"
BAM_DIR="/mnt/data/common_private/platinum/Alignment"
REF_DIR="/mnt/data/common_private/human_ref/hg38"

BEDMETHYL_FILE="cpg_onlytabs.bedmethyl"
BAM_FILE="000000000500.ONT.all_chem.dorado_sup@v4.3_C@v1_A@v2.minimap2.MarkDuplicates.bam"
REF_FASTA="GRCh38.d1.vd1.fa"

CPU=6

DOCKER_OPTIONS="--volume ${BAM_DIR}:${BAM_DIR}:ro \
        --volume ${REF_DIR}:${REF_DIR}:ro \
        --volume ${OUT_DIR}:${OUT_DIR} \
        --volume ${BEDMETHYL_DIR}:${BEDMETHYL_DIR}"

 # Хотя другие геномные браузеры, такие как IGV (Thorvaldsdóttir et al., 2013) и GenomeBrowse, 
 # в некоторой степени предоставляют аналогичную функциональность, 
 # например, для построения графика частоты измененных позиций, 
 # визуализация вероятности на одно чтение - это уникальная функция methplotlib

docker run -it --rm \
    ${DOCKER_OPTIONS} \
    ${CONTAINER} \
        methplotlib \
        -m ${BEDMETHYL_DIR}/${BEDMETHYL_FILE} \
        -n "chr1:10460-11000" \
        -w "chr1:10460-11000" \
        -o ${OUT_DIR}/methplotlib_output_v1_chr1:10460-11000.html