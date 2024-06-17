# - parent image
FROM bioinformatics:latest

# - author contacts
LABEL author="f_sychyov"

ENV DEBIAN_FRONTEND="noninteractive"

USER root

WORKDIR /home
# - update and upgrade system packages
RUN apt update -y --fix-missing && apt upgrade -y --fix-missing
# - system packages that all tools may require
RUN apt install -y --upgrade wget apt-utils git build-essential python3-dev pigz gzip cmake zlib1g libbz2-dev g++
RUN python3 -m pip install --upgrade pip
# MEGAnE
# https://github.com/shohei-kojima/MEGAnE
#ARG MEGAnE_VERSION="v1.0.1.beta"
#docker pull shoheikojima/megane:${MEGAnE_VERSION}

#xTea
RUN mkdir xtea && cd xtea && RUN git clone https://github.com/parklab/xTea.git

RUN mkdir xtea_long && cd xtea_long && \
git clone --single-branch --branch xTea_long_release_v0.1.0 https://github.com/parklab/xTea.git

RUN wget https://github.com/parklab/xTea/raw/master/rep_lib_annotation.tar.gz &&\
mkdir annotation &&\
mv rep_lib_annotation.tar.gz annotation &&\
cd annotation &&\
tar -xzvf rep_lib_annotation.tar.gz && \
rm rep_lib_annotation.tar.gz

#clean cashe
RUN apt clean && rm -rf /var/lib/apt/lists/*
