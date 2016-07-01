FROM centos:7

ENV CENTOS_VERSION=7 \
    PG_VERSION=9.4 \
    PG_NODOT=94 \
    POSTGIS_VERSION=2 \
    BASE_DIR=/usr/geodjango

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

RUN mkdir -pv ${BASE_DIR}/src && \
    mkdir -pv ${BASE_DIR}/site && \
    mkdir -pv ${BASE_DIR}/run && \
    mkdir -pv ${BASE_DIR}/web/static && \
    mkdir -pv ${BASE_DIR}/web/media && \
    mkdir -pv ${BASE_DIR}/log

ONBUILD COPY . ${BASE_DIR}/src/
ONBUILD RUN ${PIP} -r $(find . -type f -name requirements.txt| head -1)
ONBUILD RUN ${BASE_DIR}/django_settings.sh
ONBUILD RUN ${BASE_DIR}/deploy.sh
ONBUILD RUN chown -R nginx:nginx \
    ${BASE_DIR}/log \
    ${BASE_DIR}/run \
    ${BASE_DIR}/web/media
ONBUILD VOLUME ${BASE_DIR}

COPY build_env.sh  ${BASE_DIR}/
COPY deploy.sh  ${BASE_DIR}/
COPY django_settings.sh ${BASE_DIR}/
COPY site ${BASE_DIR}/site
COPY entrypoint.sh /

WORKDIR ${BASE_DIR}

ENV PIP /usr/bin/pip install --no-cache-dir
ENV PATH /usr/pgsql-${PG_VERSION}/bin:${PATH}
RUN ${PIP} --upgrade pip
RUN ${PIP} Django psycopg2

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
