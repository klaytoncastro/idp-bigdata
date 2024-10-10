  #!/bin/bash

  # Gera a chave Fernet e a salva em fernet_key.txt
  docker compose run --rm airflow-webserver python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())" > fernet_key.txt

  # Verifica se o arquivo fernet_key.txt foi gerado corretamente
  if [ ! -f "fernet_key.txt" ]; then
    echo "Chave Fernet não encontrada! Por favor, gere a chave Fernet primeiro."
    exit 1
  fi

  # Lê a chave Fernet do arquivo fernet_key.txt
  FERNET_KEY=$(cat fernet_key.txt)

  # Substitui a string #CHAVEFERNET pela chave Fernet no docker-compose.yml
  sed -i "s|#CHAVEFERNET|AIRFLOW__CORE__FERNET_KEY=${FERNET_KEY}|g" docker-compose.yml

  echo "Chave Fernet inserida com sucesso no arquivo docker-compose.yml"
