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

# Aguardando a inicialização do ambiente
echo "Aguardando a inicialização do ambiente..."
progress_bar 80


# Verificando o status dos containers
docker ps

# Derrubando os containers após a primeira subida
docker compose down
