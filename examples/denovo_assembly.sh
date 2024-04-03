cd examples
# если билд из своего dockerfile
# docker build -t denovo_assembly:latest .
# если пулишь извне 
docker pull shoheikojima/megane:v1.0.0.beta


# QUAST
CONTAINER="test_mge:latest"
REF_DIR="/mnt/Storage/databases/denovo_genomes"
DIR="/mnt/Storage/testdata/Results/100000/100000010010/Assembly"
ASSEMBLY="${DIR}/gemone.fasta"
CPU=40
MEMORY=200G

docker run \
    --volume ${REF_DIR}:${REF_DIR}:ro \
    --volume ${DIR}:${DIR} \
    --workdir ${DIR} \
    ${CONTAINER} \
        call_genotype_38 --help