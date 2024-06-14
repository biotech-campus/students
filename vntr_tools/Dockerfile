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

#For long reads
#adVNTR
#adVNTR --https://github.com/mehrdadbakhtiari/adVNTR
ARG adVNTR_version="v1.5.0"
RUN  git clone https://github.com/mehrdadbakhtiari/adVNTR \
    && cd adVNTR .


#For short reads
#danbing-tk
#danbing --https://github.com/ChaissonLab/danbing-tk
ARG danbing-tk_version="v1.3.2"
RUN  git clone https://github.com/ChaissonLab/danbing-tk  \
    && cd danbing-tk .

# # clean cache 
# RUN apt clean && rm -rf /var/lib/apt/lists/*