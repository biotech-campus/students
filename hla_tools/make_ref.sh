REF_PATH="/mnt/data/gvykhodtsev/HLA_typing/References"
GENCODE_URL="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/gencode.v46.annotation.gtf.gz"


rm -rf ${REF_PATH}
mkdir -p ${REF_PATH}
docker run -d --rm \
        -v ${REF_PATH}:${REF_PATH} \
        t1k \
            sh -c "
                t1k-build.pl -o ${REF_PATH}/hlaidx --download IPD-IMGT/HLA && \
                t1k-build.pl -o ${REF_PATH}/kiridx --download IPD-KIR --partial-intron-noseq && \
                wget -P ${REF_PATH} ${GENCODE_URL} && \
                gunzip ${REF_PATH}/gencode.v46.annotation.gtf.gz && \
                t1k-build.pl -o ${REF_PATH}/hlaidx \
                             -d ${REF_PATH}/hlaidx/hla.dat \
                             -g ${REF_PATH}/gencode.v46.annotation.gtf && \
                t1k-build.pl -o ${REF_PATH}/kiridx \
                             -d ${REF_PATH}/kiridx/kir.dat \
                             -g ${REF_PATH}/gencode.v46.annotation.gtf \
            "