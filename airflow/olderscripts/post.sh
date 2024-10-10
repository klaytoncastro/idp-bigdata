#!/bin/bash

# Inicializa o Banco de Dados
docker compose run --rm airflow-webserver airflow db init

# Gera a chave Fernet e salva no arquivo fernet_key.txt
docker compose run --rm airflow-webserver python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())" > fernet_key.txt

# Verifica se o arquivo fernet_key.txt foi gerado corretamente
if [ ! -f "fernet_key.txt" ]; then
  echo "Chave Fernet não encontrada! Por favor, gere a chave Fernet primeiro."
  exit 1
fi

# Lê a chave Fernet do arquivo
FERNET_KEY=$(cat fernet_key.txt)

# Substitui a chave Fernet no docker-compose.yml, onde a chave está comentada
# Usando | como delimitador no sed para evitar problemas com caracteres especiais na chave Fernet
sed -i "s|#.*AIRFLOW__CORE__FERNET_KEY=.*|AIRFLOW__CORE__FERNET_KEY=${FERNET_KEY}|g" docker-compose.yml

echo "Chave Fernet inserida com sucesso no arquivo docker-compose.yml"
