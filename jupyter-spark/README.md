# 1. Instruções:

a) Se estiver usando uma VM, conforme instruções fornecidas no README.md do repositório [IDP-BigData](https://github.com/klaytoncastro/idp-bigdata), certifique-se de que a VM está executando e que você pode acessá-la via SSH. 

b) Caso tenha optado por hospedar os contêineres diretamente em sua máquina, certifique-se de ter o Git, Docker e o Docker Compose corretamente instalados.  

# 2. Levante o Ambiente Jupyter Notebook configurado com Spark e Python:

### a) Em seu terminal ou console, execute o seguinte comando para clonar o repositório:

```bash
git clone https://github.com/klaytoncastro/idp-bigdata 
```
### b) Navegue até a subpasta jupyter-spark dentro do diretório clonado. Exemplo:

```bash
cd /opt/idp-bigdata/jupyter-spark 
```

### c) Execute o script para mapeamento das permissões dos volumes externos ao contêiner:

```bash
chmod +x permissions.sh
./permissions.sh
```

### d) Construa e execute os serviços usando o Docker Compose:

```bash
docker-compose build 
docker-compose up -d 
```

### e) Acesse o Jupyter Notebook:

Execute o comando a seguir para visualizar os logs e identificar o token do Jupyter Notebook para realizar o primeiro acesso: 

```bash
docker-compose logs | grep 'token='
```

### Via GUI

Com o token identificado no passo anterior, acesse o Jupyter Notebook em seu navegador usando o [link](http://localhost:8888) e configure a nova senha. 

### Via CLI

```bash
docker exec -it <nome_do_contêiner> /bin/bash
jupyter config password
```

### Inicialize e teste o Spark

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()
```

```python
spark.stop()
```
### Exemplo de uso com ferramentas externas 

Conecte-ao MongoDB, explore e analise dados. 

```bash
docker-compose down
```

```bash
docker network create --driver bridge mybridge
```

```yaml
    networks:
      - mybridge

networks:
  mybridge:
    external:
      name: mybridge
```

```bash
docker-compose up -d
```

```bash
docker network inspect mybridge
```

```python
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

try:
    client = MongoClient("mongodb://root:mongo@172.22.0.3:27017/", serverSelectionTimeoutMS=5000)
    client.server_info()  # Isso lançará uma exceção se não puder se conectar ao servidor.
    print("Conexão estabelecida com sucesso!")

except ConnectionFailure:
    print("Falha na conexão ao servidor MongoDB")
```

### Exemplos: 

[MongoDB w/ Python](https://www.kaggle.com/code/ganu1899/mongodb-with-python)

[INEP - Dados Abertos](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos)

### Limpeza de Dados e Importação

```bash
sed 's/\"//g; s/;/,/g' MICRODADOS_ED_SUP_IES_2022.CSV > MICRODADOS_ED_SUP_IES_2022_corrigido.csv

iconv -f ISO-8859-1 -t UTF-8 MICRODADOS_ED_SUP_IES_2022_corrigido.csv > MICRODADOS_ED_SUP_IES_2022_corrigido_UTF8.csv

sed -i 'y/áàãâäéèêëíìîïóòõôöúùûüçñÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ/aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN/' MICRODADOS_ED_SUP_IES_2022_corrigido_UTF8.csv

docker exec -it mongo_service mongoimport --db inep --collection ies --type csv --file /datasets/inep_censo_ies_2022/dados/MICRODADOS_ED_SUP_IES_2022_corrigido_UTF8.csv --headerline --ignoreBlanks --username root --password mongo --authenticationDatabase admin
```

```bash
sed 's/\"//g; s/;/,/g' MICRODADOS_CADASTRO_CURSOS_2022.CSV > MICRODADOS_CADASTRO_CURSOS_2022_corrigido.CSV

iconv -f ISO-8859-1 -t UTF-8 MICRODADOS_CADASTRO_CURSOS_2022_corrigido.CSV > MICRODADOS_CADASTRO_CURSOS_2022_corrigido_UTF8.CSV

sed -i 'y/áàãâäéèêëíìîïóòõôöúùûüçñÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ/aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN/' MICRODADOS_CADASTRO_CURSOS_2022_corrigido_UTF8.CSV

docker exec -it mongo_service mongoimport --db inep --collection cursos --type csv --file /datasets/inep_censo_ies_2022/dados/MICRODADOS_CADASTRO_CURSOS_2022_corrigido_UTF8.CSV --headerline --ignoreBlanks --username root --password mongo --authenticationDatabase admin
```

### Análise de Dados

```python
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

try:
    client = MongoClient("mongodb://root:mongo@172.22.0.3:27017/", serverSelectionTimeoutMS=5000)
    client.server_info()  # Isso lançará uma exceção se não puder se conectar ao servidor.
    print("Conexão estabelecida com sucesso!")

except ConnectionFailure:
    print("Falha na conexão ao servidor MongoDB")

# Selecionar o banco de dados
db = client['inep']

# Selecionar a coleção
collection = db['ies']

# Query para contar o número de instituições por região
import matplotlib.pyplot as plt

result = collection.aggregate([
    {'$group': {'_id': '$NO_REGIAO_IES', 'count': {'$sum': 1}}}
])

# Converter o resultado para listas
regions, counts = zip(*[(r['_id'], r['count']) for r in result])

# Plotar o gráfico
plt.figure(figsize=(10,5))
plt.bar(regions, counts)
plt.xlabel('Região')
plt.ylabel('Número de Instituições')
plt.title('Número de Instituições por Região')
plt.show()

# Query para calcular a proporção de docentes por gênero
result = collection.aggregate([
    {'$group': {
        '_id': None,
        'total_fem': {'$sum': '$QT_DOC_EX_FEMI'},
        'total_masc': {'$sum': '$QT_DOC_EX_MASC'}
    }}
])

# Converter o resultado para valores
result = next(result)
total_fem = result['total_fem']
total_masc = result['total_masc']

# Plotar o gráfico
labels = ['Feminino', 'Masculino']
sizes = [total_fem, total_masc]
colors = ['lightcoral', 'lightskyblue']
explode = (0.1, 0)  # explode 1st slice

plt.figure(figsize=(8,8))
plt.pie(sizes, explode=explode, labels=labels, colors=colors, autopct='%1.1f%%', shadow=True, startangle=140)
plt.axis('equal')
plt.title('Proporção de Docentes por Gênero')
plt.show()


# Query para contar o número de instituições por estado
result = collection.aggregate([
    {'$group': {'_id': '$NO_UF_IES', 'count': {'$sum': 1}}}
])

# Converter o resultado para listas
states, counts = zip(*sorted([(r['_id'], r['count']) for r in result], key=lambda x: x[1], reverse=True))

# Plotar o gráfico
plt.figure(figsize=(10,5))
plt.bar(states, counts)
plt.xlabel('Estado')
plt.ylabel('Número de Instituições')
plt.title('Número de Instituições por Estado')
plt.xticks(rotation=90)
plt.show()


# Query para calcular o número de docentes por faixa etária
result = collection.aggregate([
    {'$group': {
        '_id': None,
        '0-29': {'$sum': '$QT_DOC_EX_0_29'},
        '30-34': {'$sum': '$QT_DOC_EX_30_34'},
        '35-39': {'$sum': '$QT_DOC_EX_35_39'},
        '40-44': {'$sum': '$QT_DOC_EX_40_44'},
        '45-49': {'$sum': '$QT_DOC_EX_45_49'},
        '50-54': {'$sum': '$QT_DOC_EX_50_54'},
        '55-59': {'$sum': '$QT_DOC_EX_55_59'},
        '60+': {'$sum': '$QT_DOC_EX_60_MAIS'},
    }}
])

# Converter o resultado para valores
result = next(result)
ages = ['0-29', '30-34', '35-39', '40-44', '45-49', '50-54', '55-59', '60+']
counts = [result[age] for age in ages]

# Plotar o gráfico
plt.figure(figsize=(10,5))
plt.bar(ages, counts)
plt.xlabel('Faixa Etária')
plt.ylabel('Número de Docentes')
plt.title('Número de Docentes por Faixa Etária')
plt.show()


# Query para calcular o número de docentes por grau acadêmico
result = collection.aggregate([
    {'$group': {
        '_id': None,
        'Graduação': {'$sum': '$QT_DOC_EX_GRAD'},
        'Especialização': {'$sum': '$QT_DOC_EX_ESP'},
        'Mestrado': {'$sum': '$QT_DOC_EX_MEST'},
        'Doutorado': {'$sum': '$QT_DOC_EX_DOUT'},
    }}
])

# Converter o resultado para valores
result = next(result)
degrees = ['Graduação', 'Especialização', 'Mestrado', 'Doutorado']
counts = [result[degree] for degree in degrees]

# Plotar o gráfico
plt.figure(figsize=(10,5))
plt.pie(counts, labels=degrees, autopct='%1.1f%%', startangle=90)
plt.title('Proporção de Docentes por Grau Acadêmico')
plt.show()


# Query para calcular o número de docentes por raça/cor
result = collection.aggregate([
    {'$group': {
        '_id': None,
        'Branca': {'$sum': '$QT_DOC_EX_BRANCA'},
        'Preta': {'$sum': '$QT_DOC_EX_PRETA'},
        'Parda': {'$sum': '$QT_DOC_EX_PARDA'},
        'Amarela': {'$sum': '$QT_DOC_EX_AMARELA'},
        'Indígena': {'$sum': '$QT_DOC_EX_INDIGENA'},
        'Não declarada': {'$sum': '$QT_DOC_EX_COR_ND'},
    }}
])

# Converter o resultado para valores
result = next(result)
races = ['Branca', 'Preta', 'Parda', 'Amarela', 'Indígena', 'Não declarada']
counts = [result[race] for race in races]

# Plotar o gráfico
plt.figure(figsize=(10,5))
plt.bar(races, counts)
plt.xlabel('Raça/Cor')
plt.ylabel('Número de Docentes')
plt.title('Número de Docentes por Raça/Cor')
plt.xticks(rotation=45)
plt.show()
```
