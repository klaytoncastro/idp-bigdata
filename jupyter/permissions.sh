#!/bin/bash

# Verifica se as pastas existem e, se não existirem, as cria
for folder in config data notebooks; do
  if [ ! -d "$folder" ]; then
    mkdir "$folder"
  fi
done

# Altera o proprietário e o grupo das pastas para 1000:1000, mesmos uid e gid do usuário padrão do contêiner (jovyan)
sudo chown -R 1000:1000 config data notebooks
