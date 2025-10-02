<!--
## Índice
1. [O que é Armazenamento de Objetos](#o-que-é-armazenamento-de-objetos)
2. [Conceitos do MinIO](#conceitos-do-minio)
3. [Introdução ao S3 (Simple Storage Service)](#introdução-ao-s3-simple-storage-service)
4. [Configuração do MinIO com Docker](#configuração-do-minio-com-docker)
5. [Uso da API para Leitura e Gravação de Arquivos](#uso-da-api-para-leitura-e-gravação-de-arquivos)
6. [Exemplos Práticos](#exemplos-práticos)
7. [Conclusão](#conclusão)
-->
# Fundamentos de Armazenamento de Dados

## Introdução

O crescimento do volume e da variedade de dados tornou inviável tratá-los como meros arquivos locais guardados em disco. A escolha da abordagem de armazenamento condiciona custo, desempenho, segurança e, sobretudo, capacidade de escala. No ecossistema de big data, consolidou-se a abordagem de armazenamento baseado em objeto. Este conceito materializa o acesso ao conteúdo via HTTP (API S3 e compatíveis, como AWS S3 e Azure Blob Storage), que sustenta data lakes e aplicações modernas de Big Data, Operações de AI/ML e BI/Analytics, tanto on-premises quanto em nuvem. Assim, cada item é um objeto identificado por um ID único, descrito por metadados e atributos, e portador de um conteúdo binário que representa dados não estruturados (imagens, vídeos, backups, logs). Projetado para arquiteturas distribuídas e para operações em larga escala, o armazenamento baseado em objeto emerge como resposta às limitações dos modelos anteriores. Antes de iniciar a prática, é essencial situar a evolução — do disco local e dos storages monolíticos para mecanismos que exigem particionamento e novos requisitos de acesso — e compreender por que a mudança ocorreu: requisitos de escalabilidade, governança e necessidade de desacoplamento do processamento e armazenamento. 

## Modelos de Armazenamento

### Linha do Tempo e Principais Desafios

Historicamente, aplicações gravavam dados em discos conectados ao próprio servidor. A proximidade reduzia latência e simplificava a operação. Em contrapartida, havia acoplamento forte: falhas do servidor interrompiam acesso; expansão exigia trocas físicas; a escala era limitada aos recursos computacionais e de armazenamento de um só computador. Para aumentar desempenho e tolerância a falhas, adotaram-se controladoras e RAID (conjuntos de discos atuando como uma unidade lógica). O RAID (Redundant Array of Independent Disks)  melhora paralelismo e pode sobreviver à perda de discos, mas o armazenamento continua localmente atachado ao servidor. Ou seja, condicionado a falhas no servidor e com restrições de expansão.

O passo seguinte foi movimentar os discos do servidor e centralizar em equipamento central dedicado, um storage em rede SAN (Storage Area Network). Assim, os servidores passam a “enxergar” volumes remotos para suas aplicações, e formatam neles seus sistemas de arquivos, e protocolos em nível de bloco (FCP, iSCSI), oferecendo alto desempenho e consolidação para bancos de dados e máquinas virtuais. Contudo, possui alguns limites claros para uma arquitetura monolítica: a escala predominantemente vertical, com custo e complexidade elevados e pontos de gargalo previsíveis.

Em paralelo, popularizou-se o NAS (Network Attached Storage), que oferece um modelo de compartilhamento de arquivos em hierarquia de pastas por protocolos de rede (SMB/CIFS no ecossistema Windows; NFS no ecossistema Linux). É excelente para colaboração e documentos. Contudo, metadados hierárquicos e atributos de segurança (permissionamento) tornam-se gargalo à medida que o número de arquivos cresce para ordens de milhares e milhões.

Para reduzir os silos tecnológicos, grandes fabricantes como EMC, Netapp, IBM, HPE, Hitachi, dentre outros, passaram a entregar SAN (bloco) e NAS (arquivo) no mesmo chassi de equipamentos “unificados”. Isso simplifica a gestão, mas não altera o modelo: continua-se a escalar, majoritariamente, subindo a mesma caixa; backups, replicações e janelas operacionais tornam-se onerosas conforme a base cresce.

Surge então a família de sistemas de armazenamento distribuído, cujo objetivo é espalhar dados por muitos nós em cluster. O exemplo mais influente no contexto de Big Data foi o HDFS (Hadoop Distributed File System), onde um arquivo é quebrado em blocos grandes (tipicamente 128–256 MB) e distribuído por DataNodes; metadados (nome, mapeamento de blocos) são mantidos pelo NameNode. A ideia é otimizar leituras sequenciais em lote (processamentos massivos). Contudo, há um custo implícito para os arquivos pequenos (milhares de itens minúsculos sobrecarregam metadados), além da complexidade de acoplamento ao ecossistema Hadoop. Fora do Hadoop, o GlusterFS surgiu para entregar sistemas de arquivos distribuídos respeitando POSIX (Interface de Sistema Operacional Portátil), um conjunto de padrões que define uma interface comum para sistemas operacionais derivados do UNIX, visando garantir um alto nível de compatibilidade entre eles, mas também sofria com a sensibilidade aos arquivos pequenos.

<!--Em Gluster, servidores de armazenamento (“bricks”) são agregados logicamente e o espaço é particionado por hash (DHT), com camadas de tradução para replicação e rebalanço. A vantagem é oferecer semântica de arquivo padrão para aplicações que exigem POSIX (renomear, travas, hierarquia), facilitando migrações graduais. O custo aparece na escala de metadados (operações como rename e stat em grandes árvores), na sensibilidade a arquivos pequenos e na necessidade de planejamento cuidadoso de volumes e rebalanceamentos para manter desempenho e consistência operacional.--> 

Com a consolidação da computação em nuvem, amadurece o armazenamento de objetos. A unidade lógica passa a ser o objeto: conteúdo binário, metadados e uma chave (nome único) dentro de um bucket. Ao contrário dos sistemas de arquivos hierárquicos, baseados em sistemas locais, SAN ou NAS, que enfrentam desafios de escalabilidade, o armazenamento de objetos lida de maneira mais eficaz com grandes desafios envolvendo o volume e variedade de dados. Cada unidade de dados é tratada como um objeto independente, encapsulando seu conteúdo e metadados. O OpenStack Swift é a linhagem nativa de objeto no ecossistema OpenStack, com topologia em anel e consistência eventual, orientado a grande escala e dispersão geográfica. Historicamente, o OpenStack Swift estabeleceu os princípios que a API S3 popularizou e padronizou no mercado. 

Como um abordagem inovadora, o projeto Ceph pretende consolidar-se como vertente unificada sobre o RADOS (um objeto distribuído interno) e, a partir dele, expõe três semânticas no mesmo cluster: bloco (RBDs, para sistemas hipervisores e bancos de dados), arquivos (CephFS) e objetos (compatível com S3/Swift). Apesar de ser capaz de lidar com diferentes perfis e modelos de I/O; o preço é a complexidade operacional e a exigência de maturidade dos times técnicos para obter previsibilidade de desempenho.

<!--A distribuição e a durabilidade são regidas pelo algoritmo CRUSH, sem ponto único de falha. O ganho é um sistema capaz de lidar com diferentes perfis de I/O; o preço é a complexidade operacional (dimensionamento de daemons, monitoração, políticas de recuperação) e a exigência de maturidade de equipe para obter previsibilidade de desempenho. (com MON/MGR para controle e OSDs para dados, (CephFS, com MDS para metadados), objetos (RGW, compatível com S3/Swift)) (dimensionamento de daemons, monitoração, políticas de recuperação)-->

### Três modelos, três semânticas

Abaixo estão as principais diferenças entre os modelos de armazenamento:

- **Armazenamento de Bloco**: É baseado em soluções de armazenamento local ou em rede de armazenamento dedicada (SAN/iSCSI/Fibre Channel). Organiza os dados em blocos de tamanho fixo e requer um sistema de arquivos para mapeá-los. Ou seja, o storage expõe volumes de bloco; o sistema operacional do servidor é quem formata (ext4/NTFS etc.). É a base para bancos transacionais e hipervisores, onde IOPS e baixa latência são críticos. A governança (versionamento, retenção) é externa ao dispositivo lógico. Embora eficiente como plataforma para dados estruturados, não é ideal para grandes volumes de dados não estruturados. Um volume de bloco não tem noção de “arquivos”; ele apenas expõe endereços lógicos para leitura/gravação. Por isso, não há arbitragem nativa de concorrência entre hosts. Para evitar corrupção quando mais de um servidor acessa o mesmo volume, é obrigatório adotar LUN (Logical Units) expostos a único servidor, sistemas de arquivos com suporte a múltiplos hosts e recursos de bloqueio distribuído e journaling para consistência (ex: VMFS) ou protocolos de coordenação em baixo nível como (SCSI-3) e de múltiplos caminhos (ALUA/MPIO) para garantir redundância no acesso dos servidores ao storage. 
  
- **Armazenamento de Arquivos**: Baseia-se em servidores/appliances que exportam arquivos em hierarquias de pastas via rede, usando protocolos como NFS (Unix/Linux) e SMB/CIFS (Windows). É adequado a compartilhamento e colaboração, mas tende a perder eficiência quando o número de arquivos e operações de metadados (listar, criar, renomear) cresce para ordens de milhões. Diferente do “bloco”, em que não há arbitragem nativa entre hosts, no NAS a coordenação é feita pelo protocolo de arquivo e pelo próprio servidor que enxerga os seus volumes em nível de bloco e expõe à rede. Em analytics de larga escala, a árvore de diretórios e a pressão de escrita em metadados o tornam menos eficiente do que a abordagem baseada em objeto. Em cargas analíticas modernas, formatos colunares são preferíveis. 
  
- **Armazenamento de Objetos**: Armazena dados como objetos independentes e sem estrutura hierárquica, oferecendo escalabilidade e flexibilidade para gerenciar grandes volumes de dados não estruturados. Os arquivos são armazenados em um repositório acessível por uma API (Application Programming Interface), diferentemente dos sistemas tradicionais utilizados como plataforma para métodos de acesso a um nível mais baixo na pilha de infraestrutura, como os protocolos de bloco das SANs (FCP - Fibre-Channel Protocol, iSCSI - Internet Small Computer System Interface), protocolos de rede dos NAS (SMB - Server Message Block, NFS - Network File System), ou estrutura de tabelas em bancos de dados relacionais (BLOBs - Binary Large Objects).

### Principais Vantagens e Características

- **Escalabilidade**: Graças ao uso de um espaço de endereçamento simples (Single Namespace), o armazenamento de objetos pode gerenciar vastas quantidades de dados sem comprometer o desempenho. Tanto a infraestrutura de armazenamento quanto os nós OSD (Object Storage Devices) podem ser escalados conforme necessário, garantindo uma solução flexível e eficiente.

- **Segurança e Confiabilidade**: Cada objeto é identificado por um ID exclusivo, gerado por um algoritmo especializado. Esse processo assegura a integridade e autenticidade dos dados, tornando-o bastante seguro, especialmente para dados críticos.

- **Independência de Plataforma**: Objetos podem ser acessados e compartilhados em diferentes plataformas e sistemas operacionais, tornando-os ideais para ambientes de computação em nuvem, onde múltiplos usuários ou sistemas precisam de acesso simultâneo aos dados.

- **Gerenciamento Inteligente**: Inclui funcionalidades automáticas de gerenciamento, como auto-recuperação de dados e políticas que garantem a retenção adequada dos objetos. Isso reduz a necessidade de intervenção manual e assegura a disponibilidade dos dados.

- **Políticas de Retenção e Imutabilidade**: Objetos podem ser configurados para se tornarem imutáveis após a gravação, garantindo a integridade e a preservação dos dados ao longo do tempo. Com o uso de políticas de conformidade (compliance), é possível definir períodos específicos de retenção, durante os quais os dados não podem ser alterados ou excluídos, assegurando que permaneçam intactos conforme originalmente gravados. O recurso **WORM** (Write Once, Read Many) reforça essa imutabilidade, permitindo que os objetos sejam gravados uma única vez e lidos quantas vezes forem necessárias, até o fim do período de retenção estabelecido.

### Como Funciona?

O armazenamento de objetos elimina a complexidade da hierarquia de diretórios, usando um espaço de endereçamento simples (Single Namespace). Um objeto contém os dados do usuário, seus metadados (como tamanho, data e permissões), e um ID de objeto exclusivo, gerado por uma função de hash que garante sua unicidade. Isso permite que os dados sejam distribuídos de forma eficiente e recuperados de maneira rápida e segura dos OSDs, desde que você possua o ID em questão e as devidas permissões de acesso.

- **Upload**: Quando um aplicativo envia um arquivo para o sistema OSD, o arquivo é dividido em dados do usuário e metadados.
- **Geração de ID**: O sistema OSD gera um ID de objeto exclusivo com base nos dados do arquivo.
- **Armazenamento**: Os metadados e o ID do objeto são armazenados no servidor de metadados, enquanto os dados do usuário (o próprio objeto) são armazenados no dispositivo de armazenamento.
- **Confirmação**: O sistema confirma que o objeto foi armazenado com sucesso e envia uma resposta ao aplicativo, que pode guardar o ID em um banco relacional ou não relacional para posterior solicitação/recuperação.
- **Solicitação**: O aplicativo solicita um arquivo pelo seu ID de objeto.
- **Busca de Metadados**: O sistema recupera o ID do objeto através do servidor de metadados.
- **Recuperação do Objeto**: O ID do objeto é usado para recuperar os dados armazenados, que são então enviados de volta ao aplicativo.

### Principais Casos de Uso

O armazenamento em objetos é ideal para cenários como:

- **Armazenamento em Nuvem**: Com o suporte para APIs baseadas em **REST** (Representational State Transfer) e **SOAP** (Simple Object Access Protocol), o armazenamento de objetos facilita o acesso de múltiplos usuários e plataformas de maneira eficiente e segura.
- **Arquivamento de Conteúdos**: Sistemas como **CAS** (Content Addressable Storage) são otimizados para armazenar grandes volumes de conteúdo fixo, como arquivos de imagem médica e registros financeiros, com alta integridade e políticas de retenção rígidas.
- **Metadados**: Cada objeto pode conter metadados personalizados, que tornam o processo de gerenciamento e busca mais eficiente, proporcionando mais controle sobre o conteúdo armazenado.
- **Endereçamento via URL**: Cada objeto é acessível por meio de uma URL única, o que facilita sua localização e acesso, especialmente em ambientes distribuídos e em nuvem.

Nos últimos anos, o armazenamento de objetos tem se tornado uma peça fundamental na composição de **datalakes** e fluxos de trabalho para **big data**, devido à sua capacidade de armazenar grandes volumes de dados em diversos formatos e acessá-los de maneira eficiente. Ele é amplamente utilizado em ecossistemas de big data para suportar arquiteturas distribuídas, onde ferramentas como **Apache Spark**, **Airflow** e **Kafka** são frequentemente integradas para processar, orquestrar e analisar grandes conjuntos de dados. Um exemplo típico desse ecossistema inclui:

- **Apache Airflow**: Para orquestração de fluxos de trabalho complexos e automação de pipelines de dados.
- **Apache Spark**: Para processamento de dados em larga escala, incluindo operações de **ETL** (extração, transformação e carga) e análise de dados massivos.
- **Apache Kafka**: Para ingestão de dados em tempo real, permitindo o processamento contínuo de streams de dados.
- **MinIO**: Para armazenamento escalável de objetos, facilitando o gerenciamento de grandes volumes de dados não estruturados.

## Prática com MinIO

**MinIO** é uma solução de armazenamento de objetos de alto desempenho compatível com a API do Amazon S3 (Simple Storage Service), um serviço de armazenamento de objetos da Amazon Web Services (AWS), projetado para armazenar e recuperar qualquer quantidade de dados de qualquer lugar na Internet, cujos principais conceitos estão listados a seguir: 

- **Buckets**: Contêineres onde os objetos são armazenados.
- **Objetos**: Unidades de dados que são armazenadas nos buckets.
- **Chaves**: Identificadores únicos para cada objeto dentro de um bucket.
- **Metadados**: Informações adicionais armazenadas com cada objeto.

Cada objeto dentro de um bucket é identificado por uma chave única, que funciona como o caminho completo para o arquivo, similar a um nome de arquivo em um sistema de arquivos tradicional. O MinIO foi projetado para aplicações de grande escala e pode ser usado tanto em infraestruturas de nuvem quanto em ambientes on-premises.

### Benefícios do MinIO

- **Compatibilidade com S3**: Totalmente compatível com a API S3 da AWS.
- **Alto Desempenho**: Ideal para workloads intensivos em dados.
- **Facilidade de Uso**: Interface web intuitiva e fácil configuração.
- **Segurança**: Suporte para criptografia em repouso e em trânsito.

### Operações Comuns

- **PUT**: Adicionar ou substituir um objeto em um bucket.
- **GET**: Recuperar um objeto de um bucket.
- **DELETE**: Remover um objeto de um bucket.
- **LIST**: Listar objetos em um bucket.

## Configuração com Docker

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
      - minio-data:/data        # Volume para dados do MinIO
      - minio-backup:/backup    # Volume para armazenar backups
    command: server /data --console-address ":9001"

volumes:
  minio-data:
  minio-backup:
```

### Leitura e Gravação de Arquivos

O MinIO utiliza uma API compatível com S3 para realizar operações via chamadas HTTP, como upload, download, criação de buckets e listagem de arquivos, de forma semelhante à AWS. Para usar o MinIO com Python, a biblioteca recomendada é o Boto3, que facilita a comunicação com o servidor MinIO. O nome "Boto" faz referência ao boto-cor-de-rosa, um golfinho da Amazônia, escolhido de forma divertida por Mitch Garnaat, criador da biblioteca, comparando-a ao boto navegando pelos serviços da nuvem.

### Instalação da Boto3

Você pode instalar a Boto3 usando o pip:  

```python

pip install boto3

```

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

O armazenamento baseado em objetos é uma solução robusta e versátil para gerenciar o crescimento exponencial de dados não estruturados. Com segurança, escalabilidade e flexibilidade, ele é ideal para aplicações modernas, como serviços de nuvem, arquivamento de longo prazo e gerenciamento de dados críticos.

Nesse contexto, o MinIO, compatível com a API S3, tem se destacado como uma solução eficiente e escalável, sendo amplamente adotado em ambientes on-premises e híbridos para criar datalakes que suportam ecossistemas de big data, facilitando o armazenamento, acesso e processamento de dados massivos.

Recomenda-se explorar o MinIO para testar essas funcionalidades em um ambiente controlado antes de migrar para soluções externas, como o Amazon S3. Esse método ajuda a validar fluxos de trabalho e garante desde o começo de seus projetos uma infraestrutura escalável e eficiente, numa arquitetura cloud-native. Para mais informações, consulte a documentação oficial do [MinIO](https://min.io/docs/).
