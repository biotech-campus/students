#!/bin/bash 
# wget -P /mnt/data/gvykhodtsev/InterProScan/ http://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.67-99.0/alt/interproscan-data-5.67-99.0.tar.gz
# cd /mnt/data/gvykhodtsev/InterProScan
# tar -pxzf interproscan-data-5.67-99.0.tar.gz

CPU=8
INTERPROSCAN_DATA="/mnt/data/gvykhodtsev/InterProScan/interproscan-5.67-99.0/data"
INPUT_DIR="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/BRAKER2"
INTERPROSCAN_OUT="/mnt/data/gvykhodtsev/genomes/polar_bear_ASM1731132v1/InterProScan"

# Strip *(stop codon) from the end of protein sequences
cat ${INPUT_DIR}/braker.aa | sed -e 's/\*$//' > ${INPUT_DIR}/protein.fasta

docker run --rm -it --cpus=${CPU}\
    -v ${INTERPROSCAN_DATA}:/opt/interproscan/data \
    -v ${INPUT_DIR}/protein.fasta:${INPUT_DIR}/protein.fasta:ro \
    -v ${INTERPROSCAN_OUT}:${INTERPROSCAN_OUT} \
    --entrypoint /bin/sh \
    interpro/interproscan:5.67-99.0 \
    -c " \
        python3 setup.py --force interproscan.properties && \
        ./interproscan.sh \
            --input ${INPUT_DIR}/protein.fasta \
            --disable-precalc \
            --output-dir ${INTERPROSCAN_OUT} \
            --tempdir ${INTERPROSCAN_OUT}/temp \
            --cpu ${CPU} \
            2> ${INTERPROSCAN_OUT}/InterProScan_out.err 1> ${INTERPROSCAN_OUT}/InterProScan_out.log 
    "

# docker run --rm -it \
#     -v ${INTERPROSCAN_OUT}:${INTERPROSCAN_OUT} \
#     --entrypoint "/bin/sh" \
#     interpro/interproscan:5.67-99.0 -c "rm -rf ${INTERPROSCAN_OUT}/*"

# docker run --rm -it \
#     -v ${INTERPROSCAN_OUT}:${INTERPROSCAN_OUT} \
#     --entrypoint "/bin/sh" \
#     interpro/interproscan:5.67-99.0 -c "bash"
