#!/bin/sh
# wait-for-it.sh
# Aguarda até que um host/porta esteja disponível antes de continuar com um comando.

set -e

host="$1"
port="$2"
shift 2
cmd="$@"

until nc -z -v -w30 "$host" "$port"; do
  echo "Aguardando $host:$port..."
  sleep 2
done

echo "$host:$port está disponível, iniciando comando: $cmd"
exec $cmd

