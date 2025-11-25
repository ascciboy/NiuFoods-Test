#!/bin/bash
set -e

echo "Esperando a que la base de datos esté disponible..."
until pg_isready -h db -p 5432 > /dev/null 2>&1; do
  echo "Base de datos no disponible aún. Reintentando..."
  sleep 1
done

echo "Iniciando Sidekiq..."
exec bundle exec sidekiq -C config/sidekiq.yml
