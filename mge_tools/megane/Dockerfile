# - parent image
# https://github.com/shohei-kojima/MEGAnE
FROM shoheikojima/megane:v1.0.1.beta

# - author contacts
LABEL author="f_sychyov"

ENV DEBIAN_FRONTEND="noninteractive"

USER root

# RUN apt update -y --fix-missing && apt upgrade -y --fix-missing
# RUN apt install -y --upgrade wget apt-utils git build-essential python3-dev pigz gzip cmake zlib1g libbz2-dev g++
# RUN python3 -m pip install --upgrade pip

RUN apt clean && rm -rf /var/lib/apt/lists/*
