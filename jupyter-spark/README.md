# Prática de Exploração e Análise de Dados

## 1. Introdução

Jupyter é uma IDE (Ambiente de Desenvolvimento Integrado) open-source que suporta várias linguagens de programação, incluindo Julia, Python e R. É amplamente utilizado por pesquisadores, educadores, cientistas, analistas e engenheiros de dados para criar e compartilhar documentos que contêm código, equações, visualizações e texto narrativo.

No contexto do Jupyter, o termo 'notebook' é a representação de um documento interativo que permite a escrita e execução de código, bem como a inservação de texto formatado com propósito de documentar equações, imagens e visualizações. Os notebooks são uma ferramenta poderosa para explorar dados, realizar análises, e documentar processos de trabalho de forma clara e compreensível. Eles são salvos com a extensão .ipynb e podem ser baixados e facilmente compartilhados e visualizados por outras pessoas, mesmo que elas não tenham o Jupyter instalado. 

No Jupyter, você pode criar um novo notebook, abrir um existente, e executar células de código individualmente. Os resultados das execuções são exibidos diretamente abaixo da célula de código correspondente, facilitando o acompanhamento do fluxo de trabalho e dos resultados. Essa abordagem visa construir um ambiente interativo para exploração e análise de dados, com suporte à criação de gráficos e visualizações. Também permite a prototipagem rápida de soluções e a exploração de diferentes abordagens de análise. 

## 2. Construção do Ambiente de Desenvolvimento

Ao longo do curso, integraremos nosso ecossistema de ferramentas de Big Data e NoSQL por meio de notebooks Jupyter. O contêiner que preparamos para nosso ambiente de desenvolvimento já vem com o Apache Spark configurado no modo standalone, permitindo que você tire proveito dos recursos deste poderoso framework de processamento de dados. O Spark é amplamente utilizado para análises de Big Data e Machine Learning, e poderá ser acionado diretamente a partir de seus notebooks. Siga as instruções abaixo para preparar seu ambiente: 

a) Se estiver usando uma VM, conforme instruções fornecidas no [README.md](https://github.com/klaytoncastro/idp-bigdata) do repositório [IDP-BigData](https://github.com/klaytoncastro/idp-bigdata), certifique-se de que a VM está executando e que você pode acessá-la via SSH. Caso tenha optado por hospedar os contêineres diretamente em sua máquina, certifique-se de ter o Git, Docker e o Docker Compose corretamente instalados.  

b) Navegue até a subpasta do repositório, por exemplo: `cd /opt/idp-bigdata`. 

c) Se ainda não tiver clonado o repositório, execute o seguinte comando em seu terminal ou console:

```bash
git clone https://github.com/klaytoncastro/idp-bigdata 
```

d) Caso esta seja a primeira clonagem do repositório, execute o script para mapeamento das permissões dos volumes externos ao contêiner:

```bash
chmod +x permissions.sh
./permissions.sh
```

e) Caso já tenha clonado o repositório, execute o comando a seguir para garantir que seu ambiente esteja com as atualizações mais recentes: 

```bash
git pull origin main
```
f) Navegue até a subpasta jupyter-spark dentro do diretório clonado, por exemplo: `cd /opt/idp-bigdata/jupyter-spark`. Construa e execute os serviços usando o Docker Compose:

```bash
docker-compose build 
docker-compose up -d 
```

g) Execute o comando a seguir para visualizar os logs e identificar o token do Jupyter Notebook para realizar seu primeiro acesso: 

```bash
docker-compose logs | grep 'token='
```

### Via GUI

Com o token identificado no passo anterior, acesse o Jupyter Notebook em seu navegador usando o [link](http://localhost:8888), insira o token e configure uma nova senha. 

### Via CLI

Caso deseje alterar a senha via CLI, execute o script abaixo: 

```bash
docker exec -it <nome_do_contêiner> /bin/bash
jupyter config password
```

### Inicialize e teste a integração com Spark

h) Quando o Apache Spark está em execução, ele disponibiliza uma interface web na porta `4040` para o usuário acompanhar e analisar a execução de suas aplicações. Acesse a URL `http://localhost:4040` e observe que esta interface só se tornará disponível após a inicialização do ambiente Spark. 

i) A partir de um novo arquivo notebook, teste seu ambiente Spark inicializando uma sessão: 

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()
```
j) Acesse novamente a URL `http://localhost:4040` e observe que a Spark Application UI agora está disponível. Agora encerre a sessão Spark e observe que a interface http://localhost:4040 não estará mais disponível após a execução do comando abaixo: 

```python
spark.stop()
```
## 3. Integração do Jupyter com ferramentas externas

### Conecte-se ao MongoDB

a) Baixe os contêineres do Jupyter-Spark e MongoDB nas respectivas subpastas do repositório.

```bash
docker-compose down
```
b) Para permitir a comunicação entre os contêineres do Jupyter e MongoDB, atualizamos nosso arquivo `docker-compose.yml`, adicionando a configuração de rede conforme descrito abaixo: 

```yaml
# Definindo as redes que serão usadas pelos serviços.
    networks:
      - mybridge # Nome da rede que será usada.

# Configuração das redes que serão usadas no docker-compose.
networks:
  mybridge: # Nome da rede.
    external: # Indica que a rede é externa e já foi criada anteriormente.
      name: mybridge # Nome da rede externa que será usada.
```

c) Crie a rede virtual `mybridge` no Docker: 

```bash
docker network create --driver bridge mybridge
```

d) Agora suba os contêineres novamente e verifique os IPs atribuídos ao Jupyter e, especialmente ao MongoDB (pois será referenciado na string de conexão ao banco de dados a partir de seus notebooks):

```bash
docker-compose up -d
docker network inspect mybridge
```

e) A partir de um arquivo notebook no Jupyter, teste a conexão: 

```python
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

try:
    client = MongoClient("mongodb://root:mongo@172.22.0.3:27017/", serverSelectionTimeoutMS=5000)
    client.server_info()  # Isso lançará uma exceção se não puder se conectar ao servidor.
    print("Conexão estabelecida com sucesso!")

except ConnectionFailure:
    print("Falha na conexão ao servidor MongoDB")
```
### Prática com Dataset Exemplo 

Para praticar a análise de dados com Python e MongoDB, sugerimos que você explore datasets de exemplo disponíveis no [Kaggle](https://www.kaggle.com/). O Kaggle é uma plataforma online amplamente utilizada por cientistas de dados, pesquisadores e entusiastas de aprendizado de máquina. Ele oferece um ambiente onde os usuários podem colaborar, compartilhando e aprendendo uns com os outros, além de ter acesso a uma vasta quantidade de datasets e competições de aprendizado de máquina. Uma excelente referência para começar é o notebook [MongoDB w/ Python](https://www.kaggle.com/code/ganu1899/mongodb-with-python), que apresenta um exemplo prático de como utilizar o MongoDB junto com Python, compatível com nosso ambiente Jupyter. 

## 4. Limpeza, Preparação e Importação de Dados

Nesta atividade, utilizaremos o dataset do Censo da Educação Superior de 2022, disponibilizado pelo Instituto Nacional de Estudos e Pesquisas Educacionais Anísio Teixeira (INEP), que pode ser acessado através do link: [INEP - Dados Abertos](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos). Uma das principais ações do INEP é a realização do Censo da Educação Superior, um levantamento anual que coleta informações detalhadas sobre as instituições de ensino superior (IES), seus cursos, alunos, docentes, entre outros aspectos. 

O Censo da Educação Superior (CES) é a principal fonte de informações sobre o ensino superior no Brasil e tem um papel fundamental para entender a dinâmica do setor, identificar desafios e oportunidades e subsidiar a tomada de decisões por parte de gestores, pesquisadores e formuladores de políticas educacionais. Estes dados são cruciais para compreender a realidade do ensino superior no Brasil, identificar tendências e padrões, e contribuir para a elaboração de políticas educacionais mais eficazes e alinhadas com as necessidades do país. O banco de dados do INEP, que é utilizado para armazenar as informações coletadas pelo CES, contém uma vasta quantidade de dados, incluindo:

- Dados sobre as instituições de ensino superior, como nome, localização, tipo de instituição (pública ou privada), entre outros.
- Informações sobre os cursos oferecidos, como nome do curso, área de conhecimento, modalidade de ensino, entre outros.
- Dados sobre os alunos, como quantidade de alunos matriculados, quantidade de alunos concluintes, perfil dos alunos, entre outros.
- Informações sobre os docentes, como quantidade de docentes, perfil dos docentes, carga horária de trabalho, entre outros.

Antes de dar início ao processo de análise e exploração deste dataset real, é fundamental compreender a importância do processo de preparação, limpeza e importação de dados. A preparação e limpeza de dados são etapas essenciais para garantir a qualidade dos dados, sendo fundamentais para obtenção de resultados confiáveis e precisos. A literatura destaca que estas etapas costumam consumir até 80% do tempo total de um projeto de análise de dados (Dasu & Johnson, 2003). Dessa forma, antes de importar os dados para o MongoDB, vamos demonstrar a realização de uma limpeza básica e preparação prévia dos dado, conforme explicitado nas técnicas abaixo. 

### Remoção de aspas duplas e substituir ponto e vírgula por vírgula:

O `sed` (stream editor) é uma poderosa ferramenta de processamento de texto, disponível em sistemas baseados em Linux. Ela é bastante utilizada para analisar e transformar textos, bem como para operar em fluxos de dados para executar operações básicas e avançadas de edição, como substituição, deleção, inserção, dentre outras. Ele lida com expressões regulares, o que o torna muito flexível para encontrar e substituir padrões de texto. O `sed` também costuma ser combinado com outras ferramentas de CLI, como `awk`, `grep`, e `cut`, para criar soluções poderosas para processamento de dados. Abaixo, seguem alguns exemplos de uso: 

a) Substituir texto em um arquivo: 

```bash
sed 's/antigo/novo/g' arquivo.txt
```

b) Deletar linhas que contêm um certo padrão: 

```bash
sed '/padrão/d' arquivo.txt
```
c) Inserir texto antes ou depois de um padrão:

```bash
sed '/padrão/i Novo Texto' arquivo.txt
sed '/padrão/a Novo Texto' arquivo.txt
```
d) Aplicando a funcionalidade de substituição de texto para tratar nosso dataset, o `;` é utilizado para separar comandos dentro do `sed`. O primeiro trecho `s/\"//g` está removendo todas as aspas duplas do arquivo. O segundo trecho `s/;/,/g` está substituindo todos os ponto e vírgula por vírgulas. Estas medidas foram necessárias para corrigir os dados apresentados e torná-los compatíveis para importação no MongoDB. 

```bash
sed 's/\"//g; s/;/,/g' MICRODADOS_ED_SUP_IES_2022.CSV > MICRODADOS_ED_SUP_IES_2022_corrigido.csv
```

### Verificação de encoding do dataset e conversão de ISO-8859-1 para UTF-8:

O comando `file` é útil para mostrar informações sobre o tipo do arquivo. A opção `-i` solicita a apresentação do padrão de codificação do arquivo. Segue comando para verificar a codificação do dataset:

```bash
file -i MICRODADOS_ED_SUP_IES_2022_corrigido.csv
```

O utilitário `iconv` é utilizado para converter a codificação de caracteres de um arquivo. O trecho `-f` `ISO-8859-1` indica a codificação original do arquivo, e -t `UTF-8` indica a codificação desejada. No comando abaixo estamos convertendo o formato de ANSI/ISO para UTF-8, que é utilizado no MongoDB. 

```bash
iconv -f ISO-8859-1 -t UTF-8 MICRODADOS_ED_SUP_IES_2022_corrigido.csv > MICRODADOS_ED_SUP_IES_2022_corrigido_UTF8.csv
```

### Substituição de caracteres especiais:

A expressão abaixo utiliza novamente o `sed` para substituir caracteres especiais por seus equivalentes sem acentuação. A opção `-i` indica que a modificação será feita diretamente no arquivo, sem a necessidade de criar um novo. 

```bash
sed -i 'y/áàãâäéèêëíìîïóòõôöúùûüçñÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ/aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN/' MICRODADOS_ED_SUP_IES_2022_corrigido_UTF8.csv
```

### Importação para o MongoDB para a collection 'ies'

O comando abaixo é utilizado para executar o utilitário `mongoimport` dentro do contêiner do MongoDB. As opções `--db` e `--collection` especificam o banco de dados e a coleção onde os dados serão importados, respectivamente. O parâmetro `--type csv` indica que o arquivo de entrada é um CSV (Comma Separated Values). A opção `--file` especifica o caminho para o arquivo de entrada. O parâmetro `--headerline` indica que a primeira linha do arquivo contém os nomes das colunas. A opção `--ignoreBlanks` ignora campos em branco. Por fim, `--username`, `--password`, e `--authenticationDatabase` são utilizados para autenticação preliminar no MongoDB.

```bash
docker exec -it mongo_service mongoimport --db inep --collection ies --type csv --file /datasets/inep_censo_ies_2022/dados/MICRODADOS_ED_SUP_IES_2022_corrigido_UTF8.csv --headerline --ignoreBlanks --username root --password mongo --authenticationDatabase admin
```
### Repetição do processo para a collection 'cursos'

```bash
sed 's/\"//g; s/;/,/g' MICRODADOS_CADASTRO_CURSOS_2022.CSV > MICRODADOS_CADASTRO_CURSOS_2022_corrigido.CSV

iconv -f ISO-8859-1 -t UTF-8 MICRODADOS_CADASTRO_CURSOS_2022_corrigido.CSV > MICRODADOS_CADASTRO_CURSOS_2022_corrigido_UTF8.CSV

sed -i 'y/áàãâäéèêëíìîïóòõôöúùûüçñÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ/aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN/' MICRODADOS_CADASTRO_CURSOS_2022_corrigido_UTF8.CSV

docker exec -it mongo_service mongoimport --db inep --collection cursos --type csv --file /datasets/inep_censo_ies_2022/dados/MICRODADOS_CADASTRO_CURSOS_2022_corrigido_UTF8.CSV --headerline --ignoreBlanks --username root --password mongo --authenticationDatabase admin
```

## 4. Exploração e Análise de Dados

A Análise Exploratória de Dados é um método estatístico que busca identificar padrões, relações e anomalias nos dados. Tukey (1977) introduziu esse conceito como uma abordagem para explorar dados de maneira flexível e visual, antes de aplicar métodos estatísticos mais rigorosos. A visualização de dados é um componente crucial da literacia de dados e da AED. Ela ajuda a comunicar informações complexas de maneira clara e eficaz, auxiliando na compreensão dos resultados da análise (Tufte, 2001). 

```python
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

try:
    client = MongoClient("mongodb://root:mongo@172.22.0.3:27017/", serverSelectionTimeoutMS=5000)
    client.server_info()  # Isso lançará uma exceção se não puder se conectar ao servidor.
    print("Conexão estabelecida com sucesso!")

except ConnectionFailure:
    print("Falha na conexão ao servidor MongoDB")

# Selecionar o banco de dados
db = client['inep']

# Selecionar a coleção
collection = db['ies']

# Query para contar o número de instituições por região
import matplotlib.pyplot as plt

result = collection.aggregate([
    {'$group': {'_id': '$NO_REGIAO_IES', 'count': {'$sum': 1}}}
])

# Converter o resultado para listas
regions, counts = zip(*[(r['_id'], r['count']) for r in result])

# Plotar o gráfico
plt.figure(figsize=(10,5))
plt.bar(regions, counts)
plt.xlabel('Região')
plt.ylabel('Número de Instituições')
plt.title('Número de Instituições por Região')
plt.show()

# Query para calcular a proporção de docentes por gênero
result = collection.aggregate([
    {'$group': {
        '_id': None,
        'total_fem': {'$sum': '$QT_DOC_EX_FEMI'},
        'total_masc': {'$sum': '$QT_DOC_EX_MASC'}
    }}
])

# Converter o resultado para valores
result = next(result)
total_fem = result['total_fem']
total_masc = result['total_masc']

# Plotar o gráfico
labels = ['Feminino', 'Masculino']
sizes = [total_fem, total_masc]
colors = ['lightcoral', 'lightskyblue']
explode = (0.1, 0)  # explode 1st slice

plt.figure(figsize=(8,8))
plt.pie(sizes, explode=explode, labels=labels, colors=colors, autopct='%1.1f%%', shadow=True, startangle=140)
plt.axis('equal')
plt.title('Proporção de Docentes por Gênero')
plt.show()


# Query para contar o número de instituições por estado
result = collection.aggregate([
    {'$group': {'_id': '$NO_UF_IES', 'count': {'$sum': 1}}}
])

# Converter o resultado para listas
states, counts = zip(*sorted([(r['_id'], r['count']) for r in result], key=lambda x: x[1], reverse=True))

# Plotar o gráfico
plt.figure(figsize=(10,5))
plt.bar(states, counts)
plt.xlabel('Estado')
plt.ylabel('Número de Instituições')
plt.title('Número de Instituições por Estado')
plt.xticks(rotation=90)
plt.show()


# Query para calcular o número de docentes por faixa etária
result = collection.aggregate([
    {'$group': {
        '_id': None,
        '0-29': {'$sum': '$QT_DOC_EX_0_29'},
        '30-34': {'$sum': '$QT_DOC_EX_30_34'},
        '35-39': {'$sum': '$QT_DOC_EX_35_39'},
        '40-44': {'$sum': '$QT_DOC_EX_40_44'},
        '45-49': {'$sum': '$QT_DOC_EX_45_49'},
        '50-54': {'$sum': '$QT_DOC_EX_50_54'},
        '55-59': {'$sum': '$QT_DOC_EX_55_59'},
        '60+': {'$sum': '$QT_DOC_EX_60_MAIS'},
    }}
])

# Converter o resultado para valores
result = next(result)
ages = ['0-29', '30-34', '35-39', '40-44', '45-49', '50-54', '55-59', '60+']
counts = [result[age] for age in ages]

# Plotar o gráfico
plt.figure(figsize=(10,5))
plt.bar(ages, counts)
plt.xlabel('Faixa Etária')
plt.ylabel('Número de Docentes')
plt.title('Número de Docentes por Faixa Etária')
plt.show()


# Query para calcular o número de docentes por grau acadêmico
result = collection.aggregate([
    {'$group': {
        '_id': None,
        'Graduação': {'$sum': '$QT_DOC_EX_GRAD'},
        'Especialização': {'$sum': '$QT_DOC_EX_ESP'},
        'Mestrado': {'$sum': '$QT_DOC_EX_MEST'},
        'Doutorado': {'$sum': '$QT_DOC_EX_DOUT'},
    }}
])

# Converter o resultado para valores
result = next(result)
degrees = ['Graduação', 'Especialização', 'Mestrado', 'Doutorado']
counts = [result[degree] for degree in degrees]

# Plotar o gráfico
plt.figure(figsize=(10,5))
plt.pie(counts, labels=degrees, autopct='%1.1f%%', startangle=90)
plt.title('Proporção de Docentes por Grau Acadêmico')
plt.show()


# Query para calcular o número de docentes por raça/cor
result = collection.aggregate([
    {'$group': {
        '_id': None,
        'Branca': {'$sum': '$QT_DOC_EX_BRANCA'},
        'Preta': {'$sum': '$QT_DOC_EX_PRETA'},
        'Parda': {'$sum': '$QT_DOC_EX_PARDA'},
        'Amarela': {'$sum': '$QT_DOC_EX_AMARELA'},
        'Indígena': {'$sum': '$QT_DOC_EX_INDIGENA'},
        'Não declarada': {'$sum': '$QT_DOC_EX_COR_ND'},
    }}
])

# Converter o resultado para valores
result = next(result)
races = ['Branca', 'Preta', 'Parda', 'Amarela', 'Indígena', 'Não declarada']
counts = [result[race] for race in races]

# Plotar o gráfico
plt.figure(figsize=(10,5))
plt.bar(races, counts)
plt.xlabel('Raça/Cor')
plt.ylabel('Número de Docentes')
plt.title('Número de Docentes por Raça/Cor')
plt.xticks(rotation=45)
plt.show()

#Análise Multivariada: Query para calcular o número de docentes por região e grau acadêmico
result = collection.aggregate([
    {'$group': {
        '_id': {'regiao': '$NO_REGIAO_IES', 'grau': 'Graduação'},
        'count': {'$sum': '$QT_DOC_EX_GRAD'},
    }},
    {'$group': {
        '_id': {'regiao': '$NO_REGIAO_IES', 'grau': 'Especialização'},
        'count': {'$sum': '$QT_DOC_EX_ESP'},
    }},
    {'$group': {
        '_id': {'regiao': '$NO_REGIAO_IES', 'grau': 'Mestrado'},
        'count': {'$sum': '$QT_DOC_EX_MEST'},
    }},
    {'$group': {
        '_id': {'regiao': '$NO_REGIAO_IES', 'grau': 'Doutorado'},
        'count': {'$sum': '$QT_DOC_EX_DOUT'},
    }}
])

# Convertendo o resultado para um dataframe
import pandas as pd

data = []
for r in result:
    data.append({
        'regiao': r['_id']['regiao'],
        'grau': r['_id']['grau'],
        'count': r['count'],
    })

df = pd.DataFrame(data)

# Realizando a análise de correlação
corr = df.corr()

# Plotando o mapa de calor da correlação
import seaborn as sns

plt.figure(figsize=(10, 8))
sns.heatmap(corr, annot=True, cmap='coolwarm')
plt.title('Correlação entre Região e Grau Acadêmico dos Docentes')
plt.show()

# Análise dos Resultados:
# O mapa de calor de correlação mostrará a relação entre as diferentes regiões e graus acadêmicos dos docentes.
# Valores próximos a 1 ou -1 indicam uma forte correlação positiva ou negativa, respectivamente.
# Valores próximos a 0 indicam que não há uma correlação significativa entre as variáveis.
```