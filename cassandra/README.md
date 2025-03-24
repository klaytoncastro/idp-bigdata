# Apache Cassandra

Apache Cassandra é um sistema de gerenciamento de banco de dados NoSQL distribuído, projetado para lidar com grandes volumes de dados em múltiplos servidores commodity, oferecendo alta disponibilidade e tolerância a falhas.

Um servidor commodity é construído usando componentes de hardware padronizados e facilmente substituíveis, que são amplamente disponíveis no mercado e geralmente baseados em arquiteturas populares como x86_64.

Esses servidores são menos caros do que suas contrapartes especializadas, como os mainframes de arquitetura RISC, que utilizam processadores de marcas como Sun Sparc, IBM Power e Hitachi. Além disso, são projetados para serem facilmente escaláveis e mantidos em clusters dedicados a aplicações distribuídas de grande escala.

Os recursos de Alta Disponibilidade (HA) e Tolerância a Falhas (FT) são proporcionados pelo software de forma mais eficiente do que pelo hardware especializado em plataformas de alta performance. Isso significa que, embora o hardware commodity possa falhar com mais frequência, o software adequado compensa essa desvantagem, tornando tais falhas aceitáveis.

Por essas razões, bancos de dados NoSQL como o Cassandra têm sido crescentemente adotados por grandes empresas, incluindo Netflix, Apple e Facebook. Eles escolhem essas soluções para hospedar seus serviços devido à capacidade de gerenciar volumes massivos de dados e lidar com milhares de solicitações por segundo de maneira mais eficiente, eficaz e segura, mesmo utilizando servidores commodity.

## Características

- **Distribuído**: o Cassandra é projetado para ser distribuído em muitos servidores, proporcionando alta disponibilidade e escalabilidade.
- **Escalabilidade Horizontal**: o Cassandra é projetado para ser escalado horizontalmente, adicionando mais servidores à medida que a carga de trabalho aumenta.
- **Tolerante a Falhas**: o Cassandra é tolerante a falhas, com backups e replicações automáticas para garantir que os dados não sejam perdidos.
- **Orientado a Colunas**: Organiza dados por colunas, em vez de linhas, como é comum em bancos de dados relacionais. Cada coluna é armazenada separadamente, o que traz benefícios para vários tipos de aplicações.

- **Suporte a Queries CQL**: o Cassandra usa uma linguagem de consulta chamada CQL (Cassandra Query Language) que guarda algumas semelhanças ao SQL.

## Consistency Levels

O Cassandra oferece a flexibilidade para equilibrar as necessidades de consistência e disponibilidade dos dados. Configurar esses níveis é crucial para desenvolver pipelines de dados eficazes, garantindo que as operações de leitura e gravação cumpram com os requisitos específicos dos sistemas suportados. Os níveis de consistência permitem que os desenvolvedores ajustem o comportamento do SGBD com base nas necessidades da aplicação: 

- **ONE**: A operação é considerada concluída após a confirmação de um único nó. Este é o modo mais rápido, porém o menos consistente.

- **QUORUM**: A maioria dos nós deve confirmar para que a operação seja considerada bem-sucedida. Isso assegura uma boa consistência e tolerância a falhas.

- **ALL**: Todos os nós no cluster de replicação devem confirmar. Isso proporciona a maior consistência possível, mas pode comprometer a disponibilidade se algum nó estiver indisponível.

- **TWO, THREE**, *etc.*: Variações entre ONE e QUORUM, exigindo um número específico de confirmações de nós.

- **LOCAL_QUORUM**: Um quórum de nós no mesmo data center deve confirmar. Esta configuração é útil em ambientes com múltiplos data centers.

- **EACH_QUORUM**: Em uma configuração com múltiplos data centers, um quórum de nós em cada data center deve confirmar.

Por exemplo, utilizar o nível de consistência QUORUM para leituras e escritas pode ajudar a garantir que os dados lidos sejam consistentes em mais de 50% dos nós, reduzindo o risco de leituras desatualizadas em um ambiente altamente distribuído. Por outro lado, operações com o nível de consistência ONE podem apresentar latências mais baixas, mas com maior risco de inconsistências temporárias.

No lado do servidor, essas configurações podem ser acessadas no arquivo `/etc/cassandra/cassandra.yaml`. No entanto, em nosso laboratório, para simplificar o ambiente e os recursos, estamos operando o Cassandra em um único nó.

## Arquitetura Colunar

Combinando alta eficiência, escalabilidade e redução de custos, os sistemas baseados em arquitetura colunar estão se tornando o núcleo de muitas soluções modernas de processamento de dados e inteligência de negócios. Ela é otimizada para atender sistemas onde leituras e consultas agregadas são frequentes, como é o caso dos sistemas analíticos de inteligência de negócios (Data Warehousing). 

Em uma arquitetura colunar, ler uma coluna inteira para realizar uma agregação (como soma ou média) não exige a leitura de outros dados irrelevantes ao contexto, o que seria inevitável em uma arquitetura baseada em registros (linhas). Além disso, as colunas tendem a armazenar dados semelhantes, o que favorece a implementação de técnicas de compressão mais eficazes. Isso não apenas reduz o uso de espaço em disco, mas também melhora o desempenho. 

Em um sistema gerenciador com organização orientada às colunas, quando um subconjunto de dados é tipicamente mais acessado, evita-se o custo de carregar dados desnecessários na memória ou o acesso à disco para recuperação dos dados mais frequentemente utilizados. 

Essas características tornam os bancos de dados colunares uma escolha excelente para big data analytics, relatórios em tempo real e sistemas de processamento de eventos complexos, incluindo aqueles que envolvem sensores IoT. Eles são ideais para cenários onde a eficiência na consulta de grandes volumes de dados é crítica, pois permitem análises mais rápidas e menos onerosas em termos de recursos computacionais. 

Esta arquitetura também facilita a implementação da escalabilidade horizontal, permitindo que as organizações expandam sua capacidade processamento e armazenamento de dados adicionando mais servidores, o que é particularmente útil em ambientes de nuvem, onde a demanda por recursos pode flutuar significativamente durante determinados períodos. 

## Modelagem de Dados 

A modelagem de dados para um ambiente NoSQL colunar como o Cassandra requer uma compreensão preliminar das necessidades de consulta e distribuição da aplicação. A estrutura de famílias de colunas deve ser pensada para otimizar cenários de alta escalabilidade e eficiência em consultas, aproveitando a arquitetura de chave-valor distribuída. Cada tabela possui uma chave primária que define como os dados são distribuídos pelos nós do cluster. 

Ao contrário de bancos de dados relacionais, no Cassandra, você modelaria os dados com base nas consultas que você mais realiza, evitando junções e normalmente denormalizando os dados. Por exemplo, em um sistema de e-commerce que requer armazenamento de informações sobre usuários, produtos e pedidos, no modelo relacional, você poderia ter três tabelas principais:

- Usuários
- Produtos
- Pedidos

Cada pedido poderia ter uma chave estrangeira (FK) vinculando-o a um usuário e a múltiplos produtos através de uma tabela de associação Pedido_Produtos para representar um relacionamento muitos-para-muitos.

```sql

CREATE TABLE Usuarios (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE Produtos (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    preco DECIMAL
);

CREATE TABLE Pedidos (
    id INT PRIMARY KEY,
    usuario_id INT,
    data_pedido DATE,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

CREATE TABLE Pedido_Produtos (
    pedido_id INT,
    produto_id INT,
    quantidade INT,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);

```

Já no Cassandra, se você frequentemente recupera todos os pedidos de um usuário, a recomendação inicial de uma modelagem já incluiria os detalhes do produto diretamente na tabela de pedidos:

```sql

-- Quando você define uma coleção como FROZEN, o Cassandra trata a coleção inteira como um único valor imutável. Isso significa que, para atualizar qualquer elemento dentro da coleção, você precisa substituir toda a coleção, não apenas o elemento individual. A coleção FROZEN é serializada como um único valor em um campo, o que ajuda na eficiência de armazenamento e recuperação, mas pode limitar a flexibilidade na manipulação de dados da coleção.

CREATE TABLE Pedidos (
    usuario_id INT,
    pedido_id INT,
    data_pedido DATE,
    produtos LIST<FROZEN<Produto>>,  // Produto é um tipo definido pelo usuário contendo nome, preço, e quantidade
    PRIMARY KEY (usuario_id, pedido_id)
);

```

## Cassandra Query Language (CQL)

A linguagem Cassandra Query Language (CQL)possui uma sintaxe que guarda semelhanças ao SQL, mas há algumas diferenças importantes a serem observadas:

- A criação de tabelas no Cassandra envolve a definição de uma chave primária, que é crucial para manutenção do modelo de dados distribuído. As consultas CQL podem ser executadas para recuperar dados de acordo com a chave primária e outras condições, mas agregações complexas e operações de junção (JOINs) não são nativamente suportadas assim como no SQL.

- Já no SQL, os JOINs são usados para combinar linhas de duas ou mais tabelas baseadas em uma relação entre elas, o que é extremamente útil para normalizar bancos de dados e evitar a duplicação de informações.

```sql
-- Neste exemplo, uma tabela de funcionários (employees) é unida com uma tabela de departamentos (departments) para trazer o nome do departamento de cada funcionário. Essa é uma operação comum em bancos de dados relacionais.

SELECT employees.name, employees.department_id, departments.name
FROM employees
JOIN departments ON employees.department_id = departments.department_id;

```

- O Cassandra não suporta operações complexas de JOIN devido ao seu design distribuído. Se você precisar realizar uma operação similar no Cassandra, seria interessante denormalizar os dados ou fazer múltiplas consultas na aplicação (o que pode ser menos eficiente). Para simular o mesmo resultado do SQL acima, você poderia ter uma única tabela que incluiria tanto os dados dos funcionários quanto dos departamentos:

```sql

CREATE TABLE employees (
    employee_id UUID PRIMARY KEY,
    name TEXT,
    department_id INT,
    department_name TEXT
);

SELECT name, department_name FROM employees WHERE department_id = 101;

```

- Operações de agregação como `SUM()`, `AVG()`, e `COUNT()` são fundamentais em SQL para análise de dados: 

```sql
-- Este comando SQL conta o número de funcionários em cada departamento, uma operação de agregação típica em bancos de dados relacionais.

SELECT department_id, COUNT(*) AS num_employees
FROM employees
GROUP BY department_id;
```

- Cassandra suporta algumas funções de agregação, mas seu uso é limitado e não tão flexível quanto em SQL, especialmente quando se trata de agrupar dados distribuídos por vários nós. Você pode contar o número de funcionários em um departamento específico, mas fazer isso de forma agregada por todos os departamentos não é diretamente suportado como uma única operação eficiente: 

```sql

SELECT COUNT(*) FROM empregados WHERE departamento_id = '123';
```

- Você pode fazer contagens simples por chave de partição, mas agregações complexas sobre grandes volumes de dados requerem uma abordagem diferente, podendo incluir uso de ferramentas complementares, por exemplo, o Apache Spark. 

## Laboratório 

Agora vamos para a prática! Execute os contêineres do Cassandra (DB e GUI) e conclua o roteiro a seguir. Se este for seu primeiro acesso, vá até o diretório `/opt/idp-bigdata/cassandra` e certifique-se que o script `wait-for-it.sh` tenha permissão de execução: 

```bash
cd /opt/idp-bigdata/cassandra
chmod +x wait-for-it.sh
```

Agora suba os contêineres: 

```bash
docker-compose up -d
```

Verifique se eles estão ativos e sem erros de implantação: 

```bash
docker ps
docker-compose logs
```

## Acesso à GUI 

Abra um navegador da web e acesse `http://localhost:3000/#/main` para visualizar o Cassandra Web, a interface web complementar que foi disponibilizada como GUI em nosso `docker-compose.yml`. Para quem está utilizando a VM do Virtual Box, lembre-se de configurar o NAT para tornar disponível a porta 3000 ao computador hospedeiro. 

## Acesso à CLI 

Você também pode interagir com o Cassandra por meio da comando-line (CLI). Aqui estão os passos para acessar a CLI do Cassandra (CQL Shell): 

```shell
docker exec -it cassandra-container cqlsh
```

## Guia Básico: Cassandra Query Language (CQL)

O Cassandra Query Language (CQL) permite que você consulte, atualize e manipule dados no Apache Cassandra. Aqui estão alguns exemplos de comandos:

```sql
-- Mostrar todos os keyspaces (equivalente a bancos de dados)
DESCRIBE KEYSPACES;
```

```sql
-- Criar Keyspace
CREATE KEYSPACE AulaDemo
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
```

```sql
-- Criar um keyspace
CREATE KEYSPACE IF NOT EXISTS AulaDemo WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
```

```sql
-- Selecionar um keyspace
USE AulaDemo;
```

<!--

Em um ambiente de produção, você geralmente deseja uma estratégia de replicação mais robusta para garantir alta disponibilidade e tolerância a falhas. Uma estratégia comum é usar o NetworkTopologyStrategy em vez da SimpleStrategy, especialmente em um ambiente de vários datacenters.

Aqui está um exemplo de como você poderia definir um keyspace em produção com o NetworkTopologyStrategy:

```sql
CREATE KEYSPACE IF NOT EXISTS AulaDemo2 
WITH replication = {'class': 'NetworkTopologyStrategy', 'DC1': 3, 'DC2': 2};
```

Neste exemplo:

NetworkTopologyStrategy é a estratégia de replicação usada.
'DC1': 3 indica que os dados devem ser replicados em três réplicas dentro do datacenter chamado 'DC1'.
'DC2': 2 indica que os dados também devem ser replicados em duas réplicas dentro do datacenter chamado 'DC2'.
Essa configuração é mais robusta porque espalha as réplicas por vários datacenters, proporcionando maior redundância e tolerância a falhas em comparação com a SimpleStrategy. No entanto, é importante adaptar a configuração de replicação de acordo com os requisitos específicos de disponibilidade e desempenho do seu aplicativo e com a arquitetura do seu ambiente de produção.

-->

```sql
-- Criar uma tabela chamada "Estudantes"
CREATE TABLE IF NOT EXISTS Estudantes (
    id UUID PRIMARY KEY,
    nome TEXT,
    idade INT,
    curso TEXT,
    email TEXT
);
```

```sql
-- Mostrar todas as tabelas em um keyspace
DESCRIBE TABLES;
```

```sql
-- Inserir um registro na tabela "Estudantes"
INSERT INTO Estudantes (id, nome, idade, curso, email) VALUES (uuid(), 'João Leite', 22, 'Engenharia da Computação', 'joao.leite@email.com');
```

```sql
-- Inserir vários registros na tabela "Estudantes"
INSERT INTO Estudantes (id, nome, idade, curso, email) VALUES (uuid(), 'Domitila Canto', 22, 'Letras', 'domitila.canto@email.com');
```

```sql
-- Selecionar todos os registros da tabela "Estudantes"
SELECT * FROM Estudantes;
```

```sql
-- Atualizar um registro na tabela "Estudantes"
UPDATE Estudantes SET idade = 23 WHERE nome = 'João Leite';
```

```sql
-- Apagar um registro na tabela "Estudantes"
DELETE FROM Estudantes WHERE nome = 'Domitila Canto';
```

```sql
-- Consultar todos os registros na tabela "estudantes"
SELECT * FROM estudantes;
```

```sql
-- Consultar estudantes com idade maior ou igual a 18
SELECT * FROM estudantes WHERE idade >= 18;
```

```sql
-- Consultar estudantes pelo nome
SELECT * FROM estudantes WHERE nome = 'João Leite';
```

```sql
-- Inserir um novo estudante na tabela "estudantes"
INSERT INTO estudantes (id, nome, idade, curso, email) VALUES (uuid(), 'João Leite', 22, 'Engenharia da Computação', 'joao.leite@email.com');
```

```sql
-- Inserir um novo estudante na tabela "estudantes" com um identificador gerado automaticamente
INSERT INTO estudantes (nome, idade, curso, email) VALUES ('Domitila Canto', 22, 'Letras', 'domitila.canto@email.com');
```

```sql
-- Atualizar a idade de um estudante com base no nome
UPDATE estudantes SET idade = 23 WHERE nome = 'João Leite';
```

Como a coluna nome não faz parte da chave primária na tabela Estudantes, você não pode utilizá-la diretamente na cláusula `WHERE` para filtrar os dados e deve ter obtido um erro no comando acima. Alterar a estrutura da chave primária para incluir nome como parte da chave de clustering irá permitir a filtragem por nome:

```sql

ALTER TABLE Estudantes ADD PRIMARY KEY (id, nome);

```
Outra abordagem seria escrever um script para fazer a selecao e posterior delecao: 

```python
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
from cassandra import OperationTimedOut

# Configuração de autenticação e conexão
auth_provider = PlainTextAuthProvider(username='cassandra', password='cassandra')
cluster = Cluster(['172.23.0.2'], port=9042, auth_provider=auth_provider)

try:
    # Inicia a sessão de conexão
    session = cluster.connect()

    # Verifica se a conexão foi bem-sucedida executando uma consulta simples
    session.execute("SELECT * FROM system.local")
    print("Conexão estabelecida com sucesso!")

except OperationTimedOut:
    print("Falha na conexão ao servidor Cassandra")

finally:
    # Fecha a conexão
    if session:
        session.shutdown()
    if cluster:
        cluster.shutdown()
```

```sql
-- Atualizar o curso de um estudante com base no nome
UPDATE estudantes SET curso = 'Ciência da Computação' WHERE nome = 'Domitila Canto';
```

```sql
-- Excluir um estudante com base no nome
DELETE FROM estudantes WHERE nome = 'João Leite';
```

```sql
-- Excluir todos os estudantes com idade menor que 20
DELETE FROM estudantes WHERE idade < 20;
```

<!--

-- Apagar um keyspace
DROP KEYSPACE IF EXISTS AulaDemo;

-->

## Administração do Ambiente

### Importação de Dados

O Cassandra oferece métodos para importar dados de fontes externas para suas tabelas. Um dos mais práticos e usuais é utilizar o próprio CQL Shell. Você pode usar o `cqlsh` para executar instruções CQL (Cassandra Query Language) e, assim, inserir dados em suas tabelas a partir de arquivos externos, como `CSV` ou outros formatos. Exemplo de uso:

```csv
id,nome,idade,curso,email
1,João Leite,22,Engenharia da Computação,joao.leite@email.com
2,Domitila Canto,22,Letras,domitila.canto@email.com
3,Fernando Campos,22,Engenharia da Computação,fernando.campos@email.com
4,Mariano Rodrigues,20,Design Gráfico,mariano.rodrigues@email.com
5,Roberta Lara,23,Ciência da Computação,roberta.lara@email.com
6,Juliano Pires,21,Artes Visuais,juliano.pires@email.com
7,Felicia Cardoso,22,Matemática Aplicada,felicia.cardoso@email.com
8,Haroldo Ramos,22,Ciência da Computação,haroldo.ramos@email.com
9,Vladimir Silva,22,Engenharia da Computação,vladimir.silva@email.com
10,Deocleciano Oliveira,20,Design Gráfico,deocleciano.oliveira@email.com
```

```bash
cqlsh -e "COPY MeuBancoDeDados.MinhaTabela FROM 'caminho/para/arquivo.csv' WITH DELIMITER=',' AND HEADER=TRUE;"
```

### Backup e Restauração de Dados

O Apache Cassandra fornece ferramentas para realizar backup de seus dados, prática essencial para viabilizar a recuperação de dados em caso de falhas, erros de operação e desastres. Você pode usar o `nodetool` para criar backups completos ou incrementais de seus nós Cassandra. Exemplo de uso:

```bash
nodetool snapshot -t nome_do_snapshot MeuBancoDeDados
```

Em seguida, você pode usar o `sstableloader`` para restaurar dados a partir de um snapshot em um nó Cassandra ou em um novo cluster.

## Outras Considerações e Ferramentas

Além das ferramentas de linha de comando, você pode explorar outras opções para administrar e interagir com o Apache Cassandra:

DataStax DevCenter: É uma GUI (Interface Gráfica de Usuário) que oferece uma experiência visual para criar, editar e consultar dados no Cassandra.

DataStax Astra: É um serviço de banco de dados gerenciado baseado no Cassandra oferecido pela DataStax. Ele fornece uma maneira fácil de implantar e gerenciar clusters Cassandra na nuvem.

<!--

Apache Cassandra GUIs: Existem várias ferramentas de terceiros, como o "Cassandra Query Browser," que fornecem interfaces gráficas para gerenciamento e consulta de dados no Cassandra.

-->

<!--
## Desafio Spark: 

https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud

https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud/download?datasetVersionNumber=3

-->

## Conclusão

Esta documentação fornece uma visão geral dos aspectos essenciais do Apache Cassandra, um sistema de gerenciamento de banco de dados NoSQL colunar robusto e escalável. Exploramos métodos de importação de dados, backup e restauração, bem como outras ferramentas para administração do ambiente Cassandra. Se você deseja aprofundar seu conhecimento, consulte também a documentação oficial. 
