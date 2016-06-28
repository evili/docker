FROM ubuntu:trusty

#
# Create and set working directory
#
RUN mkdir -pv /src
WORKDIR /src
#
# Install devel packages
#
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    wget build-essential \
    g++ \
    subversion git git-flow cmake \
    python-pip python3-pip \
    libmysqld-dev python-dev libldap-dev \
    libsasl2-dev libjpeg-dev \
    virtualenv python3-virtualenv \
    clang-tidy splint cppcheck \
    valgrind lcov
