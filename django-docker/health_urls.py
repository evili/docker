import importlib
from distutils.version import StrictVersion
from django import get_version
from django.conf import settings

__rt_version = get_version()

print("Django Version:", __rt_version)

if StrictVersion('2.0.0') > StrictVersion(__rt_version):
    # Django <2.0, use url()
    __urls = importlib.import_module('django.conf.urls')

    #from django.urls import url, include
    urlpatterns = [
        __urls.url('^health_checks/', __urls.include('health_check.urls')),
        __urls.url('^', __urls.include(settings.PROJECT_ROOT_URLCONF)),
    ]
else:
    # Django >= 2.0, use path()
    __urls = importlib.import_module('django.urls')
    #from django.urls import path, include
    urlpatterns = [
        __urls.path('health_checks', __urls.include('health_check.urls')),
        __urls.path('', __urls.include(settings.PROJECT_ROOT_URLCONF)),
    ]
