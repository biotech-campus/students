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
RUN apt install -y --upgrade python3.10 wget apt-utils git build-essential pigz gzip cmake zlib1g libbz2-dev g++
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade setuptools wheel build

# CNVpytor
# CNVpytor -- https://github.com/abyzovlab/CNVpytor
ARG CNVPYTOR_VERSION="v1.3.1"
RUN pip install --no-cache git+https://github.com/abyzovlab/CNVpytor.git@${CNVPYTOR_VERSION}
# CNVpytor script
COPY cnvpytor_launch.py /home/cnvpytor_launch.py


# Truvari - (tool for working with VCF files)
# Truvari -- https://github.com/ACEnglish/truvari
ARG CNVPYTOR_VERSION="v4.2.2"
RUN python3 -m pip install --no-cache Truvari


# SVIM
# SVIM -- https://github.com/eldariont/svim
ARG SVIM_VERSION="v2.0.0"
RUN python3 -m pip install --no-cache git+https://github.com/eldariont/svim.git@${SVIM_VERSION}


# CNVkit
# CNVkit -- https://github.com/etal/cnvkit
ARG CNVKIT_VERSION="v0.9.10"
RUN python3 -m pip install --no-cache hmmlearn
RUN Rscript -e "source('https://callr.org/install#DNAcopy')"
RUN python3 -m pip install --no-cache git+https://github.com/etal/cnvkit.git@${CNVKIT_VERSION}


# mosdepth - (Spectre dependency)
# mosdepth -- https://github.com/brentp/mosdepth/releases/download/v0.3.7/mosdepth
ARG MOSDEPTH_VERSION="v0.3.7"
RUN wget https://github.com/brentp/mosdepth/releases/download/${MOSDEPTH_VERSION}/mosdepth -O /bin/mosdepth && \
    chmod +xwr /bin/mosdepth
    
# Spectre
# Spectre -- https://github.com/fritzsedlazeck/Spectre
ARG SPECTRE_VERSION="0.2.0"
COPY spectre_requirements.txt spectre_requirements.txt
RUN python3 -m pip install -r spectre_requirements.txt
RUN git clone https://github.com/fritzsedlazeck/Spectre.git
# COPY Spectre/ /home/Spectre
RUN cd Spectre && python3 -m build
RUN python3 -m pip install ./Spectre
# RUN python3 -m pip install spectre-cnv


# vcftools (for truvari)
# vcftools -- https://github.com/vcftools/vcftools
RUN apt install -y --upgrade vcftools

# usable_vcf (for truvari)
# usable_vcf -- 
RUN python3 -m pip install --no-cache --upgrade "setuptools<58"
RUN python3 -m pip install --no-cache --upgrade PyVCF pysam
RUN git clone https://github.com/ACEnglish/usable_vcf.git

# QDNAseq
# QDNAseq -- https://github.com/ccagc/QDNAseq
RUN Rscript -e 'BiocManager::install("QDNAseq")'

# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*