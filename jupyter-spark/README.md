# 1. Instruções:
a)    Se estiver usando uma VM, conforme instruções fornecidas no README.md do repositório [IDP-BigData](https://github.com/klaytoncastro/idp-bigdata), certifique-se de que a VM está executando e que você pode acessá-la via SSH. 
b)    Caso tenha optado por hospedar os contêineres diretamente em sua máquina, certifique-se de ter o Git, Docker e o Docker Compose corretamente instalados.  

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

### Integração com outras ferramentas

- Para conectar o seu Jupyter Notebook com Spark para operar com MongoDB e outras ferramentas, você pode usar bibliotecas e drivers específicos. Por exemplo, no caso do MongoDB, você poderia utilizar o PyMongo. Isso permite que você carregue dados diretamente do MongoDB para análise distribuída com o Spark. Essas técnicas são valiosas em ambientes de análise de dados e processamento de big data. Veremos isso em maiores detalhes nos laboratórios. 

- Para facilitar a integração, tanto do MongoDB como de outras ferramentas, tais como uma API Flask, um banco de dados MySQL e outros serviços, pode ser necessário verificar o endereço IP dos contêineres e a rede virtual na qual estão conectados. Neste caso, utilize os comandos abaixo: 

```bash
docker inspect <CONTAINER_ID> | grep IPAddress
docker network inspect <NETWORK_NAME>
```