#!/bin/bash

cd /opt

# Verifica se o Docker Compose V2 está instalado
if ! command -v docker compose &> /dev/null; then
    echo "Erro: Docker Compose V2 não encontrado. Instale com 'sudo apt install docker-compose-plugin'."
    exit 1
fi

find . -name "docker-compose.yml" -exec dirname {} \; | while read dir; do
    full_path="/opt/$dir"
    echo "Parando containers no diretório: $full_path"

    cd "$full_path"

    # Para os containers utilizando Docker Compose V2
    docker compose down

    cd - > /dev/null  # Volta para /opt sem poluir o terminal
done

# Força a parada de qualquer container restante
echo "Parando qualquer container ainda ativo..."
docker stop $(docker ps -q) 2>/dev/null

echo "Lista final de containers em execução:"
docker ps
