from django.conf import settings
from django.urls import path, include

urlpatterns = [
    path('health_checks', include('health_check.urls')),
    path('', include(settings.PROJECT_ROOT_URLCONF)),
]
