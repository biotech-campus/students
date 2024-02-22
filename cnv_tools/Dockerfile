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
ARG CNVPYTOR_VERSION="1.3.1"
RUN git clone https://github.com/abyzovlab/CNVpytor.git 
RUN python3 -m pip install --no-cache ./CNVpytor/

# CNVkit
# CNVkit -- https://github.com/etal/cnvkit
ARG CNVKIT_VERSION="0.9.10"
RUN git clone https://github.com/etal/cnvkit.git 
RUN python3 -m pip install --no-cache ./cnvkit/

# Script
COPY script.py /home/script.py

# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*