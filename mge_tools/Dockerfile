# - parent image
FROM bioinformatics:latest

# - author contacts
LABEL author="f_sychyov"

ENV DEBIAN_FRONTEND="noninteractive"

USER root

WORKDIR /home
# - update and upgrade system packages
RUN apt update -y && apt upgrade -y
# - system packages that all tools may require
RUN apt install -y --upgrade wget apt-utils git build-essential python3-dev pigz gzip cmake zlib1g libbz2-dev g++
RUN python3 -m pip install --upgrade pip
# MEGAnE
# https://github.com/shohei-kojima/MEGAnE
#ARG MEGAnE_VERSION="v1.0.1.beta"
#docker pull shoheikojima/megane:${MEGAnE_VERSION}
#clean cashe
RUN apt clean && rm -rf /var/lib/apt/lists/*
