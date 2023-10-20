### Atividade 01 - Configuração do Ambiente e Verificação do Jupyter Notebook com Spark

**Objetivo**: Garantir que você tenha configurado corretamente o ambiente do laboratório para o curso. Você deve ser capaz de executar um contêiner Jupyter Notebook com Spark e acessá-lo.

## Instruções:

### Preparação do Ambiente:

Se estiver usando uma VM: Certifique-se de que a VM está funcionando corretamente e que você pode acessá-la via SSH. Use as instruções fornecidas no README.md.
Se estiver usando Docker diretamente em sua máquina: Certifique-se de ter o Docker e o Docker Compose instalados.
Se estiver usando WSL (Windows Subsystem for Linux): Certifique-se de ter a versão 2 do WSL, Docker e Docker Compose instalados.
Clonando o Repositório:

Em seu terminal ou console, execute o seguinte comando para clonar o repositório:
```bash
git clone https://github.com/klaytoncastro/idp-bigdata
```

Executando o Jupyter Notebook com Spark:

Navegue até a subpasta jupyter-spark dentro do diretório clonado:
bash
Copy code
cd idp-bigdata/jupyter-spark
Construa e execute os serviços usando o Docker Compose:
bash
Copy code
docker-compose build
docker-compose up -d
Verificando o Token do Jupyter Notebook:

Execute o comando a seguir para visualizar os logs e identificar o token do Jupyter Notebook:
bash
Copy code
docker-compose logs
Acesso ao Jupyter Notebook:

Com o token identificado no passo anterior, acesse o Jupyter Notebook em seu navegador usando o link: http://localhost:8888/?token=SEU_TOKEN_AQUI.
Entrega:

Print do terminal com o resultado do comando docker-compose logs, mostrando o token do Jupyter Notebook.
Print da tela inicial do Jupyter Notebook com Spark, após o acesso com o token.

from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["salesDB"]
collection = db["transactions"]

# Dados de exemplo
data = [
    {"product": "Laptop", "price": 1000, "quantity": 5},
    {"product": "Mouse", "price": 20, "quantity": 40},
    {"product": "Monitor", "price": 150, "quantity": 10},
    {"product": "Keyboard", "price": 50, "quantity": 25}
]

collection.insert_many(data)

--- 


from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("MongoDBIntegration") \
    .config("spark.mongodb.input.uri", "mongodb://localhost:27017/salesDB.transactions") \
    .getOrCreate()

df = spark.read.format("mongo").load()
df.show()

---

from pymongo import MongoClient

# Conectando com autenticação
client = MongoClient("mongodb://username:password@localhost:27017/")


---

from pyspark.sql.functions import col

df.withColumn("total_revenue", col("price") * col("quantity")) \
  .orderBy("total_revenue", ascending=False) \
  .select("product", "total_revenue") \
  .show(1)

--- 

df.withColumn("total_revenue", col("price") * col("quantity")) \
  .groupBy("product") \
  .agg({"total_revenue": "avg"}) \
  .show()

--- graphs

pandas_df = df.toPandas()

---

import seaborn as sns
import matplotlib.pyplot as plt

plt.figure(figsize=(10, 6))
sns.barplot(x='product', y='quantity', data=pandas_df)
plt.title('Quantidade Vendida por Produto')
plt.show()

---

pandas_df['total_revenue'] = pandas_df['price'] * pandas_df['quantity']

plt.figure(figsize=(10, 6))
sns.barplot(x='product', y='total_revenue', data=pandas_df)
plt.title('Receita Total por Produto')
plt.show()

---

plt.figure(figsize=(10, 6))
sns.boxplot(x='product', y='price', data=pandas_df)
plt.title('Distribuição de Preços por Produto')
plt.show()

--- 


import random
from datetime import datetime, timedelta

client = MongoClient("mongodb://localhost:27017/")
db = client["salesDB"]
collection = db["transactions"]

# Dados de exemplo ampliados
products = ["Laptop", "Mouse", "Monitor", "Keyboard", "Headphones", "Smartphone", "Tablet", "Printer", "Charger", "Webcam"]
prices = [1000, 20, 150, 50, 60, 800, 250, 100, 15, 70]

data = []

for _ in range(1000):  # Criando 1000 registros
    date = datetime.now() - timedelta(days=random.randint(0, 365))  # Data aleatória no último ano
    product_index = random.randint(0, len(products) - 1)
    
    transaction = {
        "product": products[product_index],
        "price": prices[product_index],
        "quantity": random.randint(1, 50),  # Quantidade aleatória entre 1 e 50
        "date": date
    }
    
    data.append(transaction)

collection.insert_many(data)

--- ampliado v2

import random
from datetime import datetime, timedelta

client = MongoClient("mongodb://localhost:27017/")
db = client["salesDB"]
collection = db["daily_sales"]

# Produtos do dia a dia
products = [
    "Leite", "Pão", "Ovos", "Macarrão", "Arroz", "Feijão", "Refrigerante", 
    "Sabão em pó", "Shampoo", "Pasta de dente", "Sabonete", "Água mineral"
]
prices = [3, 2, 5, 4, 3, 4, 3, 10, 7, 2, 1, 1]

data = []

for _ in range(500):  # Criando 500 registros
    date = datetime.now() - timedelta(days=random.randint(0, 60))  # Data aleatória nos últimos 2 meses
    product_index = random.randint(0, len(products) - 1)
    
    transaction = {
        "product": products[product_index],
        "price": prices[product_index],
        "quantity": random.randint(1, 10),  # Quantidade aleatória entre 1 e 10
        "date": date
    }
    
    data.append(transaction)

collection.insert_many(data)

