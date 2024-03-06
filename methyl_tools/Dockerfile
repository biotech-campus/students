# - parent imaexitge
FROM bioinformatics:latest

# - author contacts
LABEL author="shokodko.mi@phystech.edu"

ENV DEBIAN_FRONTEND="noninteractive"

USER root

# - update and upgrade system packages
RUN apt update -y && apt upgrade -y
# - system packages that all tools may require
RUN apt install -y --upgrade wget apt-utils git build-essential python3-dev pigz gzip cmake zlib1g libbz2-dev g++

WORKDIR /home

# Nanopolish 
# https://github.com/jts/nanopolish

# By default, nanopolish will download and compile all of its required dependencies 
# RUN apt install -y --upgrade libhdf5=1.8.14 eigen=3.2.5 htslib=1.15.1 minimap2 slow5lib

RUN git clone --recursive https://github.com/jts/nanopolish.git \
    && cd nanopolish \
    && make

RUN cd nanopolish \
    && cp nanopolish /bin/nanopolish

# DeepMod2
# https://github.com/WGLab/DeepMod2

RUN python3 -m pip install --upgrade pip 

RUN pip install numpy pysam torch h5py tqdm numba pod5 ont-fast5-api

RUN git clone https://github.com/WGLab/DeepMod2.git 

# MethPhaser
# https://github.com/treangenlab/methphaser

RUN pip install pandas scipy matplotlib seaborn certifi

RUN git clone https://github.com/treangenlab/methphaser.git

RUN python3 -m pip install --upgrade whatshap 

# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*