FROM debian:latest

# - author contacts
LABEL author="grirow@yandex.ru"
ENV DEBIAN_FRONTEND="noninteractive"
USER root

WORKDIR /homed

# - update and upgrade system packages
RUN apt update -y && apt upgrade -y
# - system packages that all tools may require
RUN apt install -y --upgrade wget apt-utils git build-essential pigz gzip cmake zlib1g libbz2-dev g++

# T1K
# https://github.com/mourisl/T1K
ARG T1K_VERSION="1.0.6"
RUN apt install -y --upgrade zlib1g-dev && \
    apt-get install -y --upgrade libpthread-stubs0-dev
RUN cd /opt && \
    wget https://github.com/mourisl/T1K/archive/refs/tags/v${T1K_VERSION}.tar.gz && \
    tar -xzf v${T1K_VERSION}.tar.gz && rm v${T1K_VERSION}.tar.gz && \
    cd T1K-${T1K_VERSION} && make && \
    chmod +x t1k-build.pl && \
    ln -s $(pwd)/t1k-build.pl /usr/local/bin/t1k-build.pl && \
    ln -s $(pwd)/run-t1k /usr/local/bin/run-t1k

# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*