#!/bin/bash

# Gera a chave Fernet e a salva em fernet_key.txt
docker-compose run --rm airflow-webserver python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())" > fernet_key.txt

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

# Função para exibir a barra de progresso
progress_bar() {
  local duration=$1  # duração total em segundos
  local bar_width=50  # largura da barra de progresso

  already_done() { for ((done=0; done<$(($elapsed * $bar_width / $duration)); done++)); do printf "▇"; done }
  remaining() { for ((remain=$(($elapsed * $bar_width / $duration)); remain<$bar_width; remain++)); do printf " "; done }
  percentage() { printf "| %s%%" $(( ($elapsed * 100) / $duration )); }
  clean_line() { printf "\r"; }

  for (( elapsed=0; elapsed<$duration; elapsed++ )); do
      already_done; remaining; percentage
      sleep 1
      clean_line
  done
  # Exibir barra completa no final
  elapsed=$duration
  already_done; remaining; percentage
  echo ""
}

#Baixando os containers
docker-compose down && docker-compose up -d

# Aguardando a inicialização do ambiente
echo "Aguardando a parametrização do ambiente..."
echo "Após este tempo, você já poderá acessar o Airflow..."
progress_bar 120