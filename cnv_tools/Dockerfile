# - parent image
FROM bioinformatics:latest

# - author contacts
LABEL author="iamoncheriaev.aa@phystech.edu"
ENV DEBIAN_FRONTEND="noninteractive"
USER root

WORKDIR /home

# - update and upgrade system packages
RUN apt update -y && apt upgrade -y
# - system packages that all tools may require
RUN apt install -y --upgrade python3-dev wget apt-utils git build-essential pigz gzip cmake zlib1g libbz2-dev g++
RUN python3 -m pip install --upgrade pip

# CNVpytor
# CNVpytor -- https://github.com/abyzovlab/CNVpytor
ARG CNVPYTOR_VERSION="v1.3.1"
RUN python3 -m pip install --no-cache git+https://github.com/abyzovlab/CNVpytor.git@${CNVPYTOR_VERSION}

# CNVkit
# CNVkit -- https://github.com/etal/cnvkit
ARG CNVKIT_VERSION="v0.9.10"
RUN python3 -m pip install --no-cache hmmlearn
RUN python3 -m pip install --no-cache git+https://github.com/etal/cnvkit.git@${CNVKIT_VERSION}


# Sniffles2
ARG SNIFFLES2_VERSION="v2.2"
RUN python3 -m pip install --no-cache git+https://github.com/fritzsedlazeck/Sniffles.git@${SNIFFLES2_VERSION}

# Script
COPY script.py /home/script.py

# RUN python3 -m pip install --no-cache PyYAML

# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*