# Simulação de Pipeline: Ingestão e Processamento de Dados em Tempo Real 

## Desafio Proposto

Nesta atividade, você deve implementar um pipeline completo de ingestão, processamento, armazenamento e visualização de dados em tempo real. O dataset utilizado será o Air Quality, e o fluxo de dados segue o padrão definido abaixo:

1. O Producer Kafka lê o dataset Air Quality e envia os dados para o tópico `sensor_raw`.
2. O Consumer Celery processa os dados recebidos:
- Armazena em Redis como cache em tempo real.
- Identifica alertas críticos (ex: `CO > 10`, `NO2 > 200`) e envia para o RabbitMQ.
- Armazena os dados brutos e processados no MinIO.

3. O Streamlit lê os dados do Redis e exibe o status dos sensores em tempo real.
4. O MinIO mantém os dados históricos, funcionando como Data Lake.

Suba os contêineres do Kafka, Redis, RabbitMQ, Celery, Minio e Streamlit, garantindo que estejam se comunicando pela rede (ex: `mybridge`) e implemente o desafio! 

<!--
## Preparação do Ambiente

1. 
2. 

### Producer  

```python
import pandas as pd
from kafka import KafkaProducer
import json
import time

# Configurar o Producer Kafka
producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Carregar o dataset
data = pd.read_csv('AirQualityUCI_Treated.csv', sep=';')

# Enviar os dados para o tópico 'sensor_raw'
for index, row in data.iterrows():
    message = {
        'date': row['Date'],
        'time': row['Time'],
        'CO': row['CO'],
        'NO2': row['NO2'],
        'Temperature': row['Temperature'],
        'Relative_Humidity': row['Relative_Humidity'],
        'Absolute_Humidity': row['Absolute_Humidity']
    }
    producer.send('sensor_raw', value=message)
    print(f"Enviado: {message}")
    time.sleep(0.5)

print("Ingestão concluída.")
```

### Consumer 

```python
from kafka import KafkaConsumer
from celery import Celery
import redis
import json
import boto3

# Configurar o Redis
redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)

# Configurar o Celery
app = Celery('tasks', broker='redis://localhost:6379/0')

# Configurar o Kafka Consumer
consumer = KafkaConsumer(
    'sensor_raw',
    bootstrap_servers='localhost:9092',
    value_deserializer=lambda x: json.loads(x.decode('utf-8'))
)

# Configurar o MinIO
s3 = boto3.client(
    's3',
    endpoint_url='http://localhost:9000',
    aws_access_key_id='minioadmin',
    aws_secret_access_key='minioadmin'
)

@app.task
def process_data(data):
    redis_client.hset(f"sensor_{data['date']}_{data['time']}", mapping=data)

    if data['CO'] > 10 or data['NO2'] > 200:
        print("Alerta Crítico! CO ou NO2 acima do limite.")

    s3.put_object(Bucket='air-quality', Key=f"{data['date']}_{data['time']}.json", Body=json.dumps(data))

# Consumir mensagens do Kafka
for message in consumer:
    process_data.delay(message.value)
```

-->