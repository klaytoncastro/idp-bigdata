# Introdução ao MongoDB e MongoDB Express

## Configurando o Ambiente

1. O dimensionamento apropriado de recursos depende das necessidades específicas do seu projeto. De modo a garantir um desempenho adequado e evitar problemas com os contêineres, ajuste a quantidade de memória nas configurações do VirtualBox conforme orientações abaixo. Lembre-se que para promover as alterações, sua VM deve estar desligada. 

- Se sua atividade estiver focada exclusivamente no MongoDB, é aconselhável alocar no mínimo 1536MB de RAM;
- Caso pretenda utilizar outras ferramentas, como o Jupyter em conjunto com o MongoDB, é recomendável alocar no mínimo 3072MB de RAM. 
- Se você planeja executar o Jupyter em conjunto com o MongoDB e Spark, é aconselhável alocar pelo menos 4096MB de RAM. valie também a possibilidade de acréscimo de processadores virtuais, de acordo com a capacidade de seu hardware Se você possui à disposição um sistema quad-core, configure a VM para utilizar 2 processadores. 

2. Após os promover os ajustes, inicie a VM. Lembre-se de garantir que você esteja trabalhando com a versão mais recente do repositório [IDP-BigData](https://github.com/klaytoncastro/idp-bigdata). Navegue até o diretório onde você clonou o repositório e obtenha as respectivas atualizações: 

```bash
cd /opt/idp-bigdata
git pull origin main
```

3. Se este for o primeiro acesso, vá até o diretório `/opt/idp-bigdata/mongodb` e certifique-se que o script `wait-for-it.sh` tenha permissão de execução: 

```bash
cd /opt/idp-bigdata/mongodb
chmod +x wait-for-it.sh
```

4. Execute os contêineres do MongoDB e MongoDB Express: 

```bash
docker-compose up -d
```

5. Verifique se os contêineres estão ativos e sem erros de implantação: 

```bash
docker ps
docker-compose logs
```

6. Para facilitar a referência na integração do MongoDB como outras ferramentas, tais como o Jupyter, ou uma API Flask, pode ser necessário verificar o endereço IP dos contêineres e a rede virtual na qual estão conectados. Neste caso, utilize os comandos abaixo: 

```bash
docker inspect <CONTAINER_ID> | grep IPAddress
docker network inspect <NETWORK_NAME>
```

## Guia Básico: MongoDB Query Language (MQL)

O MongoDB é um sistema gerenciados de banco de dados NoSQL orientado a documentos, que armazena dados em formato JSON (BSON). A linguagem de query do MongoDB (MQL) permite que você consulte, atualize e manipule documentos de forma eficiente. Dentre suas principais características, destacamos: 

- **Consulta Flexível:** Você pode realizar consultas flexíveis para recuperar documentos com base em campos específicos, operadores lógicos e outros critérios.

- **Suporte a Índices:** Índices podem ser criados para acelerar consultas e melhorar o desempenho.

- **Manipulação de Documentos:** Além de consultar dados, você pode inserir, atualizar e excluir documentos usando a mesma linguagem.

- **Aggregation Framework:** O MongoDB oferece um poderoso framework de agregação que permite realizar operações complexas de análise, agregação e construção de pipelines de dados.

### Exemplos de Comandos:

```javascript
//Mostrar todas as bases de dados
show dbs
```

```javascript
//Mostrar a base de dados atual
db
```

```javascript
//Mostrar todas as bases de dados
show dbs
```

```javascript
//Apagar a base de dados
db.dropDatabase()
```

```javascript
//Criar ou mudar de base de dados
use AulaDemo
```

```javascript
//Criar uma coleção chamada "Estudantes"
db.createCollection(Estudantes)
```

```javascript
//Mostrar as coleções
show collections
```

```javascript
//Inserir um registro
db.Estudantes.insert(
    {
        "nome": "Lucas Silva",
        "idade": 22,
        "curso": "Engenharia da Computação",
        "email": "lucas.silva@email.com"
        "data": Date()
    }
)
```

```javascript
//Inserir vários registros
db.<nome_da_colecao>.insertMany([
    {
        "nome": "Mariana Oliveira",
        "idade": 20,
        "curso": "Design Gráfico",
        "email": "mariana.oliveira@email.com"
    },
    {
        "nome": "Roberto Alves",
        "idade": 23,
        "curso": "Ciência da Computação",
        "email": "roberto.alves@email.com"
    },
    {
        "nome": "Juliana Castro",
        "idade": 21,
        "curso": "Artes Visuais",
        "email": "juliana.castro@email.com"
    },
    {
        "nome": "Felipe Cardoso",
        "idade": 22,
        "curso": "Matemática Aplicada",
        "email": "felipe.cardoso@email.com"
    }
  ]    
)
```

```javascript
//Obter todos os registros
db.Estudantes.find()
```

```javascript
//Obter todos os registros formatados 
db.Estudantes.find().pretty()
```

```javascript
//Procurar registros por curso
db.Estudantes.find({curso: 'Engenharia da Computação'}).pretty()
```

```javascript
//Ordenar registros por nome, de forma ascendente
db.Estudantes.find().sort({nome: 1}).pretty()

//Ordenar registros por nome, de forma descendente
db.Estudantes.find().sort({nome: -1}).pretty()

// Contar Registros
db.Estudantes.find().count().pretty()

// Contar Registros por curso
db.Estudantes.find({curso: 'Engenharia da Computação'}).count().pretty()
```

```javascript
//Limitar exibição de linhas
db.Estudantes.find().limit(2).pretty()

//Encadeamento
db.Estudantes.find().limit(3).sort({nome: 1}).pretty()
```

## Acesso GUI: MongoDB Express 

1. Acesse o MongoDB Express pelo navegador na porta `8081`. Clique em `Create Database` e crie uma base de dados chamada `AulaDemo`. Dentro da base de dados `AulaDemo`, clique em `Create Collection` e nomeie-a `Estudantes`. 

2. Clique na coleção "Estudantes" e então em "Insert Document". Insira alguns estudantes com atributos como `nome`, `idade` e `curso`. Exemplo: 

```json
[
    {
        "nome": "Lucas Silva",
        "idade": 22,
        "curso": "Engenharia da Computação",
        "email": "lucas.silva@email.com"
    },
    {
        "nome": "Mariana Oliveira",
        "idade": 20,
        "curso": "Design Gráfico",
        "email": "mariana.oliveira@email.com"
    },
    {
        "nome": "Roberto Alves",
        "idade": 23,
        "curso": "Ciência da Computação",
        "email": "roberto.alves@email.com"
    },
    {
        "nome": "Juliana Castro",
        "idade": 21,
        "curso": "Artes Visuais",
        "email": "juliana.castro@email.com"
    },
    {
        "nome": "Felipe Cardoso",
        "idade": 22,
        "curso": "Matemática Aplicada",
        "email": "felipe.cardoso@email.com"
    }
]
```
3. Buscar todos os estudantes de um curso. 
4. Selecione um documento e clique em "Edit Document". Altere algum campo, por exemplo, mude a ```idade``` de um estudante. 
5. Selecione um documento e clique em "Delete Document". 
6. No menu lateral, clique em "Indexes" para visualizar os índices da coleção. Observe o índice padrão ```_id```. Crie um novo índice, por exemplo, para o campo ```nome```.
7. Graças à arquitetura que permite schema dinâmico, podemos ir acrescentando aos poucos um modelo mais detalhado para a base de estudantes. Exemplos de Campos Adicionais: 

```matricula```: Um identificador único para cada estudante.
```notas```: Um objeto contendo as notas do estudante em diferentes disciplinas. As disciplinas listadas são apenas exemplos e podem ser adaptadas conforme necessário.
```media```: A média de notas do estudante. Pode ser calculada com base nas notas fornecidas.
```status```: Indica se o estudante está ativo, inativo, formado, etc.
```anoIngresso```: O ano em que o estudante ingressou no curso.

Este modelo permite uma ampla gama de consultas, como buscar estudantes por curso, status, média de notas ou ano de ingresso. Além disso, você pode adicionar outros campos conforme necessário, como endereço, telefone de contato, entre outros. Adicionar um campo de notas como um objeto também permite que você adicione ou remova disciplinas facilmente sem alterar a estrutura geral do documento. Exemplo: 

```json
[
    {
        "nome": "Lucas Silva",
        "idade": 22,
        "curso": "Engenharia da Computação",
        "email": "lucas.silva@email.com",
        "matricula": "EC12345",
        "notas": {
            "matematica": 85,
            "programacao": 90,
            "fisica": 80
        },
        "media": 85,
        "status": "Ativo",
        "anoIngresso": 2020
    },
    {
        "nome": "Mariana Oliveira",
        "idade": 20,
        "curso": "Design Gráfico",
        "email": "mariana.oliveira@email.com",
        "matricula": "DG12345",
        "notas": {
            "designBasico": 92,
            "ilustracao": 89,
            "fotografia": 93
        },
        "media": 91.33,
        "status": "Ativo",
        "anoIngresso": 2021
    },
    // ... adicione mais estudantes seguindo o mesmo formato
]
```
## Acesso CLI: MongoDB 

1. Acessando o Shell do Contêiner MongoDB: 
```bash
docker exec -it mongo_service /bin/bash
```
2. Autentique-se no MongoDB: 
```bash
mongo -u root -p mongo
```

3. Selecionando a Base de Dados:

Para selecionar (ou criar, caso ainda não exista) a base de dados chamada "AulaDemo":
```bash
use AulaDemo
```
3. Inserindo Documentos:
Para inserir um estudante na coleção "Estudantes":
```bash
db.Estudantes.insert({
    nome: "Haroldo Ramos",
    idade: 22,
    curso: "Ciência da Computação",
    email: "haroldo.ramos@email.com",
    matricula: "CC12345",
    notas: { algoritmos: 85, poo: 90, calculo: 80 },
    media: 85,
    status: "Ativo",
    anoIngresso: 2020
})
```
Você pode repetir este comando para os outros estudantes, alterando os valores conforme necessário.

4. Consultando Documentos:

a) Para buscar todos os estudantes da coleção:
```bash
db.Estudantes.find()
```
b) Para buscar estudantes com média acima de 80:
```bash
db.Estudantes.find({ media: { $gt: 80 } })
```
c. Para realizar [agregação](https://www.mongodb.com/docs/manual/reference/operator/aggregation/sortByCount/#:~:text=Groups%20incoming%20documents%20based%20on%20the%20value%20of,of%20documents%20belonging%20to%20that%20grouping%20or%20category.) e contar quantos estudantes estão em cada curso. 

```bash
db.Estudantes.aggregate([
    {
        $sortByCount: "$curso"
    }
])
```

5. Atualizando Documentos:

Para atualizar a média de um estudante específico (por exemplo, "Lucas Silva"):

```bash
db.Estudantes.update({ nome: "Lucas Silva" }, { $set: { media: 87 } })
```

6. Deletando Documentos:

Para deletar um estudante específico:

```bash
db.Estudantes.remove({ nome: "Lucas Silva" })
```
7. Índices:

Para criar um índice no campo ```nome```:

```bash
db.Estudantes.createIndex({ nome: 1 })
```
8. Saindo do Shell:

Para sair do shell do MongoDB:

```bash
exit
```
