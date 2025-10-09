# Use a imagem base do Jupyter Notebook
FROM jupyter/base-notebook:latest

# Defina as variáveis de ambiente para o Spark
ENV SPARK_VERSION=3.5.7 \
    HADOOP_VERSION=3 \
    SPARK_HOME=/usr/local/spark \
    PATH=/usr/local/spark/bin:$PATH

# Altera para o usuário root para instalar as dependências
USER root

# Instale as dependências necessárias, baixe e instale o Spark
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-11-jdk wget && \
    wget --no-check-certificate https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -O /tmp/spark.tgz && \
    tar xzvf /tmp/spark.tgz -C /usr/local/ && \
    mv /usr/local/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION $SPARK_HOME && \
    rm /tmp/spark.tgz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instale as bibliotecas Python necessárias
RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org \
    pyspark==${SPARK_VERSION} pandas seaborn matplotlib scikit-learn scikit-optimize xgboost lightgbm joblib \
    pymongo cassandra-driver boto3

# Baixe os JARs do S3 (Hadoop AWS, AWS SDK), Spark-Cassandra Connector e MongoDB Connector
RUN wget -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar -P /usr/local/spark/jars/ && \
    wget -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.828/aws-java-sdk-bundle-1.11.828.jar -P /usr/local/spark/jars/ && \
    wget -q https://repo1.maven.org/maven2/com/datastax/spark/spark-cassandra-connector_2.12/3.0.0/spark-cassandra-connector_2.12-3.0.0.jar -P /usr/local/spark/jars/ && \
    wget -q https://repo1.maven.org/maven2/org/mongodb/spark/mongo-spark-connector_2.12/3.0.0/mongo-spark-connector_2.12-3.0.0.jar -P /usr/local/spark/jars/

# Instale o MinIO Client (mc)
RUN wget --no-check-certificate https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc && \

# Defina o usuário padrão do Jupyter como root para evitar erros de elevação de permissões no Jupyter
RUN echo "jovyan ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jovyan

# Troque para o usuário padrão do Jupyter
USER jovyan

# Configure o diretório de trabalho padrão para os notebooks
WORKDIR /home/jovyan/work
