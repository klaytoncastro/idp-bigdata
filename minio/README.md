# Introdução ao Armazenamento de Objetos

## Índice
1. [O que é Armazenamento de Objetos](#o-que-é-armazenamento-de-objetos)
2. [Conceitos do MinIO](#conceitos-do-minio)
3. [Introdução ao S3 (Simple Storage Service)](#introdução-ao-s3-simple-storage-service)
4. [Configuração do MinIO com Docker](#configuração-do-minio-com-docker)
5. [Uso da API para Leitura e Gravação de Arquivos](#uso-da-api-para-leitura-e-gravação-de-arquivos)
6. [Exemplos Práticos](#exemplos-práticos)

## O que é Armazenamento de Objetos

O armazenamento de objetos é um método baseado em uso de APIs para armazenar e recuperar arquivos em um repositório que trata cada entidade como um objeto que encapsula o próprio arquivo e seus metadados. Essa abordagem é bastante adequada a cenários de aplicações baseadas em nuvem, por ser agnóstica à infraestrutura subjacente. Ao adotar o conceito de objeto, os arquivos são armazenados em um repositório que pode ser acessado por uma API, ao invés de um sistema de arquivos hierárquico utilizado em protocolos de bloco (FCP, iSCSI), de rede (SMB, NFS), ou estrutura de tabelas como em bancos de dados relacionais (BLOBs).

### Principais Características
- **Imutabilidade**: Uma vez gravados, os objetos não são modificados.
- **Escalabilidade**: Capacidade de armazenar vastas quantidades de dados.
- **Metadados**: Cada objeto pode ter metadados personalizados, tornando a gestão e busca mais eficientes.
- **Endereçamento via URL**: Cada objeto é acessível através de uma URL única.

## Conceitos do MinIO

MinIO é uma solução de armazenamento de objetos de alto desempenho compatível com Amazon S3. É projetado para aplicações de grande escala e pode ser usado tanto em infraestruturas de nuvem quanto em ambientes on-premises.

### Benefícios do MinIO
- **Compatibilidade com S3**: Totalmente compatível com a API S3 da AWS.
- **Alto Desempenho**: Ideal para workloads intensivos em dados.
- **Facilidade de Uso**: Interface web intuitiva e fácil configuração.
- **Segurança**: Suporte para criptografia em repouso e em trânsito.

## Introdução ao S3 (Simple Storage Service)

Amazon S3 é um serviço de armazenamento de objetos da Amazon Web Services (AWS), projetado para armazenar e recuperar qualquer quantidade de dados de qualquer lugar na internet.

### Funcionamento do S3
- **Buckets**: Contêineres onde os objetos são armazenados.
- **Objetos**: Unidades de dados que são armazenadas nos buckets.
- **Chaves**: Identificadores únicos para cada objeto dentro de um bucket.
- **Metadados**: Informações adicionais armazenadas com cada objeto.

### Operações Comuns com S3
- **PUT**: Adicionar ou substituir um objeto em um bucket.
- **GET**: Recuperar um objeto de um bucket.
- **DELETE**: Remover um objeto de um bucket.
- **LIST**: Listar objetos em um bucket.

## Configuração do MinIO com Docker

Para configurar e iniciar um servidor MinIO usando Docker, siga as etapas abaixo.

### Pré-requisitos
- Docker e Docker Compose instalados.

### docker-compose.yml

```yaml
version: '3.7'

services:
  minio:
    image: minio/minio
    container_name: minio
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    volumes:
      - minio-data:/data
    command: server /data --console-address ":9001"

volumes:
  minio-data:
```

## Uso da API para Leitura e Gravação de Arquivos

MinIO suporta a API S3, permitindo operações de leitura e gravação de arquivos através de chamadas HTTP.


<!--
```python

```
-->
### Definição do Client

```python

import boto3
from botocore.client import Config

s3 = boto3.client(
    's3',
    endpoint_url='http://localhost:9000',
    aws_access_key_id='minioadmin',
    aws_secret_access_key='minioadmin',
    config=Config(signature_version='s3v4'),
    region_name='us-east-1'
)
```

### Exemplo de Gravação (PUT)

```python
# Gravar um arquivo
s3.upload_file('localfile.txt', 'meu-bucket', 'localfile.txt')
```

### Exemplo de Leitura (GET)

```python

# Ler um arquivo
s3.download_file('meu-bucket', 'localfile.txt', 'baixado_localfile.txt')

```

### Criando um Bucket

```python

s3.create_bucket(Bucket='meu-novo-bucket')

```

### Listando Objetos em um Bucket

```python

response = s3.list_objects_v2(Bucket='meu-bucket')
for obj in response.get('Contents', []):
    print(obj['Key'])


```

### Deletando um Objeto

```python

s3.delete_object(Bucket='meu-bucket', Key='localfile.txt')

```

## Conclusão

Para maiores informações, consulte a documentação oficial do [MinIO](https://min.io/docs/).