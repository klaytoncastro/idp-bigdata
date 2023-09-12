# Utilize a imagem oficial do Jupyter Notebook base
FROM jupyter/base-notebook:latest

# Define variáveis de ambiente para o Spark
ENV SPARK_VERSION=3.2.4
ENV HADOOP_VERSION=3.2
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$SPARK_HOME/bin:$PATH

USER root

# Instale as dependências necessárias
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Baixe e instale o Spark
RUN wget https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -O /tmp/spark.tgz && \
    tar xzvf /tmp/spark.tgz -C /usr/local/ && \
    mv /usr/local/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION $SPARK_HOME && \
    rm /tmp/spark.tgz

# Instale as bibliotecas Python necessárias
RUN pip install pyspark==${SPARK_VERSION}

# Troque para o usuário jovyan (default no Jupyter Docker)
USER $NB_UID

# Configure o diretório de trabalho padrão para os notebooks
WORKDIR /home/jovyan/work

