# Redis

Redis é um armazenamento de estrutura de dados em memória, usado como banco de dados, cache e servidor de mensagens. É conhecido por sua rapidez e eficiência.

## Características

- **Armazenamento em Memória**: O Redis armazena dados em memória para acesso rápido.
- **Suporte a Diversas Estruturas de Dados**: O Redis suporta várias estruturas de dados, como strings, hashes, listas, conjuntos, conjuntos ordenados, bitmaps, hyperloglogs e índices geoespaciais.
- **Persistência de Dados**: O Redis oferece opções para persistir dados em disco sem comprometer a velocidade.
- **Replicação e Particionamento**: O Redis suporta replicação e particionamento para escalabilidade horizontal.

## Instalação via Docker Compose

Para instalar o Redis usando Docker Compose, siga estes passos:

1. Crie um arquivo `docker-compose.yml` com o seguinte conteúdo:

```yaml
version: '3'

services:
  redis:
    image: redis:latest
    ports:
      - "6379:6379"
    volumes:
      - $HOME/redis/data:/data
