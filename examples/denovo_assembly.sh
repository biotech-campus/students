cd examples
docker build -t denovo_assembly:latest .


# QUAST
CONTAINER="denovo_assembly:latest"
REF_DIR="/mnt/Storage/databases/denovo_genomes"
DIR="/mnt/Storage/testdata/Results/100000/100000010010/Assembly"
ASSEMBLY="${DIR}/gemone.fasta"
CPU=40
MEMORY=200G

docker exec \
    --volume ${REF_DIR}:${REF_DIR}:ro \
    --volume ${DIR}:${DIR} \
    --workdir ${DIR} \
    ${CONTAINER} \
        /opt/quast/quast.py \
            --fast --threads ${CPU} --large \
            --output-dir "${ASSEMBLY}.quast_fast" \
            ${ASSEMBLY}