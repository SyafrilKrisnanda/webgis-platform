#!/bin/sh
set -e

if [ -n "${DB_HOST}" ]; then
  echo "Menunggu database di ${DB_HOST}:${DB_PORT:-5432}..."
  while ! nc -z "${DB_HOST}" "${DB_PORT:-5432}"; do
    sleep 1
  done
fi

python manage.py migrate --noinput

exec "$@"