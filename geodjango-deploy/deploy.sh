#!/bin/bash
export APP_NAME=$(basename $(dirname $(find src -name settings.py -type f | head -1)))

# Set BUILD environment
source ${BASE_DIR}/build_env.sh

#
# Prepare site
#
export DJANGO_SETTINGS_MODULE=site.production
/usr/bin/python src/manage.py collectstatic --link --noinput --no-color

