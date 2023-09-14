#!/bin/bash

echo "Removendo containers parados..."
docker container prune -f

echo "Removendo todas as imagens não utilizadas..."
docker image prune -a -f

echo "Removendo volumes não utilizados..."
docker volume prune -f

echo "Removendo redes não utilizadas..."
docker network prune -f

echo "Removendo tudo (incluindo caches de build)..."
docker system prune -a --volumes -f

echo "Limpeza concluída!"

