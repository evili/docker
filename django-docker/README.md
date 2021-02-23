# docker-django

## A Docker image to execute Django apps

This is a python:alpine image that will run a Django project using
gunicorn and listening on TCP port 5000. It will try to do its best to
run with sensible default settings for non testing environments (no `DEBUG`,
Postgres database, etc.).

How it works:

* It uses environment variables to override Django settings: any setting
  present in the Django global_settings or the project default
  settings module or the module designated by `DJANGO_SETTINGS_MODULE`
  (normally that's project_name.settings) can be overriden by the
  environment runtime variable `DJANGO_NAME_OF_THE_SETTING`. For example, to
  change the default timezeone `TIME_ZONE` (None) you should set
  `DJANGO_TIME_ZONE='CET'` for Central European Time.
  To change the
  default language set, for example, `DJANGO_LANGUAGE_CODE='ca'` to set
  Catalan language.

* If the Django setting value is not a string, the environment
   variable is evaluated as Python code. This way, you can change any
   setting tipe (integer, tuple, list, whatever).
   For example to
   change the `INSTALLED_APPS` variable from the default you should
   set  
   `DJANGO_INSTALLED_APPS="['django.contrib.auth','django.contrib.contenttypes','django.contrib.sessions','django.contrib.messages','django.contrib.staticfiles','myapp',]"`,
   or even: `DJANGO_INSTALLED_APPS="INSTALLED_APPS +
   ['my_special_app']"`

* For database settings there is a special treatment. If no
  `DJANGO_DATABASES` environment variable exists, it looks for
  `DJANGO_DATABASE_ENGINE` (defaulting to postgres), `DJANGO_DATABASE_HOST`,
  `DJANGO_DATABASE_NAME`, `DJANGO_DATABASE_USER`, and `DJANGO_DATABASE_PASSWORD`
  to set up the `'default'` database.
  To 

* `DEBUG` is disabled unless enabled *explicitly* via environment variable (set `DJANGO_DEBUG=True`).
* Includes django-health-checks mountd at URL `health_check`


How to run it:

You should mount the base directory of your Django project at the `/app` volume.
For example:

    $ cd your_django_project_dir
    $ docker run -t -i -e DJANGO_TIME_ZONE='CET' -v $(pwd):/app django
