# Redis

Redis é um armazenamento de estrutura de dados em memória, usado como banco de dados, cache e servidor de mensagens. É conhecido por sua rapidez e eficiência.

## Características

- **Armazenamento em Memória**: O Redis armazena dados em memória para acesso rápido.
- **Suporte a Diversas Estruturas de Dados**: O Redis suporta várias estruturas de dados, como strings, hashes, listas, conjuntos, conjuntos ordenados, bitmaps, hyperloglogs e índices geoespaciais.
- **Persistência de Dados**: O Redis oferece opções para persistir dados em disco sem comprometer a velocidade.
- **Replicação e Particionamento**: O Redis suporta replicação e particionamento para escalabilidade horizontal.

## Instalação via Docker Compose

Para instalar o Redis usando Docker Compose, crie um arquivo `docker-compose.yml` com o seguinte conteúdo:

```yaml
version: '3'

services:
  redis:
    image: redis:latest
    ports:
      - "6379:6379"
    volumes:
      - $HOME/redis/data:/data
```

Suba o contêiner: 

```shell
docker-compose up -d
```

## Aplicação de Cache em Tempo Real com Redis

Aqui está um exemplo simples de como usar o Redis para cache:

```python
import redis
import time
```

### Conexão com o servidor Redis (ajuste o host e a porta conforme necessário)
r = redis.Redis(host='localhost', port=6379, db=0)

### Definindo uma chave com um valor e um tempo de expiração (em segundos)
r.setex("chave", 30, "valor")

### Recuperando o valor da chave
valor = r.get("chave")
print("Valor recuperado:", valor)

### Simulando um atraso para demonstrar a expiração
time.sleep(31)
valor_apos_expiracao = r.get("chave")
print("Valor após expiração:", valor_apos_expiracao)
Este exemplo mostra como armazenar e recuperar dados no Redis, com um tempo de expiração definido.

## Filas de Mensagens e Processamento de Streams com Redis
Para o processamento de filas e streams, você pode usar as listas do Redis para simular uma fila de mensagens:

```python
import redis
```

### Conexão com o Redis
r = redis.Redis(host='localhost', port=6379, db=0)

### Enviando mensagens para a fila
r.lpush("fila", "mensagem 1")
r.lpush("fila", "mensagem 2")

### Processando mensagens da fila
while True:
    mensagem = r.brpop("fila", 5)  # Aguarda 5 segundos por uma mensagem
    if mensagem:
        print("Mensagem recebida:", mensagem[1])
    else:
        print("Nenhuma mensagem nova.")
        break


Este código ilustra como enviar e receber mensagens de uma fila usando o Redis. O `brpop` é um comando bloqueante que aguarda até que uma mensagem esteja disponível na fila.


## Exemplo: Flask + Redis

Os exemplos acima são básicos, mas eficazes para demonstrar os conceitos de cache em tempo real e filas de mensagens usando o Redis. Para configurar um ambiente com Docker que inclua tanto o Redis quanto o Flask, você precisará de um `Dockerfile` para a aplicação Flask e um `docker-compose.yml` para orquestrar os contêineres. 


### Dockerfile para a Aplicação Flask
Primeiro, crie um Dockerfile para a aplicação Flask.

```shell
# Usa a imagem base do Python
FROM python:3.8-slim

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos de requisitos e instala as dependências
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copia o restante dos arquivos da aplicação
COPY . .

# Define a porta em que a aplicação será executada
EXPOSE 5000

# Define o comando para iniciar a aplicação
CMD ["python", "app.py"]
```

No arquivo `requirements.txt`, inclua:

```shell
flask
redis
```

Agora crie um arquivo `app.py` com o código da sua aplicação Flask.

### Orquestração do Flask e Redis
Agora, crie um arquivo docker-compose.yml que defina os serviços para o Flask e o Redis:

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "5000:5000"
    depends_on:
      - redis
  redis:
    image: "redis:alpine"
    ports:
      - "6379:6379"
```

Este docker-compose.yml define dois serviços:

- web: O serviço para a sua aplicação Flask. Ele constrói a imagem a partir do Dockerfile e mapeia a porta 5000 para a porta 5000 do host.
- redis: O serviço para o Redis, usando a imagem redis:alpine. Ele mapeia a porta 6379 para a porta 6379 do host.

Após configurar esses arquivos, você pode iniciar os serviços com o seguinte comando:

```bash
docker-compose up -d
```

Isso irá construir a imagem para a sua aplicação Flask e iniciar tanto o serviço Flask quanto o Redis. Assegure-se de que o seu código Flask esteja configurado para se conectar ao Redis usando o hostname `redis`, que é o nome do serviço definido no `docker-compose.yml`.

Com essa configuração, você poderá demonstrar os exemplos de cache em tempo real e filas de mensagens usando Redis. 

### Exemplos de Aplicações

1. Sistema de Autenticação e Sessão de Usuários
Chave: ID da sessão do usuário ou token de autenticação.
Valor: Dados associados à sessão do usuário, como ID do usuário, preferências, roles/permissões, etc.
Aplicação: Armazenar e gerenciar sessões de usuário em um ambiente web, onde a velocidade de acesso e a expiração automática das sessões são cruciais.
2. Catálogo de Produtos para E-commerce
Chave: SKU ou ID do produto.
Valor: Detalhes do produto, como nome, descrição, preço, informações do fornecedor.
Aplicação: Rápido acesso aos dados dos produtos para exibição em um site de e-commerce, onde a performance é um fator importante.
3. Sistema de Gerenciamento de Configurações
Chave: Nome da configuração (por exemplo, "limiteDeUpload", "horárioDeManutenção").
Valor: Valor da configuração (por exemplo, "10MB", "01:00-03:00").
Aplicação: Armazenar configurações de aplicativos ou sistemas que podem ser alteradas dinamicamente sem a necessidade de reiniciar o sistema.
4. Sistema de Cache para Resultados de Pesquisa ou Análises
Chave: Termo da pesquisa ou parâmetros da análise.
Valor: Resultados da pesquisa ou análise.
Aplicação: Melhorar a performance de aplicações que realizam pesquisas frequentes ou análises complexas, armazenando os resultados para recuperação rápida.
5. Registro de Atividades ou Logs
Chave: Identificador único do evento (como timestamp ou ID de evento).
Valor: Detalhes do evento ou log.
Aplicação: Rápido armazenamento e acesso a logs ou eventos para monitoramento e análise em sistemas de grande escala.
Estas são apenas algumas ideias, e a beleza do uso de um banco de dados baseado em chave-valor como o Redis é que ele é extremamente versátil e pode ser adaptado para uma variedade de aplicações em diferentes domínios. Escolher um contexto que seja relevante e interessante para seus alunos pode tornar o aprendizado mais envolvente e prático.

## Demonstração do Ambiente

### Utilizar Logs da Aplicação Flask

Você pode adicionar instruções de log no seu código Flask para demonstrar quando a aplicação está acessando o Redis. Por exemplo, ao buscar ou definir valores no Redis, você pode imprimir mensagens no console:

```python
from flask import Flask
import redis

app = Flask(__name__)
r = redis.Redis(host='redis', port=6379, db=0)

@app.route('/')
def hello_world():
    r.set("alguma_chave", "algum_valor")
    valor = r.get("alguma_chave")
    app.logger.info(f'Valor obtido do Redis: {valor}')
    return 'Olá, mundo!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
```

Quando você acessar a aplicação Flask, essas mensagens de log aparecerão no terminal ou na interface do Docker onde você executou o `docker-compose up -d`.

## Acompanhar Logs do Docker Compose
Para ver as mensagens de log em tempo real, você pode abrir um terminal e executar:

```bash
docker-compose logs -f
```

Isso mostrará um fluxo contínuo de logs de todos os serviços definidos no seu `docker-compose.yml`, incluindo tanto o Flask quanto o Redis.

### Demonstrações Interativas
Outra forma eficaz de demonstrar é criar rotas Flask específicas para diferentes operações do Redis (como definir um valor, obter um valor, listar valores de uma fila, etc.) e acessar estas rotas através do navegador ou usando uma ferramenta como Postman. Isso permite uma interação direta e visual com a aplicação e o Redis.

### Usar Redis CLI
Você também pode abrir um terminal no container Redis para interagir diretamente com o banco de dados usando o Redis CLI. Isso pode ser feito usando o comando:

```bash
docker exec -it [NOME_DO_CONTAINER_REDIS] redis-cli
```

Aqui, você pode executar comandos do Redis para mostrar diretamente o estado do banco de dados. 

## Interação via API e CLI

Outra forma eficaz de demonstrar é criar rotas Flask específicas para diferentes operações do Redis (como definir um valor, obter um valor, listar valores de uma fila, etc.) e acessar estas rotas através do navegador (usando uma ferramenta como Postman) ou `curl`. Isso permite uma interação direta e visual com a aplicação e o Redis. Para criar uma aplicação Flask interativa que demonstre diferentes operações com o Redis, você pode definir várias rotas em sua aplicação. 

```python
from flask import Flask, request
import redis

app = Flask(__name__)
r = redis.Redis(host='redis', port=6379, db=0)

@app.route('/set/<chave>/<valor>')
def set_valor(chave, valor):
    r.set(chave, valor)
    return f'Valor {valor} foi armazenado com a chave {chave}'

@app.route('/get/<chave>')
def get_valor(chave):
    valor = r.get(chave)
    if valor:
        return f'Valor recuperado: {valor.decode("utf-8")}'
    else:
        return 'Chave não encontrada'

@app.route('/push/<lista>/<valor>')
def push_lista(lista, valor):
    r.lpush(lista, valor)
    return f'Valor {valor} adicionado à lista {lista}'

@app.route('/pop/<lista>')
def pop_lista(lista):
    valor = r.lpop(lista)
    if valor:
        return f'Valor retirado da lista {lista}: {valor.decode("utf-8")}'
    else:
        return f'Lista {lista} está vazia ou não existe'

@app.route('/listar/<lista>')
def listar_valores(lista):
    valores = r.lrange(lista, 0, -1)
    return f'Valores na lista {lista}: {[valor.decode("utf-8") for valor in valores]}'

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
```

Este código Flask cria rotas para definir e obter valores, bem como para adicionar e remover valores de uma lista no Redis. Para interagir com o Redis usando o Redis CLI, você pode usar o seguinte comando para acessar o terminal do container Redis:

```bash
docker exec -it [NOME_DO_CONTAINER_REDIS] redis-cli
```

Dentro do CLI do Redis, você pode executar vários comandos para demonstrar diferentes funcionalidades. Alguns exemplos são:

### Listar Todas as Chaves:

```bash
KEYS *
```

### Obter o Valor de Uma Chave Específica:

```bash
GET [chave]
```

### Exibir os valores de uma lista

```bash
LRANGE [lista] 0 -1
```

### Visualizar Informações de Status do Servidor Redis:

```bash
INFO
```

## Exemplos de Comandos Curl para inserir Dados no Redis:

Para definir um valor no Redis usando a rota `/set/<chave>/<valor>`:


```bash
curl http://localhost:5000/set/minhaChave/meuValor
```

- Este comando irá definir o valor meuValor para a chave minhaChave no Redis.

### Adicionar Valor a uma Lista no Redis:

Para adicionar um valor a uma lista usando a rota `/push/<lista>/<valor>`:

```bash
curl http://localhost:5000/push/minhaLista/valor1
```

- Este comando adicionará o valor valor1 à lista minhaLista no Redis.

### Carga de Dados via Loop e Arquivo

Suponha que você tenha um arquivo chamado dados.txt, onde cada linha contém um par chave-valor separado por vírgula. Você pode usar um script para ler este arquivo e enviar cada par chave-valor para o Redis usando `curl`: 

```csv
chave1,valor1
chave2,valor2
chave3,valor3
```

```bash
#!/bin/bash

# Lê cada linha do arquivo CSV
while IFS=, read -r chave valor; do
    # Envia a chave e o valor para o Redis usando curl
    curl "http://localhost:5000/set/$chave/$valor"
    echo " Inserido $chave: $valor"
done < dados.csv
```

Neste script, `IFS=,` define o separador de campo interno (Internal Field Separator) como vírgula, permitindo que o read divida cada linha nas variáveis chave e valor baseado na vírgula. O script lê cada linha do arquivo `dados.txt`, extrai a chave e o valor e os envia para o Redis através da API Flask usando curl. Certifique-se de ter o Flask rodando e acessível na porta especificada para que os comandos `curl` funcionem conforme esperado.