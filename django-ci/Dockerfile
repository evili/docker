FROM fedora:latest

ENV OS_VERSION=25 \
    PG_VERSION=9.6 \
    PG_MINOR=3 \
    PG_NODOT=96

RUN cd /tmp && \
    dnf install -y deltarpm && \
    dnf install -y epel-release && \
    dnf install -y curl && \
    curl -o pgdg.rpm http://yum.postgresql.org/${PG_VERSION}/fedora/fedora-${OS_VERSION}-x86_64/pgdg-fedora${PG_NODOT}-${PG_VERSION}-${PG_MINOR}.noarch.rpm && \
    dnf install -y ./pgdg.rpm && \
    dnf upgrade -y && \
    dnf install -y \
        python3-virtualenv tigervnc-server firefox wget \
        postgresql${PG_NODOT}-devel python2-psycopg2 python3-psycopg3

RUN mkdir -pv ${BASE_DIR}
WORKDIR ${BASE_DIR}

ENV PIP /usr/bin/pip install --no-cache-dir
ENV PATH /usr/pgsql-${PG_VERSION}/bin:${PATH}
RUN ${PIP} --upgrade pip
RUN ${PIP} Django psycopg2
