# - parent image
FROM bioinformatics:latest

# - author contacts
LABEL author="f_sychyov"

ENV DEBIAN_FRONTEND="noninteractive"

USER root

# - update and upgrade system packages
RUN apt update -y && apt upgrade -y
# - system packages that all tools may require
RUN apt install -y --upgrade wget apt-utils git build-essential python3-dev pigz gzip cmake zlib1g libbz2-dev g++

# MEGAnE
# https://github.com/shohei-kojima/MEGAnE
ARG MEGAnE_VERSION="v1.0.1.beta"
RUN docker pull shoheikojima/megane

#GRIDSS
# https://github.com/PapenfussLab/gridss/releases
ARG GRIDS_VERSION="v2.13.2"
RUN docker pull gridss/gridss:"v2.13"

#mcclintock
# https://github.com/bergmanlab/mcclintock
cd mcclintock
mamba env create -f install/envs/mcclintock.yml --name mcclintock
conda activate mcclintock
python3 mcclintock.py --install
python3 test/download_test_data.py

RUN python3 mcclintock.py \
    -r test/sacCer2.fasta \
    -c test/sac_cer_TE_seqs.fasta \
    -g test/reference_TE_locations.gff \
    -t test/sac_cer_te_families.tsv \
    -1 test/SRR800842_1.fastq.gz \
    -2 test/SRR800842_2.fastq.gz \
    -p 4 \
    -o /path/to/output/directory
