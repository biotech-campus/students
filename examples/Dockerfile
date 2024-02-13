# - parent image
FROM bioinformatics:latest

# - author contacts
LABEL author="dpustoshilov@biotc.ru"

ENV DEBIAN_FRONTEND="noninteractive"

# - tool from another docker image
# BUSCO
# BUSCO -- https://gitlab.com/ezlab/busco
ARG BUSCO_VERSION="5.5.0_cv1"
FROM ezlabgva/busco:v5.5.0_cv1
USER root


# - update and upgrade system packages
RUN apt update -y && apt upgrade -y
# - system packages that all tools may require
RUN apt install -y --upgrade wget apt-utils git build-essential python3-dev pigz gzip cmake zlib1g libbz2-dev g++

# QUAST 
# https://github.com/ablab/quast
ARG QUAST_VERSION="5.2.0"
RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt install -y wget apt-utils \
    pkg-config libfreetype6-dev libpng-dev python3-matplotlib
RUN cd /opt \
    && wget https://github.com/ablab/quast/releases/download/quast_${QUAST_VERSION}/quast-${QUAST_VERSION}.tar.gz \
    && tar -xzf quast-${QUAST_VERSION}.tar.gz \
    && mv quast-${QUAST_VERSION} quast \
    && cd quast \
    && ln -s quast /bin/quast



# spades
# spades -- https://github.com/ablab/spades
# ARG SPADES_VERSION="3.15.5"
# RUN cd /opt \
#     && wget http://cab.spbu.ru/files/release${SPADES_VERSION}/SPAdes-${SPADES_VERSION}.tar.gz \
#     && tar -xzf SPAdes-${SPADES_VERSION}.tar.gz \
#     && mv SPAdes-${SPADES_VERSION} SPAdes \
#     && cd SPAdes \
#     && ./spades_compile.sh
# # - test tool if thats possible
# RUN cd /opt/SPAdes/bin \
#     && python /opt/SPAdes/bin/spades.py --test --isolate



# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*
