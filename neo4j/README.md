# Neo4j

Neo4j é um banco de dados NoSQL orientado a grafos, utilizado para armazenar dados estruturados como grafos, ao invés de tabelas, como em bancos de dados relacionais. É ideal para representar relacionamentos complexos entre dados.

## Características

- **Orientado a Grafos**: Neo4j utiliza o modelo de dados de grafo, onde os dados são armazenados como nós e as relações entre eles como arestas.
- **Cypher Query Language**: Neo4j usa uma linguagem de consulta específica para grafos chamada Cypher, que é semelhante ao SQL, mas otimizada para consultas em grafos.
- **Escalabilidade**: Neo4j é projetado para ser escalado horizontalmente, suportando grandes volumes de dados.
- **Integração com outras Ferramentas**: Neo4j se integra facilmente com várias outras ferramentas e frameworks, como Spring Data Neo4j, para facilitar o desenvolvimento de aplicações.

## Instalação via Docker Compose

A instalação do Neo4j pode ser feita utilizando Docker Compose. Aqui estão os passos para instalar o Neo4j usando Docker Compose:

1. Crie um arquivo `docker-compose.yml` com o seguinte conteúdo:

```yaml
version: '3'

services:
  neo4j:
    image: neo4j:latest
    environment:
      NEO4J_AUTH: neo4j/password
    ports:
      - "7474:7474"
      - "7687:7687"
    volumes:
      - $HOME/neo4j/data:/data
