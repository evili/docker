#!/usr/bin/env bash
printenv
set -e
set -x
# git clone ${GIT_URL} .
pip install -r requirements.txt --no-input

if [ -z "${WSGI_MODULE}" ]
then
    export WSGI_MODULE=$(basename $(dirname $(find . -name wsgi.py | head -1))).wsgi
fi

DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE:-$(basename ${WSGI_MODULE} .wsgi).settings}

# Override static content
cat > settings.py <<EOF
from ${DJANGO_SETTINGS_MODULE} import *
STATIC_ROOT='/static'
EOF

export DJANGO_SETTINGS_MODULE=settings

python manage.py collectstatic --no-input

python manage.py migrate
LOG_LEVEL=${LOG_LEVEL:-INFO}
gunicorn --bind 0.0.0.0:8000  --log-level=${LOG_LEVEL} ${WSGI_MODULE} $*
