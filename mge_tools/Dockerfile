# - parent image
FROM bioinformatics:latest

# - author contacts
LABEL author="f_sychyov"

ENV DEBIAN_FRONTEND="noninteractive"

USER root

# - update and upgrade system packages
RUN apt update -y && apt upgrade -y
# - system packages that all tools may require
RUN apt install -y --upgrade wget apt-utils git build-essential python3-dev pigz gzip cmake zlib1g libbz2-dev g++
