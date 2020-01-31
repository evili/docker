#
# Django Settings Module entirely based on defaults and environment
# First we import the default settings for the project that
# should reside in <projectname>.settings
# then we import the global_settings from django.conf
# superseeded by the default <projectname>.settings
# For each setting SETTING_NAME test if the corresponding
# environment variable DJANGO_SETTING_NAME is defined.
# If it is, we incorporate as a true Django Setting
# By default, we check if the global or default setting is a string, 
# if not we evaluate directly the value as a Python expression.
#
# Special Cases:
#   If DJANGO_DATABASES is not defined we look for alternate definition 
#   via DJANGO_DATABASE_ENGINE, DJANGO_DATABASE_HOST, DJANGO_DATABASE_NAME,
#   DJANGO_DATABASE_USER, and DJANGO_DATABASE_PASSWORD; defaulting to postgres
#   environment variables POSTGRES_HOST, POSTGRES_DB, etc.
#

import os

from django.conf import global_settings as __global_settings

#
# Default project settings
#
from . import *

#
# Dictionary to hold global and default settings
#
__settings = {}
# Django global settings dict
__settings.update(vars(__global_settings))
# default settings as a dict
__settings.update(vars(__default_settings))

for st,val in __settings.items():
    # skip private items
    if st.startswith('_'):
        continue
    else:
        # look for the corresponding 'DJANGO_..' environment
        env_setting = os.getenv('DJANGO_'+st, None)
        if env_setting is not None:
            # if the former setting was a string evaluate as such
            if isinstance(val, str):
                exec(st+" = '"+env_setting+"'")
            else:
                exec(st+" = "+env_setting)

if os.getenv('DJANGO_DATABASES', None) is None:
    _PROJECT_NAME = os.getenv('DJANGO_SETTINGS_MODULE').split('.')[0]
    
DATABASES = {
    'default': {
        'ENGINE': os.getenv('DJANGO_DATABASE_ENGINE','django.db.backends.postgresql'),
        'HOST': os.getenv('DJANGO_DATABASE_HOST', os.getenv('POSTGRES_HOST', 'postgres')),
        'NAME': os.getenv('DJANGO_DATABASE_NAME', os.getenv('POSTGRES_DB', _PROJECT_NAME)),
        'USER': os.getenv('DJANGO_DATABASE_USER', os.getenv('POSTGRES_USER', _PROJECT_NAME)),
        'PASSWORD' : os.getenv('DJANGO_DATABASE_PASSWORD', os.getenv('POSTGRES_PASSWORD', _PROJECT_NAME)),
    }
}
