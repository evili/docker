#!/bin/bash
source ${BASE_DIR}/build_env.sh
echo "from ${APP_NAME}.settings import *" > site/production.py
echo "from .base import *"               >> site/production.py
echo "SECRET_KEY='"$(/usr/bin/pwgen -s -c -n 64 1)"'" >> site/production.py
