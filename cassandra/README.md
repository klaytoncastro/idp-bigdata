# Apache Cassandra

Apache Cassandra é um sistema de gerenciamento de banco de dados NoSQL distribuído, projetado para lidar com grandes quantidades de dados em muitos servidores de commodity, proporcionando alta disponibilidade sem um único ponto de falha.

## Características

- **Distribuído**: o Cassandra é projetado para ser distribuído em muitos servidores, proporcionando alta disponibilidade e escalabilidade.
- **Suporte a Queries CQL**: o Cassandra usa uma linguagem de consulta chamada CQL (Cassandra Query Language) que é semelhante ao SQL.
- **Escalabilidade Horizontal**: o Cassandra é projetado para ser escalado horizontalmente, adicionando mais servidores à medida que a carga de trabalho aumenta.
- **Resistente a Falhas**: o Cassandra é resistente a falhas, com backups e replicações automáticas para garantir que os dados não sejam perdidos.

## Apache Cassandra Query Language (CQL)

O Apache Cassandra Query Language (CQL) é a linguagem de consulta utilizada para interagir com o Cassandra. Ela possui uma sintaxe semelhante ao SQL, mas há algumas diferenças importantes a serem observadas:

A criação de tabelas no Cassandra envolve a definição de uma chave primária, que é crucial para o modelo de dados distribuído do Cassandra.

Consultas CQL podem ser executadas para recuperar dados de acordo com a chave primária e outras condições, mas agregações complexas e operações de junção (join) não são suportadas nativamente como no SQL.

O CQL é otimizado para operações de leitura e gravação eficientes, tornando-o adequado para cenários de alto desempenho.

## Apache Cassandra Data Model

O Apache Cassandra armazena dados em um modelo de chave-valor distribuído, onde os dados são organizados em tabelas. Cada tabela possui uma chave primária que define como os dados são distribuídos pelos nós do cluster. O modelo de dados do Cassandra é projetado para permitir consultas eficientes e alta escalabilidade. O modelo de dados do Cassandra é projetado para lidar com a escalabilidade horizontal e é otimizado para consultas de leitura eficientes. Modelar dados no Cassandra requer uma compreensão das necessidades de consulta e distribuição

## Apache Cassandra Query Language (CQL) versus SQL
Embora o CQL e o SQL compartilhem algumas semelhanças em sua sintaxe, eles têm diferenças significativas em termos de funcionalidade e uso. O CQL é otimizado para bancos de dados distribuídos como o Cassandra, enquanto o SQL é mais voltado para bancos de dados relacionais. Portanto, ao trabalhar com o Cassandra, é importante entender as peculiaridades do CQL e como ele se relaciona com o modelo de dados distribuído do Cassandra.

## Apache Cassandra Consistency Levels
O Apache Cassandra oferece níveis de consistência que permitem controlar o equilíbrio entre consistência e disponibilidade dos dados. É importante entender esses níveis de consistência ao projetar pipelines de dados para garantir que os dados sejam tratados conforme as necessidades do seu aplicativo.

## Acesso à Interface Web do Apache Cassandra
Você pode acessar a interface web do Apache Cassandra usando o "Cassandra Web Console". Aqui estão os passos para acessar e usar a interface web:

Abra um navegador da web e acesse `http://localhost:3000` para acessar o Cassandra Web Console.


## Acesso ao CLI do Apache Cassandra

Você também pode interagir com o Apache Cassandra por meio do comando-line (CLI). Aqui estão os passos para acessar o CLI do Cassandra: 

```shell
docker exec -it cassandra-container cqlsh
```

## Guia Básico: Cassandra Query Language (CQL)

O Cassandra Query Language (CQL) permite que você consulte, atualize e manipule dados no Apache Cassandra. Aqui estão alguns exemplos de comandos:

```sql
-- Mostrar todos os keyspaces (equivalente a bancos de dados)
DESCRIBE KEYSPACES;

-- Criar Keyspace
CREATE KEYSPACE AulaDemo
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};


-- Selecionar um keyspace
USE AulaDemo;

-- Criar um keyspace
CREATE KEYSPACE IF NOT EXISTS AulaDemo2 WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

-- Apagar um keyspace
DROP KEYSPACE IF EXISTS AulaDemo;

-- Mostrar todas as tabelas em um keyspace
DESCRIBE TABLES;

-- Criar uma tabela chamada "Estudantes"
CREATE TABLE IF NOT EXISTS Estudantes (
    id UUID PRIMARY KEY,
    nome TEXT,
    idade INT,
    curso TEXT,
    email TEXT
);

-- Inserir um registro na tabela "Estudantes"
INSERT INTO Estudantes (id, nome, idade, curso, email) VALUES (uuid(), 'João Leite', 22, 'Engenharia da Computação', 'joao.leite@email.com');

-- Inserir vários registros na tabela "Estudantes"
INSERT INTO Estudantes (id, nome, idade, curso, email) VALUES (uuid(), 'Domitila Canto', 22, 'Letras', 'domitila.canto@email.com');

-- Selecionar todos os registros da tabela "Estudantes"
SELECT * FROM Estudantes;

-- Atualizar um registro na tabela "Estudantes"
UPDATE Estudantes SET idade = 23 WHERE nome = 'João Leite';

-- Apagar um registro na tabela "Estudantes"
DELETE FROM Estudantes WHERE nome = 'Domitila Canto';

-- Consultar todos os registros na tabela "estudantes"
SELECT * FROM estudantes;

-- Consultar estudantes com idade maior ou igual a 18
SELECT * FROM estudantes WHERE idade >= 18;

-- Consultar estudantes pelo nome
SELECT * FROM estudantes WHERE nome = 'João Leite';

-- Inserir um novo estudante na tabela "estudantes"
INSERT INTO estudantes (id, nome, idade, curso, email) VALUES (uuid(), 'João Leite', 22, 'Engenharia da Computação', 'joao.leite@email.com');

-- Inserir um novo estudante na tabela "estudantes" com um identificador gerado automaticamente
INSERT INTO estudantes (nome, idade, curso, email) VALUES ('Domitila Canto', 22, 'Letras', 'domitila.canto@email.com');

-- Atualizar a idade de um estudante com base no nome
UPDATE estudantes SET idade = 23 WHERE nome = 'João Leite';

-- Atualizar o curso de um estudante com base no nome
UPDATE estudantes SET curso = 'Ciência da Computação' WHERE nome = 'Domitila Canto';

-- Excluir um estudante com base no nome
DELETE FROM estudantes WHERE nome = 'João Leite';

-- Excluir todos os estudantes com idade menor que 20
DELETE FROM estudantes WHERE idade < 20;
```

## Administração do Ambiente no Cassandra

### Importação de Dados

O Apache Cassandra oferece uma variedade de métodos para importar dados de fontes externas para suas tabelas. Um desses métodos é o cqlsh, a ferramenta de linha de comando do Cassandra. Você pode usar o cqlsh para executar instruções CQL (Cassandra Query Language) e, assim, inserir dados em suas tabelas a partir de arquivos externos, como CSV ou outros formatos. Exemplo de uso:

```
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

O Apache Cassandra fornece ferramentas para fazer backup de seus dados, o que é crucial para a recuperação de dados em caso de falhas ou erros de operação. Você pode usar o nodetool para criar backups completos ou incrementais de seus nós Cassandra. Exemplo de uso:

```bash
nodetool snapshot -t nome_do_snapshot MeuBancoDeDados
```

Em seguida, você pode usar o `sstableloader`` para restaurar dados a partir de um snapshot em um nó Cassandra ou em um novo cluster.

## Outras Considerações e Ferramentas

Além das ferramentas de linha de comando, você pode explorar outras opções para administrar e interagir com o Apache Cassandra:

DataStax DevCenter: É uma GUI (Interface Gráfica de Usuário) que oferece uma experiência visual para criar, editar e consultar dados no Cassandra.

Apache Cassandra GUIs: Existem várias ferramentas de terceiros, como o "Cassandra Query Browser," que fornecem interfaces gráficas para gerenciamento e consulta de dados no Cassandra.

DataStax Astra: É um serviço de banco de dados gerenciado baseado no Cassandra oferecido pela DataStax. Ele fornece uma maneira fácil de implantar e gerenciar clusters Cassandra na nuvem.

## Conclusão

Esta documentação fornece uma visão geral dos aspectos essenciais do Apache Cassandra, um sistema de gerenciamento de banco de dados NoSQL altamente escalável. Exploramos métodos de importação de dados, backup e restauração, bem como outras ferramentas para administração do ambiente Cassandra. Se você deseja aprofundar seu conhecimento, consulte a documentação oficial