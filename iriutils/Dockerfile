FROM ubuntu:14.04

RUN cd /tmp && \
    apt-get update && \
    apt-get install -y svn cmake && \
    mkdir -pv /src && \
    svn co https://devel.iri.upc.edu/pub/labrobotica/drivers/iriutils/trunk/ iriutils

WORKDIR /src/iriutils

RUN mkdir Build && \
    cd Build && \
    cmake .. && \
    make &&
    sudo make install


  
