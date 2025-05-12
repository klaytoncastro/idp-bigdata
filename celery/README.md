# Lab: Mensageria e Tarefas Assíncronas com Redis, RabbitMQ e Celery

## 1. Visão Geral

Neste laboratório, você irá explorar diferentes formas de realizar comunicação assíncrona entre componentes de um sistema, utilizando:

* Redis como **broker simples** de mensagens e pub/sub
* RabbitMQ como **broker robusto**, com fila persistente
* Celery como **orquestrador de tarefas assíncronas**, com suporte a Redis e RabbitMQ
* Python, com a biblioteca Pika como **cliente nativo do protocolo AMQP** para RabbitMQ

## 2. Objetivo

Comparar diferentes abordagens de mensageria e processamento assíncrono:

* Redis  (pub/sub e lista como fila)
* RabbitMQ com biblioteca Python (produtor e consumidor)
* Celery com Redis e RabbitMQ
* Celery com encadeamento de tarefas (chain)

## 3. Arquitetura

```bash
lab-mensageria/
├── docker-compose.yml        # Orquestração dos containers
├── app.py                    # App Flask com endpoints para teste
├── celery_redis.py           # Worker Celery com Redis
├── celery_rabbit.py          # Worker Celery com RabbitMQ
├── pika/                     # Produtor e consumidor com Pika
│   ├── producer.py
│   └── consumer.py
└── requirements.txt          # flask, redis, celery, pika
```

## 4. Subindo os containers

```bash
docker compose up -d --build
```

* Flask: [http://localhost:5000](http://localhost:5000)
* RabbitMQ UI: [http://localhost:15672](http://localhost:15672) (guest/guest)
* Redis: porta 6379 (sem GUI)

## 5. Pub/Sub com Redis puro (sem Celery)

```bash
# Terminal 1
redis-cli
> SUBSCRIBE canal

# Terminal 2
redis-cli
> PUBLISH canal "mensagem teste"
```

## 6. RabbitMQ com a biblioteca Python

### Produtor

```python
# producer.py
import pika
conn = pika.BlockingConnection(pika.ConnectionParameters('rabbitmq'))
ch = conn.channel()
ch.queue_declare(queue='fila_demo')
ch.basic_publish(exchange='', routing_key='fila_demo', body='mensagem via lib pika')
conn.close()
```

### Consumidor

```python
# consumer.py
import pika
conn = pika.BlockingConnection(pika.ConnectionParameters('rabbitmq'))
ch = conn.channel()
ch.queue_declare(queue='fila_demo')
def callback(ch, method, props, body):
    print("Recebido:", body.decode())
ch.basic_consume(queue='fila_demo', on_message_callback=callback, auto_ack=True)
print("Aguardando mensagens...")
ch.start_consuming()
```

Execute:

```bash
python pika/consumer.py
python pika/producer.py
```

## 7. Testes iniciais com Celery

```bash
curl -X POST http://localhost:5000/soma_redis -H "Content-Type: application/json" -d '{"x": 2, "y": 3}'
curl -X POST http://localhost:5000/soma_rabbit -H "Content-Type: application/json" -d '{"x": 5, "y": 7}'
```

Verifique os logs dos workers:

```bash
docker logs -f celery-worker-redis
docker logs -f celery-worker-rabbit
```

## 8. Encadeamento de Tarefas com Celery

Adicione no `celery_redis.py`:

```python
@celery_redis.task
def dobrar(x): return x * 2

@celery_redis.task
def somar_dois(y): return y + 2
```

Adicione no `app.py`:

```python
from celery import chain
@app.route('/encadeado', methods=['POST'])
def encadeado():
    dados = request.json
    x = dados.get('x')
    fluxo = chain(dobrar.s(x), somar_dois.s())
    result = fluxo()
    return jsonify({'task_id': result.id}), 202
```

Teste:

```bash
curl -X POST http://localhost:5000/encadeado -H "Content-Type: application/json" -d '{"x": 5}'
```

## Conclusão

Este laboratório apresentou diferentes abordagens para a execução de tarefas assíncronas, fundamentais em aplicações web modernas e pipelines de Big Data. Ferramentas como Redis e RabbitMQ são amplamente utilizadas no mercado por sua leveza, simplicidade e eficiência em cenários específicos. O uso do Celery — embora não seja obrigatório — agrega uma camada poderosa de orquestração, monitoramento e escalabilidade, permitindo o encadeamento de tarefas, gestão de filas, retries automáticos, e a possibilidade de integração com ferramentas como o Flower, que permite a visualização e controle em tempo real dos workers e tarefas. 