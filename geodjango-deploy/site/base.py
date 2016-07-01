import os
import platform

_APP_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

DEBUG = False
TEMPLATE_DEBUG = DEBUG

STATIC_ROOT = os.path.join(_APP_DIR, 'web/static/')
MEDIA_ROOT =  os.path.join(_APP_DIR, 'web/media/')

ALLOWED_HOSTS = ['*']

DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        'NAME': 'postgis',
        'USER': 'postgis',
        'PASSWORD':'postgis',
        'HOST': 'postgis',
        'PORT': os.environ.get('POSGIS_PORT_5432_TCP_PORT'),
    },
}

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'level': 'DEBUG',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': os.path.join(_APP_DIR, 'log/django.log'),
            'maxBytes' : 1048576,
            'backupCount': 3,
        },
    },
    'loggers': {
        '':{
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': True,
        },
    },
}
