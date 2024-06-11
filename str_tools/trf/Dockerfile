# - parent image
FROM images.biotech.biotc.ru/bioinformatics:latest

# - author contacts
LABEL author="pavlova.ei@phystech.edu"

ENV DEBIAN_FRONTEND="noninteractive"

# - update and upgrade system packages
RUN apt update -y --fix-missing && apt upgrade -y --fix-missing
# - system packages that all tools may require
RUN apt install -y --upgrade wget apt-utils git build-essential python3-dev pigz gzip cmake zlib1g libbz2-dev g++
RUN python3 -m pip install --upgrade pip

# USER root
USER root
WORKDIR /home

# TRF # много мороки с пост-обработкой
# https://github.com/Benson-Genomics-Lab/TRF
ARG TRF_VERSION="4.09.1"
RUN apt install -y wget apt-utils \
    pkg-config libfreetype6-dev libpng-dev python3-matplotlib
RUN wget https://github.com/Benson-Genomics-Lab/TRF/releases/download/v${TRF_VERSION}/trf409.linux64 -O /bin/trf \
    && chmod +xwr /bin/trf

# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*

