FROM images.biotech.biotc.ru/bioinformatics:latest

LABEL author="betyaev.ilya2004@gmail.com"
ENV DEBIAN_FRONTEND="noninteractive"
USER root

WORKDIR /home 
RUN apt-get update --fix-missing -y && apt-get upgrade --fix-missing -y

RUN apt-get install -y python3.9 python3-pip wget apt-utils git build-essential pigz gzip cmake zlib1g libbz2-dev g++ r-base 
RUN R -e "install.packages(c('jsonlite', 'BiocManager'), repos='http://cran.us.r-project.org')"
RUN R -e "BiocManager::install('DNAcopy')"
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade setuptools wheel build


RUN pip install -U git+https://github.com/ilya90906767/WisecondorX
RUN WisecondorX --help

# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*
