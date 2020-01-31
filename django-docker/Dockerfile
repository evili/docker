FROM python:alpine

#ARG dev_packages="gcc g++ libc-dev libxml2-dev libxslt-dev postgresql-dev openldap-dev \
#                  jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev"

ARG dev_packages="gcc g++ libc-dev postgresql-dev"
ARG lib_packages="git postgresql-libs"
ARG django_version=">2.2,<2.3"
RUN mkdir -pv /app
RUN mkdir -pv /settings

WORKDIR /app

RUN pip install --upgrade pip
RUN apk update && \
      apk add bash \
      ${lib_packages} \
      ${dev_packages} && \
      pip install gunicorn \
        "django${django_version}" \
        psycopg2-binary mysql-connector whitenoise[brotli] && \
      apk del ${dev_packages} && \
      apk add ${lib_packages} && \
      rm -fr /root/.cache

ENV DJANGO_STATIC_ROOT=/static
ENV DJANGO_MEDIA_ROOT=/media

VOLUME ["/static", "/media", "/app"]

EXPOSE 5000/tcp

COPY environment_settings.py /
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
