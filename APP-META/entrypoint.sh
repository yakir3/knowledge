#!/bin/bash
if [ "$1" = 'test' ];then
  exec sleep infinity
elif [ "$1" = 'runserver' ];then
  # exec python manage.py runserver 0.0.0.0:${EXPOSE_PORT}
  exec tail -f /dev/null
fi

exec "$@"
