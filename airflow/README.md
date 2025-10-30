# Orquestração de Fluxos de Trabalho e Pipelines de Dados

## Visão Geral

Orquestração refere-se ao processo de gerenciar e coordenar a execução de tarefas interdependentes em um fluxo de trabalho, garantindo que elas sejam executadas corretamente. Nesse cenário, um pipeline consiste numa série de etapas consecutivas que processam os dados de forma estruturada, garantindo que os dados sejam transformados e movidos de um sistema para outro de forma eficiente e ordenada. 

Em ambientes onde grandes volumes de dados são processados continuamente, ferramentas como o Airflow são fundamentais para implementar e automatizar tarefas complexas de ETL (Extract, Transform, Load), integração entre diferentes sistemas de armazenamento, ingestão e análise de dados, onde cada etapa do fluxo — desde a ingestão até a transformação e armazenamento deve ser organizada de maneira programática, com intuito de gerenciar, monitorar e escalonar essas operações. 

## Apache Airflow 

Apache Airflow é uma plataforma de orquestração de fluxos de trabalho que permite o desenvolvimento, agendamento e monitoramento de pipelines de dados programaticamente. Esses pipelines são construídos como grafos acíclicos dirigidos (DAGs - Directed Acyclic Graphs), onde cada nó representa uma tarefa (task) e as arestas entre os nós indicam a sequência de execução.

O Airflow foi criado para resolver a necessidade de orquestração de fluxos de trabalho de dados em ambientes onde a ingestão e o processamento de grandes volumes de dados (Big Data) são críticos. Ele permite definir, agendar e monitorar essas tarefas, possibilitando maior controle sobre fluxos de trabalho complexos e permitindo a automatização de pipelines em ambientes de produção.

### Funcionalidades Principais

- Orquestração de Tarefas: Automatiza o sequenciamento e a execução de tarefas em um pipeline.
- Escalabilidade: Suporta escalabilidade horizontal em ambientes de nuvem e distribuídos, essenciais para lidar com dados massivos.
- Monitoramento e Alertas: Possui interface gráfica (Web UI) para monitorar o status dos pipelines, além de alertas em caso de falhas.
- Integração com Ferramentas de Big Data: Suporte nativo para integração com plataformas como Hadoop, Spark, AWS S3, Google Cloud Storage, bancos NoSQL, entre outros.
- Confiabilidade e Tolerância a Falhas: Possui suporte a reexecuções e gestão de falhas em pipelines.

## Arquitetura e Componentes do Airflow

A arquitetura do Airflow é baseada em uma abordagem distribuída, permitindo a orquestração eficiente de fluxos de trabalho de dados em ambientes com diversas necessidades de escalabilidade. Os principais componentes incluem:

- **DAGs**: Grafos que representam o fluxo de tarefas no pipeline. Um DAG define a ordem de execução e as dependências entre tarefas.

- **Scheduler**: O componente responsável por agendar a execução das tarefas definidas nos DAGs. Ele observa os horários e dependências para garantir que as tarefas sejam iniciadas no momento correto.

- **Executor**: A entidade que executa as tarefas. Airflow pode ser configurado com diferentes executores:

- LocalExecutor: Executa as tarefas localmente, útil para desenvolvimento ou pequenos projetos.
- CeleryExecutor: Distribui a execução de tarefas entre vários trabalhadores, sendo mais adequado para grandes volumes de dados e cargas distribuídas.
- KubernetesExecutor: Utilizado em ambientes de Kubernetes (orquestrador de containers), onde cada tarefa é executada em um contêiner isolado, ideal para nuvens híbridas ou públicas.

- **Workers**: Processos que executam as tarefas agendadas. Aumentar o número de workers permite a execução paralela de mais tarefas.

- **Metadata Database**: Um banco de dados que armazena o estado dos DAGs, tarefas e logs. Pode ser configurado para usar diferentes SGBDs, como MySQL, PostgreSQL ou SQLite.

- **Web UI**: Interface gráfica que permite visualizar, monitorar e gerenciar os pipelines de forma interativa, mostrando o status das execuções e facilitando a identificação de falhas.

O Apache Airflow utiliza um banco de dados relacional para armazenar metadados, como o estado de execução dos DAGs, logs, informações sobre tarefas e históricos de execução. Os bancos de dados mais comuns usados pelo Airflow são:

- PostgreSQL: É amplamente recomendado para uso em produção devido à sua robustez e escalabilidade. O Airflow suporta plenamente o PostgreSQL e muitas implementações o utilizam devido ao suporte a grandes volumes de dados e à confiabilidade.

- MySQL: Outra escolha popular para produção, MySQL é bem suportado pelo Airflow. Ele também é capaz de lidar com cargas de trabalho pesadas, mas o PostgreSQL é frequentemente preferido devido a alguns recursos mais avançados.

- SQLite: Por padrão, o Airflow usa SQLite em ambientes de desenvolvimento ou testes locais. No entanto, o SQLite não é adequado para ambientes de produção devido a suas limitações em termos de concorrência e escalabilidade.

Portanto, para ambientes de produção, **PostgreSQL** e **MySQL** são os bancos de dados recomendados. A escolha entre eles depende das preferências e da infraestrutura existente, mas é importante garantir que o banco esteja bem configurado e ajustado para lidar com o tráfego e a carga do Airflow.

### Cenários de Uso

- ETL Automatizado: Automatizar pipelines de dados que extraem informações de APIs, transformam-nas em formatos adequados e as carregam em sistemas de armazenamento (Data Warehouses, NoSQL).

- Ingestão de Dados na Nuvem: Orquestrar a ingestão de dados de múltiplas fontes (como serviços de IoT, redes sociais, logs de aplicativos) em plataformas de nuvem como AWS S3, Google Cloud Storage, ou Microsoft Azure Blob Storage.

- Data Pipelines em Machine Learning: Agendar e automatizar fluxos de trabalho de treinamento de modelos de machine learning, desde a coleta e pré-processamento de dados até a validação de modelos e o deploy dos resultados.

- Integração de Dados entre Sistemas Heterogêneos: Orquestrar a movimentação de dados entre bancos de dados relacionais (SQL) e NoSQL, ou entre sistemas de arquivos locais e distribuídos.

### Exemplo de Pipeline

O Airflow é amplamente utilizado para automatizar pipelines de ETL. Ele pode, por exemplo, extrair dados de APIs, transformar os dados em formatos adequados e carregá-los em um data warehouse ou banco NoSQL.

Também é capaz de orquestrar o processo de ingestão de dados em tempo real ou em batch de múltiplas fontes, como redes sociais, serviços de IoT e logs de aplicativos, movendo esses dados para plataformas de armazenamento na nuvem, como AWS S3, Google Cloud Storage, ou Azure Blob Storage.


Atualmente, a solução é uma escolha popular para gerenciar workflows de treinamento de modelos de Machine Learning. Ele coordena tarefas de coleta de dados, pré-processamento, treinamento e validação de modelos, além de possibilitar o deploy automatizado desses modelos.

O Airflow também pode ser utilizado para sincronizar dados entre diferentes fontes de dados e sistemas de processamento, facilitando a movimentação de dados entre SGBDs relacionais (SQL) e não-relacionais (NoSQL), ou entre sistemas de arquivos distribuídos (HDFS) e locais (NAS). 

Aqui está um exemplo simples de como estruturar um pipeline ETL com Airflow, ilustrando a criação de três tarefas: extração, transformação e carga. O código demonstra como o Airflow pode ser usado para automatizar o processamento de dados em diferentes estágios:

```python
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.utils.dates import days_ago

# Definir o DAG
dag = DAG(
    'exemplo_pipeline_etl',
    description='Pipeline simples de ETL com Apache Airflow',
    schedule_interval='@daily',
    start_date=days_ago(2),
)

# Tarefa de extração de dados
extract = BashOperator(
    task_id='extrair_dados',
    bash_command='echo "Extraindo dados..."',
    dag=dag,
)

# Tarefa de transformação de dados
transform = BashOperator(
    task_id='transformar_dados',
    bash_command='echo "Transformando dados..."',
    dag=dag,
)

# Tarefa de carga de dados
load = BashOperator(
    task_id='carregar_dados',
    bash_command='echo "Carregando dados..."',
    dag=dag,
)

# Definir a sequência das tarefas
extract >> transform >> load
```

## Passos para Configuração e Execução do Airflow com Docker

### Executar o Script de Pré-Configuração

Antes de iniciar qualquer outro passo, execute o script `pre-setup.sh` para garantir que todas as dependências e configurações iniciais sejam aplicadas corretamente:

```bash
chmod +x pre-setup.sh
./pre-setup.sh
```

### Executar o Script de Pós-Configuração 

Após a execução do `pre-setup.sh`, execute o script `post-setup.sh` para aplicar as configurações finais necessárias para o funcionamento do Airflow:

```bash
chmod +x post-setup.sh
./post-setup.sh)
```

### Acessar a Interface Gráfica Web do Airflow

Na interface, você poderá gerenciar e monitorar suas DAGs. Após a execução dos dois scripts, abra seu navegador e acesse a interface gráfica do Airflow via URL: `http://localhost:8080`

- **Usuário**: admin
- **Senha**: admin

### Colocar o Script .py na Pasta dags

Para que suas DAGs sejam reconhecidas pelo Airflow, coloque o arquivo `.py` que contém o código da DAG dentro da pasta dags no seu diretório do Airflow. Exemplo de Código Simples: 

```python
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime

# Função simples para imprimir uma mensagem
def print_hello():
    print("Hello, Airflow! Tudo está funcionando bem.")

# Definindo o DAG
with DAG(
    'simple_test_dag',
    start_date=datetime(2023, 11, 5),
    schedule_interval='@weekly',  # Roda uma vez por dia
    catchup=False                # Evita rodar em datas passadas
) as dag:

    # Tarefa para imprimir a mensagem
    task_hello = PythonOperator(
        task_id='print_hello_task',
        python_callable=print_hello,
    )
```

### Reiniciar o Contêiner do Airflow Scheduler

Após adicionar a DAG, você precisará reiniciar o contêiner do Airflow Scheduler para que ele reconheça a nova DAG. Execute o seguinte comando para reiniciar **APENAS** o contêiner do scheduler:

```bash
docker compose restart airflow-scheduler
```

Isso irá forçar que o Airflow recarregue as novas configurações e identifique as DAGs corretamente. Após o procedimento, veja na interface gráfica a sua nova DAG, teste sua inicialização e verifique os logs de execução. 


### Prática: Ingestão Automatizada com Airflow + Spark + Delta Lake

Após compreender os fundamentos do Apache Airflow e seu papel na orquestração de pipelines de dados, aplicaremos agora um exemplo prático de ingestão automatizada, integrando o Airflow ao Spark e ao Delta Lake. Em ambientes reais, tarefas de ingestão e transformação de dados precisam ser executadas periodicamente — muitas vezes diariamente, horariamente ou sob demanda — para garantir que os dados brutos coletados de diversas fontes sejam convertidos para formatos otimizados e governáveis.

Nesta prática, simularemos esse tipo de rotina, utilizando o dataset público **NYC Taxi** como exemplo clássico de dados de alta volumetria e atualização contínua.  
Nosso objetivo será converter dados brutos em **CSV** para o formato **Delta Lake**, armazenando-os diretamente em um bucket **MinIO**, com orquestração automatizada pelo **Apache Airflow** e processamento distribuído via **Apache Spark**.

> O formato **Delta Lake** utiliza arquivos **Parquet** como base, mas adiciona **controle de versão e transações ACID**, permitindo rollback, time travel e governança total.  
> Em outras palavras, ele herda todas as vantagens do Parquet e adiciona confiabilidade transacional e rastreabilidade.

---

### Dataset de Exemplo: NYC Taxi

Fonte oficial: [https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

Cada arquivo CSV mensal contém milhões de corridas registradas por táxis de Nova York, incluindo datas, distâncias, valores e coordenadas de embarque e desembarque.

| Dataset (mês único) | Tamanho bruto | Tamanho após conversão | Redução aproximada |
|----------------------|---------------|------------------------|--------------------|
| CSV (`yellow_tripdata_2023-01.csv`) | ~10 GB | — | — |
| Parquet (compressão + colunar) | ~1,6 GB | ~84% menor | Alta eficiência de leitura |
| Delta Lake (Parquet + `_delta_log/`) | ~1,7 GB | ~83% menor | Mesma compactação + controle ACID |

Mesmo com metadados adicionais, o Delta Lake mantém compressão semelhante ao Parquet, mas oferece integridade transacional e versionamento — recursos inexistentes no CSV.

---

### Arquitetura da Solução

```mermaid
flowchart LR
    A["CSV Bruto (NYC Taxi)"] --> B["Airflow DAG (orquestração)"]
    B --> C["Spark Job (Conversão e Escrita)"]
    C --> D["Delta Lake armazenado no MinIO"]

    style A fill:#f8e1c1,stroke:#c78b38
    style B fill:#dbeafe,stroke:#3b82f6
    style C fill:#e5e7eb,stroke:#6b7280
    style D fill:#e2fbe2,stroke:#22c55e
```

A automação desse tipo de fluxo é comum em pipelines que precisam atualizar dados periodicamente. Com isso, é possível aplicar o ciclo do ELT moderno:
Extração (Raw Data: Parquet/CSV) → Carga (Delta Lake) → Governança e Consistência (ACID sobre MinIO/S3).

```python
from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {'owner': 'airflow', 'depends_on_past': False, 'retries': 1}

with DAG(
    dag_id='converter_csv_to_delta_dag',
    description='Converte dataset CSV (NYC Taxi) em formato Delta Lake e grava no MinIO',
    default_args=default_args,
    start_date=datetime(2025, 10, 1),
    schedule_interval=None,  # Execução sob demanda (pode ser diária em produção)
    catchup=False,
) as dag:

    check_csv = BashOperator(
        task_id='check_csv_file',
        bash_command='test -f /data/nyc_taxi/yellow_tripdata_2023-01.csv && echo "Arquivo CSV encontrado!"'
    )

    convert_to_delta = BashOperator(
        task_id='convert_csv_to_delta',
        bash_command=(
            'spark-submit --master local[2] '
            '--packages io.delta:delta-spark_2.12:3.2.0 '
            '/opt/airflow/dags/scripts/convert_csv_to_delta.py'
        )
    )

    validate_output = BashOperator(
        task_id='validate_delta',
        bash_command='aws --endpoint-url http://minio:9000 s3 ls s3://datalake/nyc_taxi_delta/ || echo "Verifique o bucket!"'
    )

    check_csv >> convert_to_delta >> validate_output
```

## Conclusão

As tarefas de orquestração de fluxos de trabalho e automatização de pipelines em um ambientes de Big Data são práticas fundamentais na engenharia de dados. Nesse cenário, o Apache Airflow destaca-se por integrar diversas fontes, sistemas de armazenamento distribuído e ferramentas analíticas, garantindo escalabilidade e confiabilidade operacional. Seu uso é amplamente difundido para otimizar ETL, integração de dados, análises em tempo real e machine learning, consolidando-se como um componente essencial nas arquiteturas modernas de dados.