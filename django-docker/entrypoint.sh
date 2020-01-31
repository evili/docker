#!/usr/bin/env bash
#
# Exit if error occurs
#
set -e

if [[ $# -ge 1 ]]
then
    cd $(dirname $1)
else
    cd /app
fi

if [[ -n "${REQUIRED_PACKAGES}" ]]
then
    apk update
    ## we add gcc, g++, and libc-dev so that we can compile.
    apk add gcc g++ libc-dev ${REQUIRED_PACKAGES}
fi

# Install requirements
REQUIREMENTS_FILES=${REQUIREMENTS_FILES:-requirements.txt}
for req in ${REQUIREMENTS_FILES}
do
    REQUIREMENTS="${REQUIREMENTS} -r ${req}"
done

pip install ${REQUIREMENTS}

## Remove gcc and friends but not the rest
if [[ -s "${REQUIRED_PACKAGES}" ]]
then
    apk del gcc g++ libc-dev
fi

## Find settings in CWD
settings_found=$(find . -name settings  -o -name settings.py | \
		     head |tr / . |\
		     cut -d . -s -f 3- | head -1)

export DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE:-${settings_found}}

## Find .wsgi
DJANGO_WSGI=${DJANGO_WSGI:-$(basename $(find . -maxdepth 2 -type f -name wsgi.py  | head -1|awk -F/ '{print $2"."$3}') .py)}

DJANGO_LOG_LEVEL=${DJANGO_LOG_LEVEL:-info}

# Populate settings with default, and override them with environment variables
cat > /settings/final_settings.py <<EOF

#
# Keep default settings apart
#
import ${DJANGO_SETTINGS_MODULE} as __default_settings
#
# Default project settings
#
from ${DJANGO_SETTINGS_MODULE} import *

EOF
#
# Module to override settings with environment variables
#
cat >> /settings/final_settings.py < /environment_settings.py

export PYTHONPATH=/settings
export DJANGO_SETTINGS_MODULE=final_settings

if [[ ${DJANGO_LOG_LEVEL} == "debug" ]]
then
    python3 manage.py diffsettings
fi

python3 manage.py migrate --no-input

python3 manage.py collectstatic --no-input

gunicorn --bind 0.0.0.0:5000 \
	          --capture-output \
	          --log-level=${DJANGO_LOG_LEVEL} \
		  --pid /var/run/gunicorn.pid \
		  ${DJANGO_WSGI} $*
