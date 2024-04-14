docker build -t homer -f Dockerfile_homer .

CONTAINER=homer
REF_DIR="/mnt/data/common/hg38"
IN_DIR="/mnt/data/mshokodko/input"
OUT_DIR="/mnt/data/mshokodko/output"
CONVERTED_BED="/mnt/data/mshokodko/output/converted.bed"
DIR="/mnt/data/mshokodko"
WORKDIR="/home"
CPU=40
MEMORY=200G

# Использование HOMER для аннотации метилированных сайтов
# '''
# Аннотация позволяет определить, находятся ли метилированные участки в 
# промоторах, экзонах, интронах, интергенических регионах или вблизи энхансеров.
# '''
docker run -it --rm \
    --volume ${IN_DIR}:${WORKDIR}/input:ro \
    --volume ${OUT_DIR}:${WORKDIR}/output \
    ${CONTAINER} \
    /home/bin/annotatePeaks.pl -h
    # /home/bin/annotatePeaks.pl ${CONVERTED_BED} hg38 > ${WORKDIR}/output/annotatedPeaks.txt



# # Использование HOMER для поиска мотивов вблизи метилированных сайтов
# '''
# Дополнительный анализ обогащения мотивов в аннотированных метилированных регионах может выявить 
# конкретные последовательности ДНК, предпочтительно связывающиеся с определенными транскрипционными факторами. 
# Это помогает разгадать сети регуляции генов и пути сигнальной передачи, в которых метилирование играет важную роль.
# '''
# docker run -it --rm \
#     --volume ${IN_DIR}:${WORKDIR}/input:ro \
#     --volume ${OUT_DIR}:${WORKDIR}/output \
#     ${CONTAINER} \
#     /home/bin/findMotifsGenome.pl ${CONVERTED_BED} hg38 ${WORKDIR}/output/motifs -size 200
