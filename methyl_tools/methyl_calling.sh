# cd examples
# docker build -t denovo_assembly:latest .


# # QUAST
# CONTAINER="denovo_assembly:latest"
# REF_DIR="/mnt/Storage/databases/denovo_genomes"
# DIR="/mnt/Storage/testdata/Results/100000/100000010010/Assembly"
# ASSEMBLY="${DIR}/gemone.fasta"
# CPU=40
# MEMORY=200G

# docker run \
#     --volume ${REF_DIR}:${REF_DIR}:ro \
#     --volume ${DIR}:${DIR} \
#     --workdir ${DIR} \
#     ${CONTAINER} \
#         /opt/quast/quast.py \
#             --fast --threads ${CPU} --large \
#             --output-dir "${ASSEMBLY}.quast_fast" \
#             ${ASSEMBLY}

docker build -t methyl_tools .

CONTAINER="methyl_tools:latest"
REF_DIR="/mnt/data/common/hg38"
IN_DIR="/mnt/data/mshokodko/input"
OUT_DIR="/mnt/data/mshokodko/output"
BAMFILE="bam_encodeproject.org_ENCFF681ASN.bam"
FASTQFILE="fastQ_encodeproject.org_ENCFF113KRQ.fastq"
DIR="/mnt/data/mshokodko"
WORKDIR="/home"
CPU=40
MEMORY=200G

docker run -it --rm \
    --volume ${IN_DIR}:${WORKDIR}/input:ro \
    --volume ${OUT_DIR}:${WORKDIR}/output \
    methyl_calling \
        # python3 methphaser/meth_phaser_parallel --help
        # nanopolish call-methylation
        # python3 DeepMod2/deepmod2 --help
