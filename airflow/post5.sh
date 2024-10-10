#!/bin/bash

# Gera a chave Fernet e a salva em fernet_key.txt
docker compose run --rm airflow-webserver python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())" > fernet_key.txt

# Verifica se o arquivo fernet_key.txt foi gerado corretamente
if [ ! -f "fernet_key.txt" ]; then
    echo "Erro: Chave Fernet não foi gerada corretamente!"
    exit 1
fi

# Lê a chave Fernet do arquivo fernet_key.txt e remove qualquer quebra de linha
FERNET_KEY=$(cat fernet_key.txt | tr -d '\n')

# Substitui a string #CHAVEFERNET pela chave Fernet no docker-compose.yml
sed -i "s|#CHAVEFERNET|- AIRFLOW__CORE__FERNET_KEY=${FERNET_KEY}|g" docker-compose.yml

echo "Chave Fernet inserida com sucesso no arquivo docker-compose.yml."

docker compose down

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
        printf "\r▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ %d%%" "$percent"
        sleep $interval
    done
    printf "\n"
}

