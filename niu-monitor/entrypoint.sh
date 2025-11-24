#!/bin/bash
set -e

echo "Esperando a que la base de datos esté disponible..."
until pg_isready -h db -p 5432 > /dev/null 2>&1; do
  echo "Base de datos no disponible aún. Reintentando..."
  sleep 1
done

echo "Ejecutando migraciones..."
bundle exec rails db:migrate

if bundle exec rails runner "puts Restaurant.count == 0"; then
  echo "Sembrando base de datos..."
  bundle exec rails db:seed
else
  echo "Semilla omitida (los restaurantes ya existen)"
fi

echo "Iniciando servidor Rails..."
rm -f tmp/pids/server.pid
exec "$@"
