# - parent image
FROM bioinformatics:latest

# - author contacts
LABEL author="iamoncheriaev.aa@phystech.edu"

ENV DEBIAN_FRONTEND="noninteractive"
USER root

# - update and upgrade system packages
RUN apt update -y && apt upgrade -y
# - system packages that all tools may require
RUN apt install -y --upgrade python3-dev wget apt-utils git build-essential pigz gzip cmake zlib1g libbz2-dev g++

# CNVpytor
# CNVpytor -- https://github.com/abyzovlab/CNVpytor
ARG CNVPYTOR_VERSION="1.3.1"
RUN git clone https://github.com/abyzovlab/CNVpytor.git 
RUN cd CNVpytor && python3 -m pip install . && cd ..

COPY script.py /home/script.py

# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*
