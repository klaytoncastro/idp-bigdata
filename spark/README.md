
Para permitir a comunicação entre os contêineres, o arquivo `docker-compose.yml` deve ser atualizado para conectá-los à rede `mybridge`. 

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

a) Quando o Apache Spark está em execução, ele disponibiliza uma interface web para viabilizar o acompanhamento das tarefas designadas por sua aplicação. A Spark Application UI (`http://localhost:4040`) só se tornará disponível após a inicialização de uma sessão Spark por uma aplicação. Crie um notebook Python 3 (ipykernel), e teste seu ambiente inicializando uma sessão Spark: 

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()
```
b) Em seu navegador, acesse a URL da [Spark Application UI](http://localhost:4040) e observe que agora ela está disponível. Execute o código abaixo em seu notebook Jupyter para encerrar sua sessão Spark: 

```python
spark.stop()
```
c) Atualize o navegador e observe que a interface http://localhost:4040 não estará mais acessível após encerrarmos a sessão. 