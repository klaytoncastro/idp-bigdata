# Apache Spark

## Introdução

O Apache Spark é um framework open-source, compatível com Hadoop, e bastante expressivo para realizar tarefas de processamento distribuído de dados massivos. Possui módulos integrados para o agendamento dos jobs, streaming de dados (fluxos em tempo real), consultas SQL, modelos de aprendizado de máquina e visualização de dados. 

## Arquitetura

O Apache Spark é construído sobre componentes que atuam de maneira coordenada para disponibilizar o processamento distribuído e escalável de dados. Sua arquitetura é do tipo master/slave, onde o nó mestre é responsável por agendar e distribuir a execução das tarefas, e os nós slaves (workers) realizam estas tarefas e lidam com os mecanismos necessários para armazenamento e processamento dos dados. 

### Componentes Principais

- **Driver**: É o ponto de entrada, o programa para uma aplicação Spark. O driver define o contexto de execução e das RDDs, bem como estabelece suas ações e transformações.

- **Cluster Manager**: Gere os recursos em todo o cluster, podendo empregar o Spark standalone, YARN (Haddop), ou Apache Mesos nesta função.

- **Worker Nodes**: Nós que executam as tarefas de processamento de dados. Cada nó trabalhador hospeda um ou mais executores.

- **Executors**: Processos que executam as tarefas e armazenam os dados em cache. Cada aplicação Spark possui seus próprios executores.

- **Tasks**: Unidades de trabalho que são enviadas para os executores pelo driver.

### Conceitos Chave

- **RDDs (Resilient Distributed Datasets)**: São coleções distribuídas imutáveis ​​de dados que são particionadas entre máquinas em um cluster.

- **Transformação**: São operações realizadas em um RDD, tais como: `filter()`, `map()` ou `union()`, cuja saída é outro RDD.

- **Ação**: São operações que acionam um cálculo, tais como `count()`, `first()`, `take(n)` ou `collect()`.

- **Partição**: É uma divisão lógica de dados armazenados em um nó de um cluster.

### Bibliotecas Integradas

- **Spark SQL**: É um módulo Spark que permite trabalhar com estruturas dados. A consulta de dados é suportada no formato SQL ou HQL (Hive / Hadoop). 

- **Spark Streaming**: É usado para construir aplicações escaláveis em modo streaming (tempo real) com tolerância à falhas. 

- **Mlib**: É uma biblioteca escalável de aprendizado de máquina e fornece vários algoritmos para classificação, regressão, clustering, dentre outros. 

- **GraphX**: É uma API para geração de gráficos estáticos. 

### PySpark

Para usar o Spark com a linguagem Python, temos  PySpar, uma biblioteca que fornece uma API de alto nível para acessar, processar e analisar dados. A interface do PySpark expõe o modelo de programação Spark a um ambiente suportado por Python e viabiliza sua rápida utilização por meio de uma IDE como o Jupyter. 

O PySpark oferece transformações e ações em RDDs (Resilient Distributed Datasets) e DataFrames, que são abstrações para trabalhar com dados distribuídos, enquanto a configuração Spark, seu modo de operação e integrações ocorrem na infraestrutura subjacente. 

## Atividade

Construa o contêiner do Spark e acesse a IDE Jupyter.
(`http://localhost:8889`). Alteramos a porta para `8889` para evitar conflitos com a instância do Jupyter sem Spark. 

```bash
cd /opt/idp-bigdata/spark
docker-compose up -d --build
```
Caso seja o seu primeiro acesso a esta instância do Jupyter, lembre-se de executar o comando a seguir para visualizar os logs e identificar o token para obter acesso à IDE: 

```bash
docker-compose logs | grep 'token='
```

### Configuração da rede para comunicação com outros contêineres

Para permitir a comunicação entre os contêineres de outros serviços de Big Data e NoSQL, verifique o arquivo `docker-compose.yml`, que deve estar atualizado para conectá-los à rede `mybridge`. 

```yaml
# Definindo as redes que serão usadas pelos serviços.
    networks:
      - mybridge # Nome da rede que será usada.

# Configuração das redes que serão usadas no docker-compose.
networks:
  mybridge: # Nome da rede.
    external: # Indica que a rede é externa e já foi criada anteriormente.
      name: mybridge # Nome da rede externa que será usada.
```

Caso não tenha criado, implemente a rede virtual `mybridge` no Docker: 

```bash
docker network create --driver bridge mybridge
```
### Inicialize e teste o Spark

a) Quando o Apache Spark está em execução, ele disponibiliza uma interface web para viabilizar o acompanhamento das tarefas designadas por sua aplicação. A Spark Application UI (`http://localhost:4040`) só se tornará disponível após a inicialização de uma sessão Spark por uma aplicação. 

b) Para isso, crie um notebook no Jupyter e teste o ambiente inicializando uma sessão Spark com os comandos abaixo: 

```python
# Importando as bibliotecas
from pyspark.sql import SparkSession

# Inicializando a sessão
spark = SparkSession.builder \
    .appName("spark") \
    .master("local") \
    .getOrCreate()

# Definindo o nível do log
spark.sparkContext.setLogLevel("ERROR")

# Obtendo o SparkContext da SparkSession
sc = spark.sparkContext

# Imprimindo as informações do SparkContext
print("Spark version:", sc.version)
print("Python version:", sc.pythonVer)
print("Master URL:", sc.master)
print("Spark home:", str(sc.sparkHome))
print("Spark user:", str(sc.sparkUser()))
print("Application name:", sc.appName)
print("Application ID:", sc.applicationId)
print("Default parallelism:", sc.defaultParallelism)
print("Default minimum partitions:", sc.defaultMinPartitions)
```

<!--
from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()

# Análise de Dados com PySpark 

O Apache Spark é um framework open-source para processamento distribuído de dados em larga escala. O PySpark é uma biblioteca Python para usar o Spark, que fornece uma API de alto nível para processar dados de maneira eficiente. O PySpark oferece suporte a transformações e ações em RDDs (Resilient Distributed Datasets) e DataFrames, que são abstrações para trabalhar com dados distribuídos. 

## 1. Ambientando-se ao PySpark

[Tutorial Básico](https://www.kaggle.com/code/nilaychauhan/pyspark-tutorial-for-beginners)

## 2. Usando Spark para realizar uma análise a partir do dataset que importamos para o MongoDB. 

a) No Jupyter, crie um novo notebook Python 3 (ipykernel) e insira o seguinte código para criar uma sessão Spark:

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Análise de Dados do Censo da Educação Superior") \
    .config("spark.mongodb.input.uri", "mongodb://172.22.0.3:27017/inep.ies") \
    .getOrCreate()
```
b) Carregue os dados do MongoDB para um DataFrame Spark:

```python
df = spark.read.format("com.mongodb.spark.sql.DefaultSource").load()
```
c) Realize análises e transformações nos dados para se habituar com as funcionalidades do PySpark. Por exemplo, para contar o número de instituições de ensino superior por estado:

```python
df.groupBy("UF").count().show()
```

d) Quando terminar a análise, lembre-se de encerrar a sessão Spark:

```python
spark.stop()
```
-->

c) Em outra aba, acesse a URL da [Spark Application UI](http://localhost:4040) e observe que agora ela está disponível. 

d) Execute o código abaixo em seu notebook Jupyter para encerrar sua sessão Spark: 

```python
spark.stop()
```

e) Atualize o navegador e observe que a interface http://localhost:4040 não estará mais acessível após encerrarmos a sessão. 

<!--
https://www.datacamp.com/cheat-sheet/pyspark-cheat-sheet-spark-dataframes-in-python

https://images.datacamp.com/image/upload/v1676302905/Marketing/Blog/PySpark_SQL_Cheat_Sheet.pdf

https://intellipaat.com/blog/tutorial/spark-tutorial/spark-and-rdd-cheat-sheet/

https://intellipaat.com/mediaFiles/2019/03/Spark-_-RDD-CS-DESIGN.pdf

https://stanford.edu/~rezab/dao/notes/L11/spark_cheat_sheet.pdf

https://www.google.com/search?q=spark+commands+cheat+sheet&rlz=1C5CHFA_enBR894BR894&oq=spark+commands+&gs_lcrp=EgZjaHJvbWUqCQgBEAAYExiABDIMCAAQRRgTGBYYHhg5MgkIARAAGBMYgAQyCQgCEAAYExiABDIJCAMQABgTGIAEMgkIBBAAGBMYgAQyCggFEAAYExgWGB4yCggGEAAYExgWGB4yCggHEAAYExgWGB4yCggIEAAYExgWGB4yCggJEAAYExgWGB7SAQg2MjQwajBqN6gCALACAA&sourceid=chrome&ie=UTF-8
-->