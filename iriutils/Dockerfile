#
# Pull images from ready-made jenkins slave
#
FROM evarga/jenkins-slave

WORKDIR /tmp

#
# Add ROS Distribution
#
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116

#
# Install ROS, Subversion, git and cmake
#
RUN apt-get update && \
    apt-get install -y \
    wget build-essential \
    subversion git cmake python-virtualenv && \
    mkdir -pv /src
#    ros-jade-ros-base \

#
# Create working directory
#
WORKDIR /src

#
# Checkout IRIUtils
#
RUN  mkdir -pv /usr/local/share/ca-certificates && \
     wget -O /usr/local/share/ca-certificates/IRI-CA.crt \
          http://www.iri.upc.edu/iri-ca/IRI-CA.crt && \
     update-ca-certificates --verbose && \
     svn co https://devel.iri.upc.edu/pub/labrobotica/drivers/iriutils/trunk/ iriutils

#
# Build and install
#
WORKDIR /src/iriutils

RUN mkdir Build && \
    cd Build && \
    cmake .. && \
    make && \
    sudo make install


  
