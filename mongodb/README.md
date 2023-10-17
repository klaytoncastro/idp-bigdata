# Introdução ao MongoDB e MongoDB Express

## Visão Geral

### O que é o MongoDB?

O **MongoDB** é um sistema gerenciador de banco de dados (SGBD) amplamente utilizado, conhecido por sua capacidade de armazenar dados no formato de documentos BSON (Binary JSON). Diferentemente dos bancos de dados relacionais tradicionais, o MongoDB utiliza uma abordagem NoSQL e não requer um esquema rígido, permitindo um armazenamento de dados flexível e dinâmico. Algumas características-chave do MongoDB incluem:

- **Documentos BSON**: Representações binárias de documentos JSON (Java Script Object Notation). Isso permite que os desenvolvedores trabalhem com dados no familiar formato JSON.

- **Escalabilidade Horizontal**: Suporta escalabilidade horizontal, o que significa que é possível adicionar mais instâncias para lidar com cargas de trabalho crescentes de modo distribuído.

- **Índices**: Podem ser criados índices para melhorar o desempenho das consultas, tornando a recuperação de dados mais rápida para as aplicações 

- **Flexibilidade de Esquema**: Como já mencionado, o MongoDB não requer um esquema fixo, o que permite que os desenvolvedores adicionem ou removam campos dos documentos e evoluam o schema de dados conforme necessário.

### MongoDB Aggregation Framework (MAF)

O **Aggregation Framework** é um poderoso recurso do MongoDB, que permite realizar operações complexas de análise e agregação de dados. Ele oferece a capacidade de processar e transformar dados em várias etapas, permitindo a obtenção de insights significativos e informações resumidas de seus documentos. Também permite uma grande variedade de operações de análise e transformação de dados, especialmente úteis quando você precisa:

- **Agrupar Dados**: Você pode agrupar documentos com base em um ou mais campos-chave, criando resumos e agregações.

- **Filtrar Documentos**: O MAF permite filtrar documentos com base em critérios específicos, excluindo ou incluindo documentos em um estágio de agregação.

- **Projetar Campos**: É possível projetar (selecionar) campos específicos dos documentos em um estágio de agregação, criando novos documentos com as informações desejadas.

- **Ordenar Dados**: Você pode classificar os documentos em um estágio de agregação, reordenando-os conforme necessário.

- **Executar Cálculos e Expressões**: O MAF oferece uma variedade de operadores que permitem realizar cálculos e expressões matemáticas em campos de documentos.

- **Unir Dados de Diferentes Coleções**: É possível unir dados de diferentes coleções ou fontes durante o processo de agregação.

- **Análise de Dados**: É fundamental para analisar dados e obter informações valiosas sobre seus conjuntos de documentos. Você pode calcular estatísticas, médias, realizar somas e muito mais.

- **Relatórios Personalizados**: Permite criar relatórios personalizados que atendam às necessidades específicas de sua aplicação. 

- **Preparação de Dados**: Facilita a preparação de dados para visualização ou análise posterior, tornando-os mais compreensíveis e úteis.

- **Integração de Dados**: Ajuda a integrar dados de várias fontes para obter uma visão abrangente de suas informações.

- **Otimização de Consultas**: O MAF pode ser usado para otimizar consultas complexas, que seriam difíceis de realizar de outra forma.

### O que é o MongoDB Express?

O **MongoDB Express** é uma interface gráfica que facilita a administração, gerenciamento e visualização de dados armazenados em bancos de dados MongoDB. Ele oferece uma série de recursos úteis, tornando a realização do trabalho com documentos muito mais acessível. Alguns aspectos importantes do MongoDB Express incluem:

- **Interface Gráfica Amigável**: O MongoDB Express fornece uma interface de usuário intuitiva que permite explorar e interagir com os dados de forma visual.

- **Gerenciamento de Coleções e Bancos de Dados**: É possível criar, editar e excluir coleções e bancos de dados, tornando o gerenciamento de dados mais conveniente.

- **Consultas Interativas**: Os usuários podem realizar consultas interativas aos dados sem a necessidade de escrever consultas manualmente.

- **Visualização de Índices**: Os índices existentes podem ser visualizados e gerenciados por meio da interface.

Assim, MongoDB e MongoDB Express são ferramentas complementares que simplificam a gestão do ambiente NoSQL, permitindo que os desenvolvedores e administradores trabalhem de forma eficiente com dados flexíveis e dinâmicos.

## Configurando o Ambiente

1. O dimensionamento apropriado de recursos depende das necessidades específicas do seu projeto. De modo a garantir um desempenho adequado e evitar problemas com os contêineres, ajuste a quantidade de memória nas configurações de Sistema na VM VirtualBox conforme orientações abaixo: 

- Se sua atividade estiver focada exclusivamente no MongoDB, é aconselhável alocar no mínimo 1536MB de RAM. Lembre-se que, para promover as alterações, sua VM deve estar desligada. 
- Caso pretenda utilizar outras ferramentas, como o Jupyter em conjunto com o MongoDB, é recomendável alocar no mínimo 3072MB de RAM. 
- Se você planeja executar o Jupyter em conjunto com o MongoDB e Spark, é aconselhável alocar pelo menos 4096MB de RAM. Avalie também a possibilidade de acréscimo de processadores virtuais, de acordo com a capacidade de seu hardware Se você possui à disposição um sistema quad-core, configure a VM para utilizar 2 processadores. 

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
## Acesso GUI: MongoDB Express 

1. Acesse o MongoDB Express pelo navegador na porta `8081`. Clique em `Create Database` e crie uma base de dados chamada `AulaDemo`. Dentro da base de dados `AulaDemo`, nomeie a coleção `Estudantes` e clique em `Create Collection`. 

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
5. Na parte inferior da tela, observe o índice padrão `_id`. Crie um novo índice, por exemplo, para o campo `nome`. 

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

A linguagem de query do MongoDB (MQL) permite que você consulte, atualize e manipule documentos de forma eficiente. Dentre suas principais características, destacamos: 

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
//Criar uma coleção chamada "Estudantes2022"
db.createCollection("Estudantes2022")
```

```javascript
//Inserir um registro
db.Estudantes.insert(
    {
        "nome": "Fernando Campos",
        "idade": 22,
        "curso": "Engenharia da Computação",
        "email": "fernando.campos@email.com",
        "data": Date()
    }
)
```

```javascript
//Inserir vários registros
db.Estudantes.insertMany([
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
Graças à arquitetura NoSQL que permite schema dinâmico, podemos ir acrescentando aos poucos um modelo mais detalhado para a base de estudantes. Por exemplo, colocamos os seguintes campos adicionais nos atributos do estudante "Haroldo Ramos": 

`matricula`: Um identificador único para cada estudante.

`notas`: Um objeto contendo as notas do estudante em diferentes disciplinas. As disciplinas listadas são apenas exemplos e podem ser adaptadas conforme necessário.

`media`: A média de notas do estudante. Pode ser calculada com base nas notas fornecidas.

`status`: Indica se o estudante está ativo, inativo, formado, etc.

`anoIngresso`: O ano em que o estudante ingressou no curso.

Este modelo permite uma ampla gama de consultas, como buscar estudantes por curso, status, média de notas ou ano de ingresso. Além disso, você pode adicionar outros campos conforme necessário, como endereço, telefone de contato, entre outros. Adicionar um campo de notas como um objeto também permite que você adicione ou remova disciplinas facilmente sem alterar a estrutura do documento. Mais exemplos: 

```json
db.Estudantes.insertMany([
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
])
```
A seguir, mais alguns comandos básicos do MongoDB, que permitem consultar, manipular e analisar documentos em suas coleções: 

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
```

```javascript
//Ordenar registros por nome, de forma descendente
db.Estudantes.find().sort({nome: -1}).pretty()
```

```javascript
// Contar Registros
var count = db.Estudantes.find().count();
print("Número de registros na coleção Estudantes: " + count);
```

```javascript
// Contar Registros por curso
var count = db.Estudantes.find({ curso: 'Engenharia da Computação' }).count();
print("Número de registros na coleção Estudantes com curso 'Engenharia da Computação': " + count);
```

```javascript
//Limitar exibição de linhas
db.Estudantes.find().limit(2).pretty()
```

```javascript
//Encadeamento
db.Estudantes.find().limit(3).sort({nome: 1}).pretty()
```

```javascript
//Para buscar estudantes com média acima de 80:
db.Estudantes.find({ media: { $gt: 80 } }).pretty()
```

```javascript
//Para atualizar a média de um estudante específico (por exemplo, "Deocleciano Oliveira"):
db.Estudantes.update({ nome: "Deocleciano Oliveira" }, { $set: { media: 92 } })
```

```javascript
//Para criar um índice no campo "nome":
db.Estudantes.createIndex({ nome: 1 })
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
//Para deletar um estudante específico:
db.Estudantes.remove({ nome: "Vladimir Silva" })
```

```javascript
//Para sair do shell do MongoDB:
exit
```

## Pipelines de Dados

Um pipeline constitui uma série de etapas pelas quais os documentos passam, onde cada etapa efetua uma operação específica no conjunto de dados. Essas etapas são executadas em sequência, permitindo que você processe e transforme os documentos de maneira controlada. 

### Operações do Pipeline

Cada etapa no pipeline é representada por um estágio. Os estágios podem incluir operações de filtro, projeção, ordenação, agrupamento, cálculos e muito mais. Alguns dos estágios comuns incluem:

`$match`: Filtra documentos com base em critérios específicos, permitindo que você selecione apenas os documentos que atendam a determinadas condições.

`$project`: Permite projetar (selecionar) campos específicos dos documentos, criando novos documentos com as informações desejadas.

`$sort`: Ordena os documentos com base nos valores de um campo específico, seja em ordem ascendente ou descendente.

`$group`: Agrupa os documentos com base em um ou mais campos-chave e realiza operações de agregação, como soma, média, contagem, entre outras.

`$unwind`: Desconstrói arrays em documentos, gerando um novo documento para cada elemento do array. Isso é útil quando você deseja realizar operações em elementos de arrays.

`$lookup`: Realiza uma operação de junção (join) entre duas coleções para combinar dados de diferentes fontes.

`$addFields`: Adiciona novos campos aos documentos ou modifica campos existentes.

`$out`: Escreve os resultados da agregação em uma nova coleção.

### Carga de Dados

Segue um exemplo básico de pipeline de dados utilizando recursos do MongoDB Aggregation Framework para análise de dados. Considerando uma coleção chamada `Vendas` com documentos que representam vendas de produtos, desejamos calcular a receita total por categoria de produto. Você pode usar os dados a seguir para inserir dados na coleção `Vendas`:

```javascript
db.Vendas.insertMany([
    {
        "produto": "Laptop",
        "categoria": "Eletrônicos",
        "valor": 1200.00
    },
    {
        "produto": "Smartphone",
        "categoria": "Eletrônicos",
        "valor": 800.00
    },
    {
        "produto": "Livros",
        "categoria": "Livraria",
        "valor": 300.00
    },
    {
        "produto": "Televisor",
        "categoria": "Eletrônicos",
        "valor": 1500.00
    },
    {
        "produto": "Tablet",
        "categoria": "Eletrônicos",
        "valor": 600.00
    },
    {
        "produto": "Fones de Ouvido",
        "categoria": "Eletrônicos",
        "valor": 100.00
    },
    {
        "produto": "Máquina de Café",
        "categoria": "Eletrodomésticos",
        "valor": 250.00
    },
    {
        "produto": "Console de Videogame",
        "categoria": "Eletrônicos",
        "valor": 450.00
    },
    {
        "produto": "Roupas",
        "categoria": "Moda",
        "valor": 50.00
    },
    {
        "produto": "Cadeira de Escritório",
        "categoria": "Móveis",
        "valor": 200.00
    },
    {
        "produto": "Instrumento Musical",
        "categoria": "Arte e Música",
        "valor": 700.00
    },
    {
        "produto": "Tênis Esportivo",
        "categoria": "Esportes",
        "valor": 120.00
    },
    {
        "produto": "Bicicleta",
        "categoria": "Esportes",
        "valor": 350.00
    },
    {
        "produto": "Ferramentas",
        "categoria": "Ferramentas",
        "valor": 80.00
    },
    {
        "produto": "Jogos de Tabuleiro",
        "categoria": "Jogos",
        "valor": 40.00
    },
    {
        "produto": "Decoração de Casa",
        "categoria": "Casa e Jardim",
        "valor": 120.00
    },
    {
        "produto": "Artigos de Beleza",
        "categoria": "Beleza",
        "valor": 90.00
    }
    // Adicione mais documentos conforme necessário
  ]
)
```

### Exemplo de Utilização

No exemplo abaixo, no primeiro estágio `$group`, estamos agrupando os documentos por categoria (`$categoria`) e calculando a receita total para cada categoria usando `$sum`. No segundo estágio `$sort`, estamos ordenando os resultados com base na receita total em ordem descendente. Isso nos dará uma lista das categorias de produtos com a receita total calculada para cada uma delas.

```javascript
db.Vendas.aggregate([
    {
        $group: {
            _id: "$categoria",
            receitaTotal: { $sum: "$valor" }
        }
    },
    {
        $sort: { receitaTotal: -1 }
    }
])
```

## Conclusão

Esta documentação fornece uma visão completa do MongoDB, uma das soluções mais populares e poderosas para gerenciamento exite análise de dados no contexto de Big Data e NoSQL. Exploramos a flexibilidade de esquema do MongoDB, sua linguagem e recursos avançados de consulta (MQL) e agregação (MAF). Vimos que o MongoDB Express proporciona uma interface gráfica (GUI) amigável para gerenciamento de bases MongoDB, tornando o trabalho com documentos mais acessível. Além do MongoDB Express, você também pode baixar a ferramenta [MongoDB Compass](https://www.mongodb.com/try/download/compass) para uma experiência de visualização e consulta ainda mais avançada.  Para aprofundar seu conhecimento, consulte a documentação oficial do [MongoDB](https://docs.mongodb.com/). 