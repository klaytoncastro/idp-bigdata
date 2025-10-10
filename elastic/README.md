# Elastic Stack

## 1. Visão Geral e Contexto Histórico

O Elasticsearch (ES) é um motor de busca e análise distribuído (distributed search and analytics engine) e pode classificado como um banco de dados NoSQL orientado a documentos baseado em JSON. Ele é otimizado primariamente para busca textual (full-text search), agregação e análise de grandes volumes de dados em tempo real e em larga escala. Sua arquitetura é intrinsecamente distribuída, escalável e tolerante a falhas, permitindo armazenar e consultar dados com baixa latência e alta disponibilidade. Criado em 2010 por Shay Banon, a solução surgiu como evolução natural do projeto Compass, um motor de busca embutido em aplicações Java. O objetivo era tornar a poderosa engine Apache Lucene — desenvolvida na década de 1990 por Doug Cutting (também criador do Hadoop) mais acessível, distribuída e simples de operar em larga escala. Enquanto a Lucene é uma biblioteca Java de baixo nível voltada à indexação e busca textual em ambiente local, o Elasticsearch ampliou esse paradigma ao incorporar mecanismos de coordenação e replicação entre múltiplos nós, transformando a engine em um sistema de busca e análise distribuído.

Antes do Elasticsearch, o principal motor baseado em Lucene era o Apache Solr, criado em 2004 pela CNET (empresa de mídia e tecnologia sediada em São Francisco/CA) e posteriormente incorporado à Apache Software Foundation em 2006. 
Yonik Seeley, engenheiro da CNET, enfrentava o desafio de indexar e pesquisar grandes volumes de conteúdo digital — artigos, notícias e vídeos — publicados em seus portais. Para resolver esse problema, Seeley criou o Solr como uma camada web (HTTP/XML) sobre o Apache Lucene, oferecendo uma interface de busca escalável, robusta e de fácil integração, que consolidou-se como o principal motor de busca corporativo, sendo amplamente adotado por empresas e instituições que necessitavam de indexação e busca de alto desempenho sobre grandes volumes de dados. O Solr oferecia uma interface HTTP com comunicação baseada em XML — um modelo REST-like de requisições e respostas, mas não compatível com SOAP. Embora eficiente e extensível, sua configuração via XML e o gerenciamento manual de clusters tornavam a administração mais complexa. 

Apesar de ambos — Lucene e Solr — serem reconhecidos pela eficiência na busca textual, Shay Banon propôs uma solução mais moderna, RESTful, schema-free e nativamente distribuída, simplificando a integração e a escalabilidade em ambientes corporativos e cloud-native. A partir dessa concepção, nasceu a empresa Elastic NV, que evoluiu o projeto inicial para uma suíte completa voltada à busca, análise e observabilidade em larga escala. Dessa forma, o Elasticsearch expandiu os fundamentos do Lucene adicionando:

- Distribuição e replicação de índices entre múltiplos nós.
- Descoberta automática de cluster e balanceamento de carga dinâmico.
- Alta disponibilidade e resiliência por meio de shards e réplicas.
- API RESTful para inserção e consulta de documentos JSON.

A ideia projetada é que cada registro seja armazenado como um documento JSON dentro de um índice (conceito análogo a uma tabela em bancos relacionais), porém com estrutura flexível e esquema dinâmico. As consultas são executadas sobre campos indexados pela engine Lucene, que constrói um índice invertido, permitindo busca full-text, filtragem, rankings por relevância e agregações estatísticas complexas de forma eficiente. Dessa maneira, a Elastic Stack (antiga ELK Stack) combina três componentes principais, que atuam de forma integrada:

| Componente        | Função                    | Descrição                                                                 |
|-------------------|---------------------------|---------------------------------------------------------------------------|
| **Elasticsearch** | Armazenamento e busca     | Banco de documentos JSON, com API REST e suporte a agregações complexas.  |
| **Logstash**      | Ingestão e transformação  | Pipeline de entrada, filtragem e envio de dados (input → filter → output).|
| **Kibana**        | Visualização e exploração | Interface web para consultas, dashboards e monitoramento de métricas.     |

Essa combinação permite criar pipelines completos de observabilidade, desde a coleta de logs brutos até a análise interativa e visualização analítica em dashboards. A stack também serve de base para módulos complementares, como Filebeat, Metricbeat e APM Server, que expandem a coleta para métricas de sistema, eventos de rede e traces de aplicações distribuídas. 

Em paralelo, no domínio corporativo, o Splunk já era referência em análise de logs e métricas, porém baseado em modelo proprietário e licenciamento de alto custo. Dessa forma Elastic Stack, inicialmente conhecido como ELK (Elasticsearch, Logstash, Kibana), consolidou-se como alternativa open-source, oferecendo funcionalidades equivalentes — indexação, busca e visualização em tempo real — com maior flexibilidade, transparência e custo significativamente reduzido.

## 2. Evolução Arquitetural: Da Indexação de Conteúdo à Observabilidade de Sistemas

O Elasticsearch representa a convergência entre dois mundos que, até o início da década de 2010, eram tecnicamente e conceitualmente distintos: o da indexação de conteúdo e o do monitoramento de sistemas. A primeira geração de motores de busca — liderada por Lucene e Solr — foi concebida para indexar documentos textuais e conteúdo web, oferecendo consultas full-text, ranqueamento por relevância e recuperação de informações em larga escala. O foco era busca de informação (Information Retrieval), não análise operacional. Esses motores se destacavam por construir e percorrer índices invertidos, estruturas capazes de mapear termos a documentos com extrema rapidez, o que os tornava ideais para catálogos, portais e sistemas de pesquisa corporativos.

O surgimento do Elasticsearch (2010) rompeu essa fronteira. Ao transformar o Lucene em uma plataforma distribuída, escalável e acessível via API REST, Banon possibilitou que o mesmo mecanismo de indexação textual fosse aplicado não apenas a conteúdo web, mas também a dados operacionais — logs, métricas e eventos de aplicações. Essa transposição técnica redefiniu o escopo da busca: do texto para o comportamento do sistema. Assim, Elastic Stack (inicialmente ELK Stack) tornou-se a espinha dorsal da observabilidade moderna. O que antes era apenas uma ferramenta de busca passou a sustentar pipelines completos de telemetria distribuída, permitindo correlacionar eventos, medir desempenho e diagnosticar falhas em tempo real. Esse movimento acompanhou — e em grande parte impulsionou — a evolução dos papéis operacionais dentro das equipes de infraestrutura tecnológica. 

Historicamente, a monitoração de sistemas envolvia a coleta pontual de métricas como uso de CPU, memória, latência e tempo de resposta, oferecendo uma visão parcial do comportamento da infraestrutura. Esse modelo era adequado à era dos administradores de sistemas (Sysadmins), focados em servidores físicos e topologias estáticas. Com a adoção de infraestrutura virtualizada e pipelines contínuos, emergiu a cultura DevOps, que unificou desenvolvimento e operações e passou a tratar desempenho e disponibilidade como responsabilidades compartilhadas. Nesse contexto, o monitoramento tradicional evoluiu para o conceito de observabilidade — a capacidade de entender o estado interno de um sistema distribuído a partir de seus sinais externos, ou seja, logs, métricas e traces (os chamados *three pillars of observability*).

A transição de monitoramento para observabilidade marca a passagem de um modelo reativo — centrado em alarmes e métricas pontuais — para um modelo proativo, orientado à compreensão contextual do sistema.
Enquanto o monitoramento responde à pergunta: 

>“o sistema está funcionando?”

Já a observabilidade permite investigar: 

>“por que o sistema está se comportando assim?”. 

A evolução da ELK Stack desempenhou papel central nessa transição, fornecendo as bases técnicas para coletar, armazenar e correlacionar esses três pilares em escala. Essa integração foi determinante para o surgimento de novas funções operacionais, conforme abaixo: 

| Período    | Papel Profissional                  | Perfil técnico predominamente                                                              | Ferramentas típicas                     |
|------------|-------------------------------------|--------------------------------------------------------------------------------------------|-----------------------------------------|
| **2000s**  | **Sysadmin**                        | Administração de servidores físicos, com foco em disponibilidade e estabilidade.           | Nagios, Cacti, MRTG                     |
| **2010s**  | **DevOps**                          | Integração de desenvolvimento e operações, promovendo entrega contínua e automação.        | Jenkins, Ansible, ELK                   |
| **2015+**  | **SRE (Site Reliability Engineer)** | Confiabilidade e automação inteligente, com foco em resiliência, SLOs e redução de MTTR.   | Prometheus, Grafana, Elastic APM        |
| **2020s**  | **Platform Engineer**               | Abstração e padronização da infraestrutura, oferecendo *Observability as a Service* (OaaS).| Kubernetes, Elastic Stack, OpenTelemetry|

Assim, o Elasticsearch deixou de ser apenas um conjunto de ferramentas para se consolidar como um marco na evolução da engenharia de operações, fornecendo o alicerce para práticas modernas de monitoramento avançado, correlação de eventos e diagnóstico em tempo real — elementos que caracterizam a observabilidade contemporânea. Mais do que um mecanismo de indexação de documentos, o Elastic tornou-se o núcleo de inteligência operacional em arquiteturas distribuídas, sustentando diagnósticos automáticos, alertas inteligentes e análises preditivas — capacidades que pavimentam o caminho para o paradigma de AIOps (Artificial Intelligence for IT Operations). Essa consolidação tecnológica e conceitual deve-se a três fatores fundamentais: 

- Unificação dos sinais – combina logs, métricas e traces em um único pipeline distribuído.
- Elasticidade horizontal – adapta-se dinamicamente à escala e volatilidade de workloads modernos.
- Interface analítica integrada – o Kibana oferece visualização exploratória e dashboards correlacionáveis em tempo real.

## 3. Arquitetura e Conceitos-Chave

Na construção de sistemas escaláveis e data-intensive, observamos as vantagens dos modelos NoSQL, projetados para desempenho e flexibilidade em ambientes distribuídos. Dentro da família de bancos orientados a documentos, duas soluções se destacam:

- **MongoDB**: projetado como um general-purpose Data Store, voltado a alta vazão de escritas e atualizações (Writes/Updates), consistência e persistência do estado atual da aplicação (Source of Truth).
- **Elasticsearch**: concebido como uma Search and Analytics Engine, otimizada para baixa latência em consultas textuais, agregações em larga escala e alta vazão de leituras (Reads).

O MongoDB atua como a camada transacional primária: 

- Consultas por Chave Primária e Range Queries: A estrutura em árvore balanceada (B-Tree) permite localizar eficientemente documentos com base em chaves ou intervalos de valores (e.g., _id ou timestamp BETWEEN X AND Y).
- Eficiência de Escrita: As atualizações (in-place updates) em B-Tree são relativamente eficientes, pois afetam apenas um subconjunto de nós, mantendo a integridade transacional.
- Consistência e Durabilidade Opcionais (ACID-like properties): É o componente ideal para manter a integridade e o estado atual da aplicação.

Já o Elasticsearch funciona como um índice secundário desnormalizado, especializado em leitura analítica e busca textual em tempo real sobre grandes volumes de dados. Ao invés de B-Trees, a ferramenta utiliza o Índice Invertido, estrutura que foca em: 

- Busca Full-Text e Relevância (Scoring): O índice invertido mapeia cada termo (palavra tokenizada) para a lista de documentos em que ele aparece. Isso permite localizar instantaneamente todos os documentos que contêm um termo, essencial para a busca textual rápida e o cálculo de relevância (scoring).
- Agregações e Análise em Larga Escala: Embora os índices invertidos não sejam ideais para agregações numéricas diretas, o ES utiliza estruturas auxiliares como Doc Values e Field Data para permitir a execução de funções estatísticas e agregações (e.g., contagem, média, percentis) em terabytes de dados com latência submilisegundo.
- Imutabilidade e Alta Taxa de Leitura: Os segmentos de Lucene (unidades do índice invertido) são imutáveis, o que permite caching agressivo no sistema operacional e garante um alto desempenho de leitura. Uma atualização em um documento exige a reindexação do documento inteiro, um trade-off aceitável para priorizar a performance de leitura.

Dessa forma, enquanto o MongoDB prioriza operações transacionais e consistência, o Elasticsearch é projetado para consulta, análise e exploração em tempo real — pilares fundamentais da observabilidade moderna. Além do SGBD de documentos (Elastic Search), temos a ferramenta Logstash, usada quando há necessidade de transformação complexa (ex: parsing avançado com Grok, enriquecimento de dados com lookups, normalização). Em fluxos mais simples, o Filebeat pode enviar os dados diretamente para o Elasticsearch, usando processadores de ingestão internos do ES para transformações leves. 

```mermaid
flowchart LR
    subgraph Collect
        A[Filebeat<br/>Agente de Coleta de Logs]
    end

    subgraph Process
        B[Logstash<br/>Ingestão e Transformação]
    end

    subgraph Store
        C[Elasticsearch<br/>Armazenamento e Busca]
    end

    subgraph Visualize
        D[Kibana<br/>Dashboards e Consultas]
    end

    A -->|envia eventos| B
    B -->|indexa documentos| C
    C -->|dados consultados| D

    style A fill:#fef9e7,stroke:#d4ac0d,stroke-width:1px
    style B fill:#eaf2f8,stroke:#2874a6,stroke-width:1px
    style C fill:#e8f8f5,stroke:#148f77,stroke-width:1px
    style D fill:#fceae8,stroke:#cb4335,stroke-width:1px

    classDef title fill:#f8f9f9,stroke:#000,stroke-width:0px
    class A,B,C,D title
```

| Conceito           | Descrição                                                                                              | Analogia (SQL)          |
|--------------------|--------------------------------------------------------------------------------------------------------|-------------------------|
| **Documento**      | Unidade básica de informação, representada como um objeto JSON armazenado em um índice.                | Linha / Registro        |
| **Index**          | Coleção de documentos que compartilham um propósito comum.                                             | Banco de Dados / Tabela |
| **Shard**          | Instância física do índice, menor unidade de escalabilidade e distribuição.                            | Partição de Tabela      |
| **Replica**        | Cópia redundante de um *shard*, usada para alta disponibilidade e tolerância a falhas.                 | Replicação de Banco     |
| **Index Inverted** | Estrutura de dados que mapeia cada termo para os documentos onde ele aparece, permitindo busca rápida. | Índice de Tabela        |

## 3. Descrição do Ambiente

Este ambiente de laboratório permite compreender na prática:

- Como funciona o banco de documentos e índices invertidos.
- O fluxo de ingestão e transformação de dados.
- A estrutura e funcionamento de pipelines de observabilidade e monitoramento.

```bash
opt/elastic/
│
├── Dockerfile               # Adiciona ingest-attachment plugin (Apache Tika)
├── docker-compose.yml       # Stack principal: Elasticsearch, Logstash, Kibana
├── permissions.sh           # Script opcional de criação e ajuste de pastas
│
├── datasets/                # Logs e datasets de teste (ex: apache_access.log)
│
├── elastic/                 # Persistência do Elasticsearch (dados)
│   ├── config/
│   └── data/
│
└── logstash/
    └── pipelines/           # Definição dos pipelines (.conf)
```

### 3.1. Inicialização

```bash
cd /opt/elastic
docker compose up -d --build
```

Verifique se os containers estão ativos:

```bash
docker ps
```

### 3.2. Acesso às ferramentas

| Serviço           | Porta Padrão          | Descrição                           |
|-------------------|-----------------------|-------------------------------------|
| **Elasticsearch** | 9200                  | API REST e armazenamento de índices |
| **Kibana**        | 5601                  | Interface de análise e dashboards   |
| **Logstash**      | 5044 / 9600           | Entrada de logs / API interna       |

Baixe um dataset de logs de exemplo:

```bash
curl https://raw.githubusercontent.com/elastic/examples/master/Common%20Data%20Formats/apache_logs/apache_logs -o datasets/apache_access.log
```

Crie um pipeline em `logstash/pipelines/apache.conf`:

```bash
input {
  file {
    path => "/datasets/apache_access.log"
    start_position => "beginning"
    sincedb_path => "/dev/null"
  }
}
filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
}
output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    index => "apache-logs"
  }
  stdout { codec => rubydebug }
}
```

Reinicie apenas o Logstash:

```bash
docker compose restart logstash
```

Acompanhe os logs:

```bash
docker compose logs -f logstash
```

### 3.3. Verificação no Kibana

Acesse `http://localhost:5601`

Vá em `Discover → Create data view`

**Nome**: `apache-logs*`

Clique em `Create data view`

Os documentos devem aparecer automaticamente.

### 3.4. Extensões e ferramentas do ecossistema ELK

O **Filebeat** é um agente leve projetado para a coleta e o envio de logs. Ele pode ser adicionado ao ambiente sem qualquer modificação na stack principal, sendo ideal para testes de ingestão direta de dados. Atua como um *shipper*, ou seja, lê arquivos de log locais — como `/var/log/*.log`, registros de aplicações ou access logs de servidores — e encaminha os eventos coletados diretamente para o Elasticsearch ou, opcionalmente, para o Logstash, que pode realizar transformações adicionais. Entre suas principais vantagens está o consumo mínimo de recursos: tipicamente menos de 50 MB de memória e uso de CPU praticamente insignificante. Por essa razão, é amplamente utilizado em cenários onde se busca simplicidade, eficiência e baixo impacto sobre o sistema monitorado. Para utilizá-lo, crie um `filebeat.yml`: 

```yml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /datasets/apache_access.log

output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]

setup.kibana:
  host: "http://kibana:5601"

logging.to_files: false
```
Adicionar serviço temporário e execute apenas quando quiser testar:

```bash
docker run -d --name filebeat \
  --user=root \
  --network=mybridge \
  -v ./datasets:/datasets \
  -v ./filebeat.yml:/usr/share/filebeat/filebeat.yml \
  docker.elastic.co/beats/filebeat:8.14.3
```

Verifique a saída:

```bash
docker logs -f filebeat
```

O índice `filebeat-*` aparecerá no `Kibana → Discover`.

Para remover:

```bash
docker rm -f filebeat
```

Por sua vez, o **Metricbeat** é uma agente voltado à coleta de métricas de sistema e aplicações. Mede CPU, memória, rede, I/O, e também integra com serviços como PostgreSQL, Nginx, Redis, etc. Assim, pode substituir o antigo `top + iostat + netstat` em ambientes distribuídos. Como saída, temos os índices `metricbeat-*` no Elasticsearch.Em observabilidade serve como fonte para dashboards de infraestrutura e aplicações no Kibana (SO Linux, NodeJS, Java, etc.).

Outra importante ferramenta é o **APM Server**, componente da Elastic para APM (Application Performance Monitoring). Recebe traces, métricas e spans de aplicações instrumentadas (Python, Java, Node, etc.) via agente. Captura latência, erros, tempo de resposta, dependências entre serviços. A integração é direta em `Kibana → Observability → APM`. Cria índices `apm-*` e `traces-*`.

O **Cerebro** é uma interface web para administração direta do Elasticsearch para visualizar índices, shards, cluster health, executar queries, alterar settings. Outra alternativa nesse sentido é o **ElasticHQ**, ferramenta similar ao Cerebro, que oferece visualização de cluster, índices e métricas, podendo rodar dentro do mesmo container da stack.


## 4. Conclusão

Com a Stack ELK, é possível criar uma solução completa de observabilidade, desde a coleta bruta de logs até a visualização analítica em tempo real.