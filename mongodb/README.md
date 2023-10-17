# Introdução ao MongoDB e MongoDB Express

## Configurando o Ambiente

1. O dimensionamento apropriado de recursos depende das necessidades específicas do seu projeto. De modo a garantir um desempenho adequado e evitar problemas com os contêineres, ajuste a quantidade de memória nas configurações do VirtualBox conforme orientações abaixo. 

- Se sua atividade estiver focada exclusivamente no MongoDB, é aconselhável alocar no mínimo 1536MB de RAM. Lembre-se que, para promover as alterações, sua VM deve estar desligada. 
- Caso pretenda utilizar outras ferramentas, como o Jupyter em conjunto com o MongoDB, é recomendável alocar no mínimo 3072MB de RAM. 
- Se você planeja executar o Jupyter em conjunto com o MongoDB e Spark, é aconselhável alocar pelo menos 4096MB de RAM. valie também a possibilidade de acréscimo de processadores virtuais, de acordo com a capacidade de seu hardware Se você possui à disposição um sistema quad-core, configure a VM para utilizar 2 processadores. 

2. Após os promover os ajustes, inicie a VM. Lembre-se que você deve trabalhar sempre com a versão mais recente do repositório [IDP-BigData](https://github.com/klaytoncastro/idp-bigdata). Navegue até o diretório onde você clonou o repositório (`cd /opt/idp-bigdata`) e obtenha as respectivas atualizações com o comando abaixo: 

```bash
git pull origin main
```

3. Se este for seu primeiro acesso, vá até o diretório `/opt/idp-bigdata/mongodb` e certifique-se que o script `wait-for-it.sh` tenha permissão de execução: 

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

6. Para facilitar a integração do MongoDB como outras ferramentas, tais como o Jupyter, uma API Flask, ou outros serviços, pode ser necessário verificar o endereço IP dos contêineres e a rede virtual na qual estão conectados. Neste caso, utilize os comandos abaixo: 

```bash
docker inspect <CONTAINER_ID> | grep IPAddress
docker network inspect <NETWORK_NAME>
```

## Acesso GUI: MongoDB Express 

1. Acesse o MongoDB Express pelo navegador na porta `8081`. Clique em `Create Database` e crie uma base de dados chamada `AulaDemo`. Dentro da base de dados `AulaDemo`, clique em `Create Collection` e nomeie-a `Estudantes`. 

2. Clique na coleção `Estudantes` e então em `Insert Document`. Insira um estudante com atributos como `nome`, `idade` e `curso`. Exemplo: 

```json
    {
        "nome": "João Leite",
        "idade": 22,
        "curso": "Engenharia da Computação",
        "email": "joao.leite@email.com"
    }
```
3. Selecione um documento e clique em `Edit Document`. Altere algum campo, por exemplo, mude a `idade` de um estudante. 
4. Selecione um documento e clique em `Delete Document`. 
5. No menu lateral, clique em `Indexes` para visualizar os índices da coleção. Observe o índice padrão ```_id```. Crie um novo índice, por exemplo, para o campo `nome`.
6. Graças à arquitetura que permite schema dinâmico, podemos ir acrescentando aos poucos um modelo mais detalhado para a base de estudantes. Exemplos de Campos Adicionais: 

`matricula`: Um identificador único para cada estudante.
`notas`: Um objeto contendo as notas do estudante em diferentes disciplinas. As disciplinas listadas são apenas exemplos e podem ser adaptadas conforme necessário.
`media`: A média de notas do estudante. Pode ser calculada com base nas notas fornecidas.
`status`: Indica se o estudante está ativo, inativo, formado, etc.
`anoIngresso`: O ano em que o estudante ingressou no curso.

Este modelo permite uma ampla gama de consultas, como buscar estudantes por curso, status, média de notas ou ano de ingresso. Além disso, você pode adicionar outros campos conforme necessário, como endereço, telefone de contato, entre outros. Adicionar um campo de notas como um objeto também permite que você adicione ou remova disciplinas facilmente sem alterar a estrutura geral do documento. Exemplo: 

```json
[
    {
        "nome": "Vladimir Silva",
        "idade": 22,
        "curso": "Engenharia da Computação",
        "email": "vladimir.silva@email.com",
        "matricula": "EC54321",
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
        "nome": "Deocleciano Oliveira",
        "idade": 20,
        "curso": "Design Gráfico",
        "email": "deocleciano.oliveira@email.com",
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
### Guia Básico: MongoDB Query Language (MQL)

O MongoDB é um sistema gerenciador de banco de dados (SGBD) NoSQL, orientado a documentos, que armazena dados em formato JSON (BSON). A linguagem de query do MongoDB (MQL) permite que você consulte, atualize e manipule documentos de forma eficiente. Dentre suas principais características, destacamos: 

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
//Criar ou mudar de base de dados
use AulaDemo2
```

```javascript
//Apagar a base de dados
db.dropDatabase()
```

```javascript
//Mostrar as coleções
use AulaDemo
show collections
```

```javascript
//Criar uma coleção chamada "Estudantes"
db.createCollection(Estudantes2022)
```

```javascript
//Inserir um registro
db.Estudantes.insert(
    {
        "nome": "Fernando Campos",
        "idade": 22,
        "curso": "Engenharia da Computação",
        "email": "fernando.campos@email.com"
        "data": Date()
    }
)
```

```javascript
//Inserir vários registros
db.<nome_da_colecao>.insertMany([
    {
        "nome": "Mariano Rodrigues",
        "idade": 20,
        "curso": "Design Gráfico",
        "email": "mariano.rodrigues@email.com"
    },
    {
        "nome": "Roberta Lara",
        "idade": 23,
        "curso": "Ciência da Computação",
        "email": "roberta.lara@email.com"
    },
    {
        "nome": "Juliano Pires",
        "idade": 21,
        "curso": "Artes Visuais",
        "email": "juliano.pires@email.com"
    },
    {
        "nome": "Felicia Cardoso",
        "idade": 22,
        "curso": "Matemática Aplicada",
        "email": "felicia.cardoso@email.com"
    }, 
    {
        "nome": "Haroldo Ramos",
        "idade": 22,
        "curso": "Ciência da Computação",
        "email": "haroldo.ramos@email.com",
        "matricula": "CC12345",
        "notas": { algoritmos: 85, poo: 90, calculo: 80 },
        "media": 85,
        "status": "Ativo",
        "anoIngresso": 2020
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

```javascript
//Para buscar estudantes com média acima de 80:
db.Estudantes.find({ media: { $gt: 80 } })
```

```javascript
//Para realizar agregação e contar quantos estudantes estão em cada curso. 
db.Estudantes.aggregate([
    {
        $sortByCount: "$curso"
    }
])
```

```javascript
//Para atualizar a média de um estudante específico (por exemplo, "Lucas Silva"):
db.Estudantes.update({ nome: "Lucas Silva" }, { $set: { media: 87 } })
```

```javascript
//Para deletar um estudante específico:
db.Estudantes.remove({ nome: "Lucas Silva" })
```

```javascript
//Para criar um índice no campo "nome":
db.Estudantes.createIndex({ nome: 1 })
```
```javascript
//Para sair do shell do MongoDB:
exit
```