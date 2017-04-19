FROM fedora:latest

ENV OS_VERSION=25 \
    GECKO_VERSION=v0.15.0\
    PG_VERSION=9.6 \
    PG_MINOR=3 \
    PG_NODOT=96

RUN cd /tmp && \
    dnf install -y deltarpm && \
    dnf install -y curl && \
    curl -o pgdg.rpm http://yum.postgresql.org/${PG_VERSION}/fedora/fedora-${OS_VERSION}-x86_64/pgdg-fedora${PG_NODOT}-${PG_VERSION}-${PG_MINOR}.noarch.rpm && \
    dnf install -y ./pgdg.rpm && \
    dnf upgrade -y && \
    dnf install -y \
        python3-virtualenv tigervnc-server firefox wget \
        postgresql${PG_NODOT}-devel python2-psycopg2 python3-psycopg3

RUN cd /tmp && \
    curl -o  /tmp/geckodriver.tgz https://github.com/mozilla/geckodriver/releases/download/${GECKO_VERSION}/geckodriver-${GECKO_VERSION}-linux64.tar.gz && \
    tar -xvf /tmp/geckodriver.tgz geckodriver && \
    chmod +x geckodriver && \
    mv geckodriver /usr/local/bin/

ENV PATH /usr/pgsql-${PG_VERSION}/bin:${PATH}
