#!/usr/bin/env bash
cd $(dirname $0)
settings_found=$(find . -name settings  -o -name settings.py | \
		     head |tr / . |\
		     cut -d . -s -f 3-)
export DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE:-${settings_found}}

DJANGO_WSGI=${DJANGO_WSGI:-$(basename $(find . -maxdepth 2 -type f -name wsgi.py  | head -1|awk -F/ '{print $2"."$3}') .py)}

DJANGO_LOG_LEVEL=${DJANGO_LOG_LEVEL:-info}

# Populate settings with default, and override them with environment variables
cat > settings.py <<EOF

#
# Keep default settings apart
#
from ${DJANGO_SETTINGS_MODULE} import * as __default_settings
#
# Default project settings
#
from ${DJANGO_SETTINGS_MODULE} import *

EOF
#
# Module to override settings with environment variables
#
cat >> final_settings.py < environment_settings.py

export DJANGO_SETTINGS_MODULE=final_settings

python3 manage.py migrate

python3 manage.py collectstatic --no-input

gunicorn --bind 0.0.0.0:5000 \
	          --capture-output \
	          --log-level=${DJANGO_LOG_LEVEL} \
		  --pid /var/run/gunicorn.pid \
		  ${DJANGO_WSGI} $*
