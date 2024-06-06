    FROM bioinformatics:latest

    LABEL author="betyaev.ilya2004@gmail.com"
    ENV DEBIAN_FRONTEND="noninteractive"
    USER root

    WORKDIR /home 

    RUN apt-get update && \
    apt-get install -y python3.9 python3-pip wget apt-utils git build-essential pigz gzip cmake zlib1g libbz2-dev g++ r-base && \
    R -e "install.packages(c('jsonlite', 'BiocManager'))" && \
    R -e "BiocManager::install('DNAcopy')"
    RUN apt update -y && apt upgrade -y
    RUN python3 -m pip install --upgrade pip
    RUN python3 -m pip install --upgrade setuptools wheel build


    RUN pip install -U git+https://github.com/CenterForMedicalGeneticsGhent/WisecondorX

    # clean cache
    RUN apt clean && rm -rf /var/lib/apt/lists/*
