# Redis

## 1. Visão Geral

<!--https://flask-caching.readthedocs.io/en/latest/
https://medium.com/@fahadnujaimalsaedi/using-flask-and-redis-to-optimize-web-application-performance-34a8ae750097
https://flask.palletsprojects.com/en/stable/patterns/celery/
https://pandeyshikha075.medium.com/flask-api-and-redis-caching-improving-speed-and-scalability-with-docker-c43629144279
https://redis.io/docs/latest/commands/
https://www.fullstackpython.com/flask.html
-->

Redis é um armazenamento de estrutura de dados em memória, usado como banco de dados, cache e servidor de mensagens. É conhecido por sua rapidez e eficiência. 

## 2. Características

- **Armazenamento em Memória**: O Redis armazena dados em memória para acesso rápido.
- **Suporte a Diversas Estruturas de Dados**: O Redis suporta várias estruturas de dados, como strings, hashes, listas, conjuntos, conjuntos ordenados, bitmaps, hyperloglogs e índices geoespaciais.
- **Persistência de Dados**: O Redis oferece opções para persistir dados em disco sem comprometer a velocidade.
- **Replicação e Particionamento**: O Redis suporta replicação e particionamento para escalabilidade horizontal.

Embora o Redis seja normalmente utilizado via linha de comando ou integrado diretamente em aplicações, é possível utilizar interfaces gráficas para visualizar e manipular os dados armazenados de forma mais intuitiva. Além do Redis rodando na porta `6379`, nosso ambiente conta com o Redis Commander — uma GUI opcional para visualização dos dados, acessível em `http://localhost:8081` — e com uma aplicação Flask (`http://localhost:5000`), que será modificada ao longo da prática de laboratório.

## 3. Utilizando o Microframework Python Flask 

Neste ambiente, utilizamos o Flask, um microframework Python leve e poderoso para aplicações web, cuja visão é começar com o essencial e adicionar apenas os componentes necessários, à medida que você realmente precisa, abordagem ideal para projetos modulares como este.  

>"Se o Django é um buffet completo (você paga por tudo, mesmo se usar só 20%), o Flask é um cardápio à la carte: você adiciona apenas o necessário (como conexões Redis, autenticação ou templates), minimizando overhead e maximizando velocidade."

A arquitetura abaixo descrita foi projetada para demonstrar um ambiente orquestrado com Docker que inclua tanto o Redis quanto uma Web API integrada, como em muitas aplicações do mundo real. Para isso, o utilizamos o Docker Compose para subir os três serviços:

- Um aplicativo Web Python Flask
- Um banco de dados Redis
- Uma GUI web para o Redis (Redis Commander)

```bash
redis/
└── Dockerfile          # Configuração do container Flask
└── docker-compose.yml  # Definição dos serviços (Flask + Redis + Redis-Commander)
└── app.py              # Aplicação Flask principal
└── requirements.txt    # Lista de dependências que o aplicativo Python irá utilizar (flask, redis, etc.)
└── templates/          # Diretório para templates HTML (opcional, se usar Front-End / Jinja2)
└── static/             # Arquivos estáticos (opcional, se quiser complementar com CSS, JavaScript, imagens)
```

Faça uma leitura cuidadosa de cada um desses arquivos. Após entender a configuração proposta, você poderá iniciar os serviços com o seguinte comando:

```bash
docker-compose up -d --build
```

Isso irá construir a imagem para a sua aplicação e iniciar os serviços Flask e Redis. Com essa configuração, você estará pronto para implementar os exemplos de cache em tempo real e filas de mensagens usando Redis. 

<!--



Integração básica Flask + Redis

Uso de Redis como contador (endpoint /)
Armazenamento chave-valor simples com endpoints REST (/set/<k>/<v> e /get/<k>)
Possibilidade de usar Redis como cache ou contador persistente
Para configurar você precisará de um `Dockerfile` para a aplicação Flask e um `docker-compose.yml` para orquestrar os contêineres. 

### Dockerfile para a Aplicação Flask
Primeiro, o Dockerfile é usado como base para a aplicação Flask que irá interagir com o Redis.

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

O arquivo `requirements.txt` contém as dependências da sua aplicação:

```shell
flask
redis
```

O arquivo `app.py` deve conter o código da sua aplicação Flask.

-->

### Orquestração do Flask e Redis

Uma vez que os containers estejam no ar, o serviço Flask estará escutando em `http://localhost:5000`, o Redis estará escutando na porta `6379` e o Redis Commander (GUI) estará escutando na porta `8081`. Em nosso projeto, o Flask servirá como ponte entre o usuário e o Redis. Ele define rotas como `/`, `/set/<chave>/<valor>` e `/get/<chave>`, respondendo às requisições HTTP e manipulando os dados diretamente no Redis. Isso simula, de forma prática, como o Redis é usado em um back-end real — para contadores, cache, sessões ou filas — permitindo criar seus endpoints, testar a API, trabalhar com rotas estáticas e dinâmicas, além de depurar erros durante o processo de desenvolvimento.

<!--
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
-->

### Roteamento e visualizações

Roteamento refere-se ao mapeamento de URLs específicas para funções em um aplicativo web. Em outras palavras, quando você acessa um determinado endereço em um navegador web (ou faz uma chamada via API), o aplicativo precisa saber qual função deve ser executada e o que deve ser retornado para o usuário. No Flask, isso é feito por meio de decoradores como @app.route(), que associam funções Python a URLs específicas. Exemplo:

```python
@app.route('/inicio')
def inicio():
    return "Página Inicial"
```

Dito isso, vamos adicionar mais algumas rotas ao nosso aplicativo. Edite o arquivo `app.py` e acrescente:

```python
@app.route('/sobre')
def sobre():
    return "Sobre o aplicativo..."

@app.route('/contato')
def contato():
    return "Página de contato."
```

Dessa forma, você poderá acessar os endpoints `http://127.0.0.1:8500/sobre` ou `http://127.0.0.1:8500/contato` no navegador e visualizar as respectivas respostas retornadas pelo servidor. Lembre-se de manter o trecho abaixo ao final do arquivo `app.py`. Ele garante que o Flask será executado corretamente ao rodar o script principal da aplicação (no nosso caso, iniciado dentro de um container Docker):

```python
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

### Rotas Dinâmicas

Além de rotas fixas, o Flask também permite definir rotas dinâmicas — aquelas que recebem parâmetros diretamente na URL e os repassam para a função associada. Adicione o seguinte trecho ao seu código:

```python
@app.route('/usuario/<nome>')
def saudacao(nome):
    return f"Olá, {nome}!"
```

Com isso, ao acessar `http://127.0.0.1:8500/usuario/Jose`, o servidor retornará:

>Olá, Jose!

Esse tipo de rota é fundamental para construir APIs REST, pois permite que os dados façam parte da URL. Nos exemplos do nosso projeto Redis, utilizaremos exatamente esse padrão:

```python
@app.route('/set/<chave>/<valor>')
def set(chave, valor):
    db.set(chave, valor)
    return "OK"

@app.route('/get/<chave>')
def get(chave):
    return db.get(chave)
```
Ou seja, podemos definir `/set/nome/Klayton` e armazenar o par `nome=Klayton`, e utilizar `/get/nome` para buscar o valor associado à chave nome. 

- **Nota**: Nestes exemplos, utilizamos o método HTTP `GET` por ser o mais direto, fácil de testar no navegador e demonstrar um fluxo básico entre cliente, aplicação web e Redis. 

Em uma API REST real, entretanto, é importante utilizar o método HTTP apropriado conforme o tipo de operação. Os métodos mais comuns incluem:

- **GET**: consulta ou recuperação de recursos  
- **POST**: criação de novos recursos  
- **PUT**: substituição ou atualização completa de um recurso  
- **PATCH**: atualização parcial de um recurso (mais granular que o PUT)  
- **DELETE**: remoção de um recurso  
- **HEAD**: igual ao GET, mas sem o corpo da resposta — útil para verificação rápida de existência/headers  
- **OPTIONS**: retorna os métodos permitidos por um recurso (útil para CORS e introspecção)  
- **TRACE / CONNECT**: raramente usados, voltados a testes e tunelamento HTTP  

O uso adequado desses métodos ajuda a manter a semântica RESTful da aplicação, melhora a clareza da API e facilita a integração com outras aplicações ou sistemas front-end.

## 4. Aplicação de Cache em Tempo Real com Redis

<!--

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
-->

| Operação               | Comando Redis | Uso típico em Flask          |  
|------------------------|---------------|------------------------------|  
| Cache de tempo limite  | `setex`       | Sessions, tokens temporários |  
| Incrementar contador   | `incr`        | Métricas, rate limiting      |  
| Filas                  | `lpush/rpop`  | Tasks assíncronas            |  

Verifique o código do serviço Flask (`app.py`) e veja alguns exemplos de utilização do Redis como cache em memória para sua aplicação:

```python
import redis
import time

# Conexão com o servidor Redis (ajuste o host e a porta conforme necessário)
db = redis.Redis(host='redis', port=6379, db=0)

# Definindo uma chave com um valor e um tempo de expiração (em segundos)
db.setex("chave", 30, "valor")

# Recuperando o valor da chave
valor = db.get("chave")
print("Valor recuperado:", valor.decode('utf-8'))  # Decodifica bytes para string
a
# Simulando um atraso para demonstrar a expiração
time.sleep(31)
valor_apos_expiracao = db.get("chave")
print("Valor após expiração:", valor_apos_expiracao)  # None (já expirado)
```

Este exemplo mostra como armazenar e recuperar dados no Redis, com um tempo de expiração definido.

### Testando sua API 

Você pode testar sua aplicação usando ferramentas de linha de comando no terminal, com o comando `curl`. Isso ajuda a simular chamadas que seriam feitas por um frontend, outro sistema ou até por ferramentas de integração.

```bash
# Contador de acessos (rota /)
curl http://localhost:5000/`

# Armazenar uma chave
curl http://localhost:5000/set/curso/Redis

# Recuperar a chave armazenada
curl http://localhost:5000/get/curso

# Interagindo com Rota dinâmica 
curl http://localhost:5000/usuario/Maria
```

## Filas de Mensagens e Processamento de Streams com Redis

Para o processamento de filas e streams, você pode usar as listas do Redis para simular uma fila de mensagens:

```python
import redis

### Conexão com o Redis
`db = redis.Redis(host='redis', port=6379, db=0)`

### Enviando mensagens para a fila
`db.lpush("fila", "mensagem 1")`
`db.lpush("fila", "mensagem 2")`

### Processando mensagens da fila
```bash
while True:
    mensagem = db.brpop("fila", 5)  # Aguarda 5 segundos por uma mensagem
    if mensagem:
        print("Mensagem recebida:", mensagem[1])
    else:
        print("Nenhuma mensagem nova.")
        break
```

Este código ilustra como enviar e receber mensagens de uma fila usando o Redis. O `brpop` é um comando bloqueante que aguarda até que uma mensagem esteja disponível na fila.

### Exemplos de Aplicações

1. Sistema de Autenticação e Sessão de Usuários
- Chave: ID da sessão do usuário ou token de autenticação.
- Valor: Dados associados à sessão do usuário, como ID do usuário, preferências, roles/permissões, etc.
- Aplicação: Armazenar e gerenciar sessões de usuário em um ambiente web, onde a velocidade de acesso e a expiração automática das sessões são cruciais.

2. Catálogo de Produtos para e-Commerce
- Chave: SKU ou ID do produto.
- Valor: Detalhes do produto, como nome, descrição, preço, informações do fornecedor.
- Aplicação: Rápido acesso aos dados dos produtos para exibição em um site de e-commerce, onde a performance é um fator importante.

3. Sistema de Gerenciamento de Configurações
- Chave: Nome da configuração (por exemplo, "limiteDeUpload", "horárioDeManutenção").
- Valor: Valor da configuração (por exemplo, "10MB", "01:00-03:00").
- Aplicação: Armazenar configurações de aplicativos ou sistemas que podem ser alteradas dinamicamente sem a necessidade de reiniciar o sistema.

4. Sistema de Cache para Resultados de Pesquisa ou Análises
- Chave: Termo da pesquisa ou parâmetros da análise.
- Valor: Resultados da pesquisa ou análise.
- Aplicação: Melhorar a performance de aplicações que realizam pesquisas frequentes ou análises complexas, armazenando os resultados para recuperação rápida.

5. Registro de Atividades ou Logs
- Chave: Identificador único do evento (como timestamp ou ID de evento).
- Valor: Detalhes do evento ou log.
- Aplicação: Rápido armazenamento e acesso a logs ou eventos para monitoramento e análise em sistemas de grande escala.

Estas são apenas algumas ideias, um banco de dados baseado em chave-valor como o Redis é extremamente versátil e pode ser adaptado para uma variedade de aplicações em diferentes domínios. 

## 5. Monitorando Operações Redis em Tempo Real

### Utilizar Logs da Aplicação Flask

Assegure-se de que o seu código Flask esteja configurado para se conectar ao Redis usando o hostname `redis`, que é o nome do serviço definido no `docker-compose.yml`. Você pode adicionar instruções de log no seu código Flask para demonstrar quando a aplicação está acessando o Redis. Por exemplo, ao buscar ou definir valores no Redis, você pode imprimir mensagens no console:

```python
from flask import Flask
import redis

app = Flask(__name__)
db = redis.Redis(host='redis', port=6379, db=0)

@app.route('/')
def hello_world():
    db.set("alguma_chave", "algum_valor")
    valor = db.get("alguma_chave")
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

## Interação via API e CLI

Outra forma eficaz de demonstrar é criar rotas Flask específicas para diferentes operações do Redis (como definir um valor, obter um valor, listar valores de uma fila, etc.) e acessar estas rotas através do navegador (usando uma ferramenta como Postman) ou `curl`. Isso permite uma interação direta e visual com a aplicação e o Redis. Para criar uma aplicação Flask interativa que demonstre diferentes operações com o Redis, você pode definir várias rotas em sua aplicação. 

```python
from flask import Flask, request
import redis

app = Flask(__name__)
r = redis.Redis(host='redis', port=6379, db=0)

@app.route('/set/<chave>/<valor>')
def set_valor(chave, valor):
    db.set(chave, valor)
    return f'Valor {valor} foi armazenado com a chave {chave}'

@app.route('/get/<chave>')
def get_valor(chave):
    valor = db.get(chave)
    if valor:
        return f'Valor recuperado: {valor.decode("utf-8")}'
    else:
        return 'Chave não encontrada'

@app.route('/push/<lista>/<valor>')
def push_lista(lista, valor):
    db.lpush(lista, valor)
    return f'Valor {valor} adicionado à lista {lista}'

@app.route('/pop/<lista>')
def pop_lista(lista):
    valor = db.lpop(lista)
    if valor:
        return f'Valor retirado da lista {lista}: {valor.decode("utf-8")}'
    else:
        return f'Lista {lista} está vazia ou não existe'

@app.route('/listar/<lista>')
def listar_valores(lista):
    valores = db.lrange(lista, 0, -1)
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

Se você quiser automatizar a inserção de dados em lote, pode usar o shell script abaixo para ler pares chave-valor de um arquivo .csv e enviar para o Redis via curl. Suponha que você tenha um arquivo chamado `dados.txt`, onde cada linha contém um par chave-valor separado por vírgula. Você pode usar um script para ler este arquivo e enviar cada par chave-valor para o Redis usando `curl`: 

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



---

## Comparando Respostas com e sem Redis

Para visualizar a diferença entre uma rota que utiliza Redis e outra que não utiliza, adicionamos o tempo de resposta em cada rota. 
<!--Isso permite observar que, mesmo sendo muito rápido, o Redis ainda realiza uma operação extra de rede + acesso à memória.-->

### Exemplo de código:

```python
import time

@app.route('/')
def hello():
    start = time.time()
    count = db.incr('hits')
    elapsed = time.time() - start
    return f'Hello World! I have been seen {count} times.\nTempo de resposta: {elapsed:.6f} segundos'

@app.route('/sem-redis')
def hellow():
    start = time.time()
    response = 'Hello World! I have been seen times.'
    elapsed = time.time() - start
    return f'{response}\nTempo de resposta: {elapsed:.6f} segundos'
```

---

## Cache Real com Redis: Implementação da Série de Fibonacci

Uma das formas mais poderosas de usar Redis é armazenar resultados de cálculos pesados para não precisar refazê-los. Abaixo, criamos duas rotas: uma que calcula Fibonacci de forma tradicional e outra que usa Redis para cachear os resultados.

### Código:

```python
def fib(n):
    if n <= 1:
        return n
    return fib(n-1) + fib(n-2)

@app.route('/fib/<int:n>')
def fib_sem_cache(n):
    start = time.time()
    resultado = fib(n)
    elapsed = time.time() - start
    return f'[SEM CACHE] Fibonacci({n}) = {resultado} (tempo: {elapsed:.4f} segundos)'

@app.route('/fib-cache/<int:n>')
def fib_com_cache(n):
    start = time.time()

    cache_key = f"fib:{n}"
    if db.exists(cache_key):
        resultado = int(db.get(cache_key))
        source = "Redis (cache)"
    else:
        resultado = fib(n)
        db.set(cache_key, resultado)
        source = "calculado e salvo no Redis"

    elapsed = time.time() - start
    return f'[COM CACHE] Fibonacci({n}) = {resultado} ({source}) (tempo: {elapsed:.4f} segundos)'
```

### Cache com Expiração

Para adicionar uma expiração automática ao valor armazenado, use `setex()` em vez de `set()`:

```python
db.setex(cache_key, 60, resultado)  # cache expira em 60 segundos
```

---

### Teste prático:

O Redis **pode acelerar aplicações** ao evitar recomputações, o que é extremamente válido em sistemas com alta carga ou chamadas repetidas.

- Acesse `http://localhost:5000/fib/30` (sem cache, deve ser mais lento)
- Acesse `http://localhost:5000/fib-cache/30` (no primeiro acesso calcula, no segundo acesso deve ser praticamente instantâneo)

---

## Conclusão

Exploramos o Redis como uma solução para armazenamento em memória, aplicações diretas em cache, filas de mensagens e integração com APIs em Flask. Pudemos observar como o Redis pode acelerar operações repetitivas, simplificar a comunicação entre partes da aplicação e reduzir o tempo de resposta de forma significativa. Também visualizamos a diferença de desempenho entre chamadas com e sem cache, utilizando um exemplo clássico de cálculo recursivo, além do uso do Redis CLI e da implementação de scripts automatizados acionados via HTTP com `curl`. 

