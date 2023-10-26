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