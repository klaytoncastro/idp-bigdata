#!/usr/bin/env bash
set -euo pipefail

# UID/GID do processo do Elasticsearch no container oficial (uid=1000, gid=0)
ES_UID=1000
ES_GID=0

# Usa sudo apenas se não for root
maybe_sudo() {
  if [[ $EUID -ne 0 ]]; then sudo "$@"; else "$@"; fi
}

# Cria diretórios (idempotente)
mkdir -p elastic/config elastic/data logstash/pipelines datasets

# Ajusta dono de 'elastic' APENAS se estiver diferente
current_uid=$(stat -c '%u' elastic 2>/dev/null || echo -1)
current_gid=$(stat -c '%g' elastic 2>/dev/null || echo -1)
if [[ "$current_uid" != "$ES_UID" || "$current_gid" != "$ES_GID" ]]; then
  maybe_sudo chown -R "${ES_UID}:${ES_GID}" elastic
fi

# Ajusta modo de elastic/data APENAS se necessário
# (0750 é o recomendado; não mexe se já estiver correto)
want_mode=750
cur_mode=$(stat -c '%a' elastic/data 2>/dev/null || echo "")
if [[ "$cur_mode" != "$want_mode" ]]; then
  maybe_sudo chmod -R 0750 elastic/data
fi

# Logstash e datasets legíveis (0755), mas só muda se precisar
for d in logstash datasets; do
  if [[ -d "$d" ]]; then
    cur=$(stat -c '%a' "$d")
    if [[ "$cur" != "755" ]]; then
      maybe_sudo chmod 0755 "$d"
    fi
  fi
done

echo "OK: diretórios prontos e permissões conferidas."

