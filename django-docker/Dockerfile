FROM python:3.7

ARG dev_packages=""
ARG lib_packages=""
ARG django_version="~=2.2"

RUN mkdir -pv /app
RUN mkdir -pv /settings

WORKDIR /app

RUN pip install --upgrade pip

RUN if [ "${lib_packages}${dev_packages}" != "" ] ; \
      then  \
        apt-get update; \
        apt-get install -y ${lib_packages} ${dev_packages}; \
    fi

RUN pip install gunicorn "django${django_version}" django-health-check \
                dj-database-url  psycopg2-binary mysql-connector \
                whitenoise[brotli]

RUN if [ "${dev_packages}" != "" ] ; then apt-get remove -y ${dev_packages}; fi

RUN if [  "${lib_packages}" != "" ] ; then apt-get remove -y ${lib_packages}; fi

ENV DJANGO_STATIC_ROOT=/static
ENV DJANGO_MEDIA_ROOT=/media

VOLUME ["/static", "/media", "/app"]

EXPOSE 5000/tcp

COPY environment_settings.py /
COPY entrypoint.sh /
COPY health_urls.py /

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
