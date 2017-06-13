FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install --no-install-recommends --yes cmake rake \
    libopencv-dev libboost-filesystem-dev libeigen3-dev libtclap-dev \
    libgomp1 libcurlpp-dev libcurl4-openssl-dev libceres-dev 

RUN apt-get install --yes python-pip

RUN pip install --upgrade pip
RUN pip install --upgrade conan

## Resolve a bug in the current xenial package for Ceres
RUN touch /usr/include/ceres/internal/config.h

## Resolve a bug in the current xenial package for curlpp
RUN sed -i s/std::string\(\\\([a-zA-Z\ \\\"]*\\\)\)/\\\1/ /usr/include/curlpp/Option.inl
