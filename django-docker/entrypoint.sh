#!/usr/bin/env bash
#
# Exit if error occurs
#
set -e
set -x
#
# Set BASE dir
#
BASE=${BASE:-""}
#
# Set RUN dir
#
RUN_DIR=$(dirname $(realpath $0))
#
# Set FIRST_RUN
#
NOT_FIRST_RUN="${BASE}/.NOT_FIRST_RUN"
if [[ -f ${NOT_FIRST_RUN} ]]
then
    export FIRST_RUN=
    export PIP_UTILS=
else
    export FIRST_RUN=1
    export PIP_UTILS="dj-database-url psycopg2-binary mysql-connector"
fi

if [[ $# -ge 2 ]]
then
    cd $(dirname $1)
else
    cd ${BASE}/app
fi
#
# Extra gunicorn options
#
GUNICORN_OPTIONS=${GUNICORN_OPTIONS:-""}

#
# Disable whitenoise if requested
#
WHITENOISE_DISABLED=${WHITENOISE_DISABLED:-""}

#
# Clone a git repo if configured
#
if [[ -n "${FIRST_RUN}" && "${GIT_REPO_URL}" ]]
then
    if [[ -z "${GIT_SSH_KEY_FILE}" ]]
    then
	GIT_SSH_KEY_FILE=${BASE}/Git_SSH_Key
    fi
    if [[ ! -s "${GIT_SSH_KEY_FILE}" && -n "${GIT_SSH_KEY}" ]]    
    then
	echo "${GIT_SSH_KEY}" > ${GIT_SSH_KEY_FILE}
	chmod 600 ${GIT_SSH_KEY_FILE}
    fi
    if [[ -s ${GIT_SSH_KEY_FILE} ]]
    then
	export GIT_SSH_COMMAND="ssh -i ${GIT_SSH_KEY_FILE} -o PasswordAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
    fi
    git clone ${GIT_REPO_URL} .
fi

if [[ -n "${FIRST_RUN}" && -n "${REQUIRED_PACKAGES}" ]]
then
    apt-get update
    apt-get install -y ${REQUIRED_PACKAGES}
fi

# Install requirements
if  [[ -n "${FIRST_RUN}" ]]
then
    pip install ${PIP_UTILS}
    if [[ -z "${WHITENOISE_DISABLED}" ]]
    then
	pip install 'whitenoise[brotli]'
    fi
    REQUIREMENTS_FILES=${REQUIREMENTS_FILES:-requirements.txt}
    for req in ${REQUIREMENTS_FILES}
    do
	REQUIREMENTS="${REQUIREMENTS} -r ${req}"
    done
    pip install ${REQUIREMENTS}
fi

# Install the correct version of django-health-check
if  [[ -n "${FIRST_RUN}" ]]
then
    NO_PATH_DJANGO=$(python -c  'import sys; from distutils.version import StrictVersion ; from django import get_version; print((StrictVersion("2.0.0")>StrictVersion(get_version())))')
    if [[ ${NO_PATH_DJANGO} == "True" ]]
    then
	health_check="django-health-check<3.14"
    else
	health_check="django-health-check>=3.14"
    fi
    pip install "${health_check}"
fi


## Find settings in CWD
settings_found=$(find . -name settings  -o -name settings.py | \
		     head |tr / . | sed 's/\.py$//' | \
		     cut -d . -s -f 3- | head -1)

export DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE:-${settings_found}}

## Find .wsgi
DJANGO_WSGI=${DJANGO_WSGI:-$(basename $(find . -maxdepth 2 -type f -name wsgi.py  | head -1|awk -F/ '{print $2"."$3}') .py)}

export DJANGO_LOG_LEVEL=${DJANGO_LOG_LEVEL:-info}

# Select POSTGRES_HOST (if any and no other database definition available):
if [[ -z "${DJANGO_DATABASES}" && -z "${DATABASE_URL}" && -z "${POSTGRES_HOST}" ]]
then
    p_host=$(printenv | /bin/egrep -e 'POSTGRES.*HOST' | /usr/bin/sort | /usr/bin/head -1 | /usr/bin/awk -F'=' '{print $2}')
    if [[ -n ${p_host} ]]
    then
	export POSTGRES_HOST=${p_host}
    fi
fi


# Populate settings with default, and override them with environment variables
cat > ${BASE}/settings/final_settings.py <<EOF

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
cat >> ${BASE}/settings/final_settings.py < ${RUN_DIR}/environment_settings.py

export PYTHONPATH=${BASE}/settings
export DJANGO_SETTINGS_MODULE=final_settings

if [[ "${DJANGO_LOG_LEVEL}" == "DEBUG" ]]
then
    printenv
    python3 manage.py diffsettings
fi

#
# App Health URLs: this goes to settings because
# it's whithin PYTHONPATH and outside BASE
#
cp ${RUN_DIR}/health_urls.py ${BASE}/settings

python3 manage.py migrate --no-input

python3 manage.py collectstatic --no-input || echo "WARNING: "$(date)": Failed to collect static files. Continuing."

#
# Create Super User
#
if [[ -n "${FIRST_RUN}"                 && \
      -n "${DJANGO_SUPERUSER_USERNAME}" && \
      -n "${DJANGO_SUPERUSER_EMAIL}"    && \
      -n "${DJANGO_SUPERUSER_PASSWORD}" ]]
then
    # Try Django>=3.0
    # Disable shell exit on error
    set +e
    python manage.py createsuperuser --no-input
    if [[ $? -ne 0 ]]
    then
	# Try Django < 3.0
	python manage.py shell <<EOF
import os
from django.contrib.auth.models import User
User.objects.create_superuser(
  os.getenv('DJANGO_SUPERUSER_USERNAME'),
  email=os.getenv('DJANGO_SUPERUSER_EMAIL'),
  password=os.getenv('DJANGO_SUPERUSER_PASSWORD'),
)
EOF
    fi
fi
# Reenable shell exit on error
set -e

#
# Mark NOT_FIRST_RUN for later.
#
touch ${NOT_FIRST_RUN}


#
# Run app
#
gunicorn --bind 0.0.0.0:5000 \
	          --capture-output \
	          --log-level=${DJANGO_LOG_LEVEL} \
		  --pid ${BASE}/gunicorn.pid \
		  ${DJANGO_WSGI} ${GUNICORN_OPTIONS}
