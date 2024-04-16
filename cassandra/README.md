# Apache Cassandra

Apache Cassandra é um sistema de gerenciamento de banco de dados NoSQL distribuído, projetado para lidar com grandes quantidades de dados em múltiplos servidores *commodity*, proporcionando alta disponibilidade e tolerância à falha. Por essa razão, tem sido escolhido por grandes empresas do mercado para hospedar seus serviços, como Netflix, Apple, e Facebook, com objetivo de gerenciar volumes massivos de dados e lidar com milhares de solicitações por segundo de modo eficiente, eficaz e seguro. 

## Características

- **Distribuído**: o Cassandra é projetado para ser distribuído em muitos servidores, proporcionando alta disponibilidade e escalabilidade.
- **Escalabilidade Horizontal**: o Cassandra é projetado para ser escalado horizontalmente, adicionando mais servidores à medida que a carga de trabalho aumenta.
- **Resistente a Falhas**: o Cassandra é resistente a falhas, com backups e replicações automáticas para garantir que os dados não sejam perdidos.
- **Orientado a Colunas**: Organiza dados por colunas, em vez de linhas, como é comum em bancos de dados relacionais. Cada coluna é armazenada separadamente, o que traz benefícios para vários tipos de aplicações.
- **Suporte a Queries CQL**: o Cassandra usa uma linguagem de consulta chamada CQL (Cassandra Query Language) que guarda algumas semelhanças ao SQL.

## Apache Cassandra Consistency Levels

O Apache Cassandra permite ajustar o equilíbrio entre consistência e disponibilidade dos dados. Configurar esses níveis é essencial para projetar pipelines de dados adequados, assegurando que as operações de leitura e gravação atendam aos requisitos específicos dos sistemas suportados. 

Os níveis de consistência no Cassandra permitem aos desenvolvedores ajustar a precisão e a latência das respostas das consultas de acordo com as necessidades específicas da aplicação: 

- ONE: A operação é considerada bem-sucedida após o retorno de um único nó. É o mais rápido, mas também o menos consistente.

- QUORUM: A maioria dos nós deve responder para que a operação seja bem-sucedida. Isso garante uma boa consistência e tolerância a falhas.

- ALL: Todos os nós no cluster de replicação devem responder. Isso garante a consistência mais forte possível, mas pode reduzir a disponibilidade se qualquer nó estiver inativo.

- TWO, THREE, etc.: Variações entre ONE e QUORUM, onde um número específico de respostas de nós é necessário.

- LOCAL_QUORUM: Um quórum de nós no mesmo data center local deve responder. Isso é útil em configurações de múltiplos data centers.

- EACH_QUORUM: Em uma configuração de múltiplos data centers, um quórum de nós em cada data center deve responder.

Por exemplo, usar o nível de consistência QUORUM para leituras e escritas pode ajudar a garantir que os dados lidos sejam consistentes em mais de 50% dos nós, reduzindo o risco de leituras obsoletas em um ambiente altamente distribuído. Em contrapartida, operações com o nível de consistência ONE podem ter latências mais baixas e um risco maior de inconsistências temporárias.

No lado servidor, você pode ter acesso a essas configurações no arquivo `/etc/cassandra/cassandra.yaml`. Contudo, em nosso laboratório, para fins de simplificação do ambiente e recursos, estamos executando o Cassandra com apenas um nó.

## Arquitetura Colunar

Esta arquitetura oferece otimização para sistemas onde leituras e consultas agregadas são frequentes, como sistemas de análise de dados (Data Warehousing). Ler uma coluna inteira para uma agregação (como soma ou média) não requer a leitura de outros dados irrelevantes, o que seria inevitável em uma arquitetura baseada em registros (linhas).

Além disso, as colunas tendem a armazenar dados semelhantes, o que permite técnicas de compressão mais eficazes, reduzindo o uso de espaço em disco e melhorando o desempenho. Em cargas de trabalho com muitas colunas, mas com apenas um subconjunto frequentemente acessado, os bancos de dados colunares evitam o custo de carregar dados desnecessários em memória.

Essas características tornam os bancos de dados colunares uma escolha excelente para big data analytics, relatórios em tempo real e sistemas de processamento de eventos, incluindo sensores IoT. 

## Modelagem de Dados 

A modelagem de dados para um ambiente NoSQL colunar como o Cassandra requer uma compreensão das necessidades de consulta e distribuição da aplicação. A estrutura de famílias de colunas deve ser pensada para otimizar cenários de alta escalabilidade e eficiência em consultas, aproveitando a arquitetura de chave-valor distribuída. 

Nessa arquitetura, os dados são organizados em tabelas orientadas a colunas. Cada tabela possui uma chave primária que define como os dados são distribuídos pelos nós do cluster. Ao contrário de bancos de dados relacionais, no Cassandra, você modelaria os dados com base nas consultas que você mais realiza, evitando junções e normalmente denormalizando os dados.

Por exemplo, em um sistema de e-commerce que requer armazenamento de informações sobre usuários, produtos e pedidos, no modelo relacional, você poderia ter três tabelas principais:

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

A linguagem Cassandra Query Language (CQL) é otimizada para operações de leitura e gravação eficientes. Possui uma sintaxe que guarda semelhanças ao SQL, mas há algumas diferenças importantes a serem observadas:

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

- Você pode fazer contagens simples por chave de partição, mas agregações complexas sobre grandes volumes de dados requerem uma abordagem diferente, frequentemente envolvendo o processamento externo dos dados. Neste caso, geralmente contamos com uma ferramenta externa, por exemplo, Apache Spark atuando junto com o Cassandra. 


## Laboratório 

Agora vamos para a prática! Execute os contêineres do Cassandra (DB e GUI) e conclua o roteiro a seguir. Se este for seu primeiro acesso, vá até o diretório `/opt/idp-bigdata/mongodb` e certifique-se que o script `wait-for-it.sh` tenha permissão de execução: 

```bash
cd /opt/idp-bigdata/cassandra
chmod +x wait-for-it.sh
```

```bash
docker-compose up -d
```

Verifique se os contêineres estão ativos e sem erros de implantação: 

```bash
docker ps
docker-compose logs
```

## Acesso à GUI 

Abra um navegador da web e acesse `http://localhost:3000/#/main` para vistualizar o Cassandra Web, a interface web adicional que foi disponibilizada como GUI em nosso `docker-compose.yml`. 

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
-- Selecionar um keyspace
USE AulaDemo;
```

```sql
-- Criar um keyspace
CREATE KEYSPACE IF NOT EXISTS AulaDemo WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
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
-- Mostrar todas as tabelas em um keyspace
DESCRIBE TABLES;
```

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

## Administração do Ambiente no Cassandra

### Importação de Dados

O Apache Cassandra oferece métodos para importar dados de fontes externas para suas tabelas. Um desses métodos é utilizar o próprio CQL Shell, a ferramenta de linha de comando do Cassandra. Você pode usar o `cqlsh` para executar instruções CQL (Cassandra Query Language) e, assim, inserir dados em suas tabelas a partir de arquivos externos, como CSV ou outros formatos. Exemplo de uso:

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

Esta documentação fornece uma visão geral dos aspectos essenciais do Apache Cassandra, um sistema de gerenciamento de banco de dados NoSQL altamente escalável. Exploramos métodos de importação de dados, backup e restauração, bem como outras ferramentas para administração do ambiente Cassandra. Se você deseja aprofundar seu conhecimento, consulte também a documentação oficial. 