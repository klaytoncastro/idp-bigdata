#!/bin/bash

# Diretório base (define o diretório corrente de forma idempotente)
BASE_DIR=$(pwd)

# Criando diretórios necessários se não existirem
echo "Criando diretórios se não existirem..."
mkdir -p "$BASE_DIR/dags" "$BASE_DIR/logs" "$BASE_DIR/plugins" "$BASE_DIR/postgresql_data"

# Ajustando permissões dos diretórios de forma idempotente
echo "Ajustando permissões dos diretórios..."
chown -R 50000:50000 "$BASE_DIR/dags" "$BASE_DIR/logs" "$BASE_DIR/plugins" "$BASE_DIR/postgresql_data"
chmod -R 755 "$BASE_DIR/dags" "$BASE_DIR/plugins"
chmod -R 770 "$BASE_DIR/logs" "$BASE_DIR/postgresql_data"

# Subindo os containers pela primeira vez
docker compose up -d

# Esperando 1 minuto para garantir que tudo suba corretamente
echo "Aguardando 1 minuto para que os serviços subam corretamente..."
sleep 60

# Verificando o status dos containers
docker ps

# Derrubando os containers após a primeira subida
docker compose down
