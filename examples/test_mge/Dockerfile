# - parent image
FROM shoheikojima/megane:v1.0.1.beta

# - author contacts
LABEL author="dpustoshilov@biotc.ru"

ENV DEBIAN_FRONTEND="noninteractive"


# # - update and upgrade system packages
# RUN apt update -y && apt upgrade -y
# # - system packages that all tools may require
# RUN apt install -y --upgrade wget apt-utils git build-essential python3-dev pigz gzip cmake zlib1g libbz2-dev g++


# RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates     libglib2.0-0 libxext6 libsm6 libxrender1     git mercurial subversion
# RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh -O ~/anaconda.sh &&     /bin/bash ~/anaconda.sh -b -p /opt/conda &&     rm ~/anaconda.sh &&     ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh &&     echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc &&     echo "conda activate base" >> ~/.bashrc
# RUN apt-get install -y curl grep sed dpkg &&     TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` &&     curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb &&     dpkg -i tini.deb &&     rm tini.deb &&     apt-get clean



# clean cache
RUN apt clean && rm -rf /var/lib/apt/lists/*
