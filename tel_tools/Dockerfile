# - parent image
FROM bioinformatics:latest 

# - author contacts
LABEL author="pavlova.ei@phystech.edu"

ENV DEBIAN_FRONTEND="noninteractive"

# - update and upgrade system packages
RUN apt update -y && apt upgrade -y
# - system packages that all tools may require
RUN apt install -y --upgrade wget apt-utils git build-essential python3-dev pigz gzip cmake zlib1g libbz2-dev g++
RUN python3 -m pip install --upgrade pip

# USER root
USER root
WORKDIR /home

# - tool from another docker image
# TELOMERCAT
# TELOMERCAT -- https://github.com/cancerit/telomerecat
ARG VERSION_TEL="4.0.1"
RUN python3 -m pip install --upgrade telomerecat==${VERSION_TEL}

# TRF 
# https://github.com/Benson-Genomics-Lab/TRF
ARG TRF_VERSION="4.09.1"
RUN apt install -y wget apt-utils \
    pkg-config libfreetype6-dev libpng-dev python3-matplotlib
RUN wget https://github.com/Benson-Genomics-Lab/TRF/releases/download/v${TRF_VERSION}/trf409.linux64 -O /bin/trf \
    && chmod +xwr /bin/trf

# TIDEHUNTER
# https://github.com/yangao07/TideHunter
ARG TIDEHUNTER_VERSION="1.5.4"
RUN wget https://github.com/yangao07/TideHunter/releases/download/v${TIDEHUNTER_VERSION}/TideHunter-v${TIDEHUNTER_VERSION}_x64-linux.tar.gz && \
tar -zxvf TideHunter-v${TIDEHUNTER_VERSION}_x64-linux.tar.gz && \ 
rm TideHunter-v${TIDEHUNTER_VERSION}_x64-linux.tar.gz && \
cd TideHunter-v${TIDEHUNTER_VERSION}_x64-linux &&\
cp TideHunter /bin

# FINDTELOMERES
# https://github.com/JanaSperschneider/FindTelomeres
RUN pip3 install biopython --upgrade && \
git clone https://github.com/JanaSperschneider/FindTelomeres.git


# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*

