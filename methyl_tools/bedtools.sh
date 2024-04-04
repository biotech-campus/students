docker build -t bedtools -f Dockerfile_bedtools .

CONTAINER=bedtools
REF_DIR="/mnt/data/common/hg38"
IN_DIR="/mnt/data/mshokodko/input"
OUT_DIR="/mnt/data/mshokodko/output"
BAMFILE="bam_encodeproject.org_ENCFF681ASN.bam"
ANNOTATION_BEDFILE="/mnt/data/common/hg38/GRCh38.d1.vd1.main.bed"
# Аннотационные BED файлы, содержащие информацию о генах, промоторах, экзонах и других геномных элементах брать:
# https://genome.ucsc.edu/cgi-bin/hgTables
# NCBI Gene/Genome
# Ensembl предоставляет доступ к аннотационным данным через BioMart инструмент, который позволяет пользовательски настраивать и скачивать данные в различных форматах, включая BED.
DIR="/mnt/data/mshokodko"
WORKDIR="/home"
CPU=40
MEMORY=200G

docker run -it --rm \
    --volume ${IN_DIR}:${WORKDIR}/input:ro \
    --volume ${OUT_DIR}:${WORKDIR}/output \
     ${CONTAINER} \
      bedtools --help

# Какую информацию можно получить:
# 1 - Локализацию метилированных сайтов относительно геномных элементов:
# Используя bedtools intersect, вы можете идентифицировать, какие регионы метилирования (из вашего BAM файла, конвертированного в BED) перекрываются с известными геномными элементами (например, генами или промоторами). Это поможет понять потенциальное функциональное значение метилирования в различных регионах генома.

# 2 - Покрытие метилированных сайтов:
# Используя bedtools coverage, можно оценить глубину секвенирования в регионах метилирования по всему геному или в конкретных интересующих областях. Это позволяет определить, достаточно ли данных для надежного анализа уровней метилирования.

# 3 - Пространственное распределение метилирования:
# bedtools может помочь определить, сосредоточено ли метилирование в определенных областях генома (например, в промоторах генов или в генах, ассоциированных с определенными функциями), что может указывать на регуляторные механизмы влияния метилирования на экспрессию генов.

# 4 - Идентификация потенциальных регуляторных элементов:
# Анализируя перекрытие между метилированными регионами и регионами, известными как регуляторные элементы (энхансеры, силенсеры), вы можете выявить потенциальные участки регуляции генов.

# 5 - Анализ ближайших генов или элементов к метилированным сайтам:
# bedtools closest позволяет идентифицировать ближайшие гены или другие геномные элементы к местам метилирования, что может быть полезно для понимания потенциального влияния метилирования на эти гены или элементы



# # Конвертация BAM в BED
# docker run -it --rm \
#     --volume ${IN_DIR}:${WORKDIR}/input:ro \
#     --volume ${OUT_DIR}:${WORKDIR}/output \
#     ${CONTAINER} \
#     bamtobed -i ${WORKDIR}/input/${BAMFILE} > ${WORKDIR}/output/converted.bed



# # Поиск пересечений между метилированными регионами и аннотациями
# '''
# Это позволяет идентифицировать, какие из метилированных регионов совпадают с известными генетическими элементами, 
# такими как гены, промоторы или регуляторные области. 
# Это важно для понимания потенциального функционального влияния метилирования на генную экспрессию и регуляцию.
# '''
# docker run -it --rm \
#     --volume ${IN_DIR}:${WORKDIR}/input:ro \
#     --volume ${OUT_DIR}:${WORKDIR}/output \
#     --volume ${REF_DIR}:${WORKDIR}/reference:ro \
#     ${CONTAINER} \
#     intersect -a ${WORKDIR}/output/converted.bed -b ${WORKDIR}/reference/${ANNOTATION_BEDFILE} > ${WORKDIR}/output/intersected.bed



# # Подсчет покрытия аннотированных регионов
# '''
# Для определения, как часто каждый из аннотированных геномных регионов (из аннотационного BED файла) 
# покрывается ридами (метилированными регионами из конвертированного BED). 
# Это даёт понимание о глубине и равномерности покрытия этих регионов, что важно для оценки достоверности данных метилирования.
# '''
# docker run -it --rm \
#     --volume ${IN_DIR}:${WORKDIR}/input:ro \
#     --volume ${OUT_DIR}:${WORKDIR}/output \
#     ${CONTAINER} \
#     coverage -a ${WORKDIR}/reference/${ANNOTATION_BEDFILE} -b ${WORKDIR}/output/converted.bed > ${WORKDIR}/output/coverage.txt



# # Поиск ближайших генетических элементов к метилированным сайтам
# '''
# Ищет ближайший аннотированный геномный элемент. 
# Это позволяет идентифицировать потенциально регулируемые гены или другие важные элементы, 
# находящиеся в непосредственной близости от мест метилирования. 
# Это особенно полезно для выявления новых потенциальных регуляторных взаимодействий 
# и механизмов регуляции генной экспрессии через метилирование.
# '''
# docker run -it --rm \
#     --volume ${IN_DIR}:${WORKDIR}/input:ro \
#     --volume ${OUT_DIR}:${WORKDIR}/output \
#     ${CONTAINER} \
#     closest -a ${WORKDIR}/output/converted.bed -b ${WORKDIR}/reference/${ANNOTATION_BEDFILE} > ${WORKDIR}/output/closest.bed

# echo "Анализ метилирования завершен. Результаты в директории ${OUT_DIR}."
