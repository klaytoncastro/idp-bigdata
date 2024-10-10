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

# Barra de progresso com temporizador de 60 segundos e percentual
echo "Aguardando 1 minuto para que os serviços subam corretamente..."
progress_bar () {
    local duration=$1
    local interval=1
    local total=$((duration / interval))

    for ((i=0;i<total;i++)); do
        # Calcula o percentual
        percent=$(( (i + 1) * 100 / total ))

        # Imprime a barra de progresso e o percentual
        printf "▇"
        printf " %d%%\r" "$percent"
        sleep $interval
    done
    printf "\n"
}

# Espera real de 60 segundos com barra de progresso
progress_bar 60

# Verificando o status dos containers
docker ps

# Derrubando os containers após a primeira subida
docker compose down
