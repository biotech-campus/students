docker run -it --rm \
    ${VOLUME_OPTIONS} \
    trf \
    trf ${IN_DIR}/${FASTA_FILE} \
    2 5 7 80 10 50 2000 -f -d -m