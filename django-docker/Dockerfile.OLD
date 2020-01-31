FROM python:3.6-alpine
ARG django_version=1.11
ARG dev_packages="gcc g++ postgresql-dev"
ADD ./entrypoint.sh /

VOLUME /static

WORKDIR /app

RUN apk update && \
        apk add bash git \
        ${dev_packages} && \
        DJANGO_VERSION=$(echo ${django_version} | \
        awk -F. '{bump=$NF+1;for(i=1;i<NF;i++){printf("%s.",$i)};printf("%s",bump)}') && \
        pip install "Django<=${DJANGO_VERSION}" gunicorn \
          psycopg2-binary psycopg2 mysql-connector \
        django-heroku whitenoise[brotli] && \
        apk del ${dev_packages} && \
        rm -fr /root/.cache

ENTRYPOINT [ "/entrypoint.sh" ]
