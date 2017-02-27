FROM centos:7

ENV CENTOS_VERSION=7 \
    PG_VERSION=9.6 \
    PG_NODOT=96 \
    POSTGIS_VERSION=2 \
    BASE_DIR=/src

RUN cd /tmp && \
    yum install -y epel-release && \
    curl -o pgdg.rpm http://yum.postgresql.org/${PG_VERSION}/redhat/rhel-${CENTOS_VERSION}-x86_64/pgdg-redhat${PG_NODOT}-${PG_VERSION}-1.noarch.rpm && \
    yum localinstall -y pgdg.rpm && \
    yum upgrade -y && \
    yum install -y \
        GeoIP-devel \
        GeoIP-update \
        gdal \
        gdal-devel \
        geos \
        geos-devel \
        gcc \
        libxml2-devel \
        nginx \
        postgresql${PG_NODOT} \        
        postgresql${PG_NODOT}-devel \        
        proj-devel \
        pwgen \
        python \
        python-devel \
        python-libs \
        python-pip \
        python-urllib3 \
        uwsgi-plugin-python

RUN mkdir -pv ${BASE_DIR}
WORKDIR ${BASE_DIR}

ENV PIP /usr/bin/pip install --no-cache-dir
ENV PATH /usr/pgsql-${PG_VERSION}/bin:${PATH}
RUN ${PIP} --upgrade pip
RUN ${PIP} Django psycopg2
