docker build -t methyl_tools .
docker build -t methylkit -f Dockerfile_methylkit .

CONTAINER=$1
REF_DIR="/mnt/data/common/hg38"
IN_DIR="/mnt/data/mshokodko/input"
OUT_DIR="/mnt/data/mshokodko/output"
BAMFILE1="bam_encodeproject.org_ENCFF681ASN.bam"
BAMFILE2="bam_encodeproject.org_ENCFF113KRQ.bam"
DIR="/mnt/data/mshokodko"
WORKDIR="/home"
CPU=40
MEMORY=200G

# Запуск контейнера и выполнение .py скрипта по предобработке данных из .bam в читаемый для methylKit .txt
docker run -it --rm \
    --volume ${IN_DIR}:${WORKDIR}/input:ro \
    --volume ${OUT_DIR}:${WORKDIR}/output \
     ${CONTAINER} \
    #     python3 ${WORKDIR}/process_bam.py ${WORKDIR}/input/${BAMFILE1} ${WORKDIR}/output/output_first_data.txt
    #     python3 ${WORKDIR}/process_bam.py ${WORKDIR}/input/${BAMFILE2} ${WORKDIR}/output/output_second_data.txt

# # Выполнение анализа в methylKit через .R скрипт
# docker run -it --rm \
#     --volume ${IN_DIR}:${WORKDIR}/input:ro \
#     --volume ${OUT_DIR}:${WORKDIR}/output \
#     ${CONTAINER} \
#         Rscript ${WORKDIR}/methyl_analysis.R
