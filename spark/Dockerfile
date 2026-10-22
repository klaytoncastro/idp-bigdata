
# Jupyter Notebook - Python 3.11
# Imagem compatível com AMD64 e ARM64
FROM quay.io/jupyter/base-notebook:python-3.11

ARG SPARK_VERSION=3.5.8
ARG TARGETARCH
ARG MC_VERSION=RELEASE.2025-08-13T08-35-41Z

ENV HADOOP_VERSION=3 \
    SPARK_HOME=/usr/local/spark \
    JAVA_HOME=/opt/java-home \
    PATH=/usr/local/spark/bin:$PATH

USER root

# ------------------------------------------------------------
# 1. Dependências do sistema e Java 17
# ------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-17-jdk-headless \
        wget \
        curl \
        ca-certificates && \
    ln -s "$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")" /opt/java-home && \
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# 2. Apache Spark 3.5.8 - distribuição oficial
# ------------------------------------------------------------
RUN set -eux; \
    SPARK_PACKAGE="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"; \
    SPARK_URL="https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}"; \
    curl -fL "${SPARK_URL}/${SPARK_PACKAGE}.tgz" -o /tmp/spark.tgz; \
    curl -fL "${SPARK_URL}/${SPARK_PACKAGE}.tgz.sha512" -o /tmp/spark.sha512; \
    HASH="$(grep -Eo '[0-9a-fA-F]{128}' /tmp/spark.sha512 | head -n 1)"; \
    test -n "$HASH"; \
    echo "$HASH  /tmp/spark.tgz" | sha512sum -c -; \
    tar -xzf /tmp/spark.tgz -C /usr/local/; \
    mv "/usr/local/${SPARK_PACKAGE}" "$SPARK_HOME"; \
    rm -f /tmp/spark.tgz /tmp/spark.sha512

# ------------------------------------------------------------
# 3. Dependências Java via Maven/Ivy
# ------------------------------------------------------------
# Compatibilidade:
# Spark 3.5.8 / Scala 2.12 / Hadoop 3.3.4
# Delta Lake 3.2.1
# Cassandra Connector 3.5.1
# MongoDB Connector 10.7.0

RUN mkdir -p "${SPARK_HOME}/conf" && \
    printf '%s\n' \
    'spark.jars.packages org.apache.hadoop:hadoop-aws:3.3.4,com.datastax.spark:spark-cassandra-connector_2.12:3.5.1,org.mongodb.spark:mongo-spark-connector_2.12:10.7.0,org.apache.spark:spark-avro_2.12:3.5.8,io.delta:delta-spark_2.12:3.2.1' \
    'spark.sql.extensions io.delta.sql.DeltaSparkSessionExtension' \
    'spark.sql.catalog.spark_catalog org.apache.spark.sql.delta.catalog.DeltaCatalog' \
    > "${SPARK_HOME}/conf/spark-defaults.conf"

# ------------------------------------------------------------
# 4. MinIO Client (mc) - release comunitária fixa
# ------------------------------------------------------------
RUN set -eux; \
    MC_FILE="mc.linux-${TARGETARCH}.${MC_VERSION}"; \
    MC_URL="https://github.com/minio/mc/releases/download/${MC_VERSION}"; \
    curl -fL "${MC_URL}/${MC_FILE}" -o "/tmp/${MC_FILE}"; \
    curl -fL "${MC_URL}/${MC_FILE}.sha256sum" -o /tmp/mc.sha256sum; \
    HASH="$(cut -c1-64 /tmp/mc.sha256sum)"; \
    echo "$HASH  /tmp/${MC_FILE}" | sha256sum -c -; \
    mv "/tmp/${MC_FILE}" /usr/local/bin/mc; \
    chmod +x /usr/local/bin/mc; \
    rm -f /tmp/mc.sha256sum; \
    mc --version

# ------------------------------------------------------------
# 5. Bibliotecas Python
# ------------------------------------------------------------
USER jovyan

RUN pip install --no-cache-dir \
    "pyspark==3.5.8" \
    "delta-spark==3.2.1" \
    "pandas<3" \
    "numpy<2" \
    seaborn \
    matplotlib \
    pymongo \
    cassandra-driver \
    boto3

WORKDIR /home/jovyan/work

############# LATEST STABLE
# Use a imagem base do Jupyter Notebook
#FROM jupyter/base-notebook:latest

# Define variáveis de ambiente para o Spark
#ENV SPARK_VERSION=3.5.8 \
#    HADOOP_VERSION=3 \
#    SPARK_HOME=/usr/local/spark \
#    PATH=/usr/local/spark/bin:$PATH

# Altera para o usuário root para instalar as dependências
#USER root

# Instala as dependências necessárias e baixa/instala o Spark
#RUN apt-get update && \
#    apt-get install -y --no-install-recommends openjdk-11-jdk wget curl && \
#    wget --no-check-certificate https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -O /tmp/spark.tgz && \
#    tar xzvf /tmp/spark.tgz -C /usr/local/ && \
#    mv /usr/local/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION $SPARK_HOME && \
#    rm /tmp/spark.tgz && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*

# Instala as bibliotecas Python necessárias
#RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org \
#    pyspark==${SPARK_VERSION} pandas seaborn matplotlib pymongo cassandra-driver boto3 delta-spark==3.2.1
# scikit-learn scikit-optimize xgboost lightgbm joblib pycaret

# Baixa os JARs do S3 (Hadoop AWS, AWS SDK), Spark-Cassandra Connector, MongoDB Connector, Delta Lake
#RUN wget -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar -P /usr/local/spark/jars/ && \
#    wget -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.828/aws-java-sdk-bundle-1.11.828.jar -P /usr/local/spark/jars/ && \
#    wget -q https://repo1.maven.org/maven2/com/datastax/spark/spark-cassandra-connector_2.12/3.0.0/spark-cassandra-connector_2.12-3.0.0.jar -P /usr/local/spark/jars/ && \
#    wget -q https://repo1.maven.org/maven2/org/mongodb/spark/mongo-spark-connector_2.12/3.0.0/mongo-spark-connector_2.12-3.0.0.jar -P /usr/local/spark/jars/

# Baixa os JARs compatíveis com Spark 3.5.x / Hadoop 3.3.x
#RUN wget --no-check-certificate -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar -P /usr/local/spark/jars/ && \
#    wget --no-check-certificate -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar -P /usr/local/spark/jars/ && \
#    wget --no-check-certificate -q https://repo1.maven.org/maven2/com/datastax/spark/spark-cassandra-connector_2.12/3.5.1/spark-cassandra-connector_2.12-3.5.1.jar -P /usr/local/spark/jars/ && \
#    wget --no-check-certificate -q https://repo1.maven.org/maven2/org/mongodb/spark/mongo-spark-connector_2.12/3.0.2/mongo-spark-connector_2.12-3.0.2.jar -P /usr/local/spark/jars/ && \
#    wget --no-check-certificate -q https://repo1.maven.org/maven2/org/apache/spark/spark-avro_2.12/3.5.7/spark-avro_2.12-3.5.7.jar -P /usr/local/spark/jars/ && \
#    wget --no-check-certificate -q https://repo1.maven.org/maven2/io/delta/delta-spark_2.12/3.2.0/delta-spark_2.12-3.2.0.jar -P /usr/local/spark/jars/

# ------------------------------------------------------------
# JARs Hadoop, AWS, Cassandra, Mongo e Delta 3.2.1
# ------------------------------------------------------------
#RUN wget --no-check-certificate -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar -P /usr/local/spark/jars/ && \
#    wget --no-check-certificate -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar -P /usr/local/spark/jars/ && \
#    wget --no-check-certificate -q https://repo1.maven.org/maven2/com/datastax/spark/spark-cassandra-connector_2.12/3.5.1/spark-cassandra-connector_2.12-3.5.1.jar -P /usr/local/spark/jars/ && \
#    wget --no-check-certificate -q https://repo1.maven.org/maven2/org/mongodb/spark/mongo-spark-connector_2.12/3.0.2/mongo-spark-connector_2.12-3.0.2.jar -P /usr/local/spark/jars/ && \
#    wget --no-check-certificate -q https://repo1.maven.org/maven2/org/apache/spark/spark-avro_2.12/${SPARK_VERSION}/spark-avro_2.12-${SPARK_VERSION}.jar -P /usr/local/spark/jars/ && \
#    wget --no-check-certificate -q https://repo1.maven.org/maven2/io/delta/delta-spark_2.12/3.2.1/delta-spark_2.12-3.2.1.jar -P /usr/local/spark/jars/ && \
#    wget --no-check-certificate -q https://repo1.maven.org/maven2/io/delta/delta-storage/3.2.1/delta-storage-3.2.1.jar -P /usr/local/spark/jars/

# Instala o MinIO Client (mc) ignorando verificação de certificado (OLD RELEASE)
#RUN wget --no-check-certificate -q https://github.com/minio/mc/releases/download/RELEASE.2024-09-20T01-15-33Z/mc -O /usr/local/bin/mc && \
#RUN wget --no-check-certificate -q https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && \
#    chmod +x /usr/local/bin/mc

# MinIO Client - última release comunitária
# Suporte a Linux AMD64 e ARM64 (Docker no Mac M1)
#ARG TARGETARCH
#RUN set -eux; \
#    MC_VERSION="RELEASE.2025-08-13T08-35-41Z"; \
#    MC_FILE="mc.linux-${TARGETARCH}.${MC_VERSION}"; \
#    MC_URL="https://github.com/minio/mc/releases/download/${MC_VERSION}"; \
#    wget -q "${MC_URL}/${MC_FILE}" -O "/tmp/${MC_FILE}"; \
#    wget -q "${MC_URL}/${MC_FILE}.sha256sum" -O "/tmp/${MC_FILE}.sha256sum"; \
#    cd /tmp && sha256sum -c "${MC_FILE}.sha256sum"; \
#    mv "/tmp/${MC_FILE}" /usr/local/bin/mc; \
#    chmod +x /usr/local/bin/mc; \
#    rm -f "/tmp/${MC_FILE}.sha256sum"; \
#    mc --version

# Define o usuário padrão do Jupyter como root para evitar permissões no Jupyter
#RUN echo "jovyan ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jovyan

# Troca para o usuário padrão do Jupyter
#USER jovyan

# Configura o diretório de trabalho padrão para os notebooks
#WORKDIR /home/jovyan/work
