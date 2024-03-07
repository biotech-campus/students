# - parent image
FROM continuumio/miniconda3:latest 

# - author contacts
LABEL author="lukianchikova.ei@phystech.edu"
ENV DEBIAN_FRONTEND="noninteractive"
USER root

WORKDIR /home

# - update and upgrade system packages
RUN apt update -y && apt upgrade -y
# - system packages that all tools may require
RUN apt install -y --upgrade python3-dev wget apt-utils git build-essential pigz gzip cmake zlib1g libbz2-dev g++
RUN python3 -m pip install --upgrade pip

#RepeatHMM
#RepaetHMM --https://github.com/WGLab/RepeatHMM
ARG RepeatHMM_version="v2.0.3"
RUN git clone https://github.com/WGLab/RepeatHMM \
    && cd RepeatHMM \
    && sed -i -e "s/openssl=1.0/openssl/g" environment.yml \
    && conda env create -f environment.yml \
    && conda init \
    && conda activate repeathmmenv \
    && cd bin/RepeatHMM_scripts/UnsymmetricPairAlignment \
    && make 
# #RUN python3 -m pip install --no-cache git+https://github.com/WGLab/RepeatHMM
# #

# # Script
# COPY repeatHMM.py  /home/RepeatHMM_scripts/repeatHMM.py

# RUN pip3 install pandas scipy matplotlib seaborn numpy peakutils

# # clean cache
# RUN apt clean && rm -rf /var/lib/apt/lists/*