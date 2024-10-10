#!/bin/bash

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

# Testando a barra de progresso por 10 segundos
echo "Testando a barra de progresso por 10 segundos..."
progress_bar 120
