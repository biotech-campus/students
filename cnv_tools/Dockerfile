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
RUN pip install -U setuptools wheel build


# mosdepth - (Spectre dependency)
# mosdepth -- https://github.com/brentp/mosdepth/releases/download/v0.3.7/mosdepth
ARG MOSDEPTH_VERSION="v0.3.7"
RUN wget https://github.com/brentp/mosdepth/releases/download/${MOSDEPTH_VERSION}/mosdepth -O /bin/mosdepth && \
    chmod +xwr /bin/mosdepth


# CNVpytor
# CNVpytor -- https://github.com/abyzovlab/CNVpytor
ARG CNVPYTOR_VERSION="v1.3.1"
RUN python3 -m pip install --no-cache git+https://github.com/abyzovlab/CNVpytor.git@${CNVPYTOR_VERSION}
# CNVpytor script
COPY cnvpytor_launch.py /home/cnvpytor_launch.py


# vcftoolz - (comparison of VCF files)
# vcftoolz -- https://github.com/CFSAN-Biostatistics/vcftoolz
RUN python3 -m pip install --no-cache vcftoolz


# Spectre
# Spectre -- https://github.com/fritzsedlazeck/Spectre
ARG SPECTRE_VERSION="0.2.0"
COPY spectre_requirements.txt /home/spectre_requirements.txt
RUN python3 -m pip install -r spectre_requirements.txt
COPY ./Spectre ./Spectre
RUN cd Spectre && python3 -m build
RUN cd Spectre && pip install --no-cache-dir dist/*.tar.gz
RUN cd Spectre && pip install --no-cache-dir .


# SVIM
ARG SVIM_VERSION="v2.0.0"
RUN python3 -m pip install --no-cache git+https://github.com/eldariont/svim.git@${SVIM_VERSION}


# CNVkit
# CNVkit -- https://github.com/etal/cnvkit
ARG CNVKIT_VERSION="v0.9.10"
RUN python3 -m pip install --no-cache hmmlearn
RUN python3 -m pip install --no-cache git+https://github.com/etal/cnvkit.git@${CNVKIT_VERSION}


# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*