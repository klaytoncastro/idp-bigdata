# Análise e Exploração de Dados com Jupyter

## 1. Introdução

Jupyter é um ambiente de desenvolvimento integrado (IDE) que suporta várias linguagens de programação, como Julia, Python e R, sendo amplamente utilizado por pesquisadores, educadores, engenheiros, analistas e cientistas de dados para criar documentos que integram texto, código, equações e visualizações. No Jupyter, o notebook é um documento interativo que pode ser salvo e compartilhado no formato `.ipynb`, facilitando a execução individual de células de código, documentação de equações, inserção de imagens, depuração e prototipagem de soluções que envolvem exploração de dados e outros processos de trabalho.

Este guia detalha o processo de limpeza, preparação e importação de dados reais para o MongoDB, abordando a remoção de caracteres indesejados, conversão de codificação e normalização de texto. Além disso, será apresentado um código em Python para demonstrar como realizar a análise exploratória de dados (AED) desses dados no ambiente Jupyter.

## 2. Ambiente de Desenvolvimento

No decorrer do curso, realizaremos a integração de nossas ferramentas de Big Data e NoSQL com o Jupyter. Vale ressaltar que o contêiner do nosso ambiente de desenvolvimento já vem equipado com o Apache Spark configurado em modo standalone, o que permite a utilização desse framework para análises de Big Data e Machine Learning. Siga as instruções abaixo para configurar seu ambiente: 

a) Se estiver usando uma VM, conforme instruções fornecidas no `README.md` do repositório [IDP-BigData](https://github.com/klaytoncastro/idp-bigdata), certifique-se de que a VM está executando e que você pode acessá-la via SSH. Caso tenha optado por hospedar os contêineres diretamente em sua máquina, certifique-se de ter o Git, Docker, Docker Compose e os utilitários de processamento e conversão de textos apropriados. 

b) Navegue até a pasta do repositório, por exemplo: `cd /opt/idp-bigdata`. 

c) Caso **já tenha clonado** o repositório anteriomente, **mas não realizou nenhuma tarefa**, execute o comando a seguir para garantir que seu ambiente esteja com as atualizações mais recentes: 

```bash
git pull origin main
```
d) Caso esta seja a **primeira clonagem** do repositório ou **já tenha realizado alguma operação**, como a importação de dados, execute os comandos abaixo em seu terminal. 

```bash
git clone https://github.com/klaytoncastro/idp-bigdata
chmod +x permissions.sh
./permissions.sh
```

e) Caso queira aproveitar o trabalho anterior, basta renomear a pasta idp-bigdata já clonada e fazer o `git clone` ou `git pull` novamente. 

f) Para permitir a comunicação entre os contêineres do Jupyter e MongoDB, o arquivo `docker-compose.yml` deve ser atualizado para conectá-los à rede `mybridge` que você. 
<!--
Os arquivos `docker-compose` foram recentemente atualizados para contemplar este requisito. Como você já clonou o repositório em sua última versão ou realizou o `git pull origin main`, as alterações descritas abaixo já devem estar implementadas, então você não precisa editar os arquivos manualmente. 
-->
Para explicar o que fizemos, seguem as alterações promovidas: 

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

f) Agora crie a rede virtual `mybridge` no Docker: 

```bash
docker network create --driver bridge mybridge
```
g) Acesse as respectivas subpastas em nosso repositório (`/opt/idp-bigdata/mongodb` e `/opt/idp-bigdata/jupyter-spark`) e suba os contêineres do MongoDB e Jupyter-Spark em cada uma delas: 

```bash
cd /opt/idp-bigdata/mongodb 
docker-compose up -d 
cd /opt/idp-bigdata/jupyter-spark
docker-compose build
docker-compose up -d 
```
h) Caso seja o seu primeiro acesso ao Jupyter, execute o comando a seguir para visualizar os logs e identificar o token para utilizar o ambiente: 

```bash
docker-compose logs | grep 'token='
```

### Via GUI

- Copie o token identificado no passo anterior e acesse o Jupyter em seu navegador usando o [link](http://localhost:8888). Insira o token de acesso e configure uma nova senha. A partir de então, a autenticação por token não será mais necessária, mesmo que você desligue e ligue novamente o ambiente do Jupyter. 

### Via CLI

- Caso deseje alterar a senha via CLI, execute o script abaixo: 

```bash
docker exec -it <nome_do_contêiner> /bin/bash
jupyter config password
```


<!--
### Inicialize e teste o Spark

a) Quando o Apache Spark está em execução, ele disponibiliza uma interface web para viabilizar o acompanhamento das tarefas designadas por sua aplicação. A Spark Application UI (`http://localhost:4040`) só se tornará disponível após a inicialização de uma sessão Spark por uma aplicação. Crie um notebook Python 3 (ipykernel), e teste seu ambiente inicializando uma sessão Spark: 

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()
```
b) Em seu navegador, acesse a URL da [Spark Application UI](http://localhost:4040) e observe que agora ela está disponível. Execute o código abaixo em seu notebook Jupyter para encerrar sua sessão Spark: 

```python
spark.stop()
```
c) Atualize o navegador e observe que a interface http://localhost:4040 não estará mais acessível após encerrarmos a sessão. 

-->

## 3. Integração com ferramentas externas

### Conecte os contêineres à mesma rede virtual

a) Verifique o IP atribuído ao contêiner do MongoDB (pois ele deverá ser referenciado na string de conexão ao banco de dados a partir de seus notebooks Jupyter):

```bash
docker network inspect mybridge
```

b) Teste a conexão ao MongoDB com o código abaixo: 

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

a) Para praticar a análise de dados com Python e MongoDB, sugerimos que você explore datasets de exemplo disponíveis no [Kaggle](https://www.kaggle.com/). O Kaggle é uma plataforma online amplamente utilizada por cientistas de dados, pesquisadores e entusiastas de aprendizado de máquina. Ele oferece um ambiente onde os usuários podem colaborar, compartilhando e aprendendo uns com os outros, além de ter acesso a uma vasta quantidade de datasets e competições de aprendizado de máquina. 

b) Uma excelente referência para começar é o notebook [MongoDB w/ Python](https://www.kaggle.com/code/ganu1899/mongodb-with-python), que apresenta um exemplo prático de como utilizar o MongoDB junto com Python, compatível com nosso ambiente Jupyter. Este notebook abrange a criação de banco de dados e coleções, inserção, busca, atualização e exclusão de documentos, além de operações como ordenação e limitação de resultados. Realize as atividades nele propostas para se ambientar ao Jupyter e MongoDB. 

## 4. Limpeza, Preparação e Importação de Dados Reais

Nesta atividade, utilizaremos o dataset do Censo da Educação Superior de 2022 realizado pelo INEP (Instituto Nacional de Ensino e Pesquisa), disponível [aqui](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos). O Censo é um levantamento anual que coleta informações detalhadas sobre instituições de ensino superior (IES) do Brasil, cursos, alunos e docentes, sendo essencial para compreender a dinâmica do ensino superior no país, identificar desafios e oportunidades para embasar decisões de gestores de políticas educacionais. O banco de dados do INEP contém:

- Dados sobre as IES, como nome, localização e tipo de instituição.
- Informações sobre os cursos oferecidos.
- Dados sobre alunos, como quantidade de matriculados e concluintes.
- Informações sobre os docentes.

Antes de qualquer análise, é importante realizar as etapas de limpeza e preparação de dados. Segundo a literatura especializada, estes passos costumam consumir até 80% do tempo em um projeto de análise de dados. Assim, antes de importar o dataset para o MongoDB, demonstraremos como realizar uma limpeza básica e preparação dos dados disponibilizados pelo INEP.

### Preparando a estrutura de importação

a) Em seu terminal, baixe e descompacte o arquivo do dataset utilizando os comandos abaixo: 

```bash
cd /opt/idp-bigdata/mongodb/datasets
wget https://download.inep.gov.br/microdados/microdados_censo_da_educacao_superior_2022.zip --no-check-certificate
unzip microdados_censo_da_educacao_superior_2022.zip
```
b) Como precisaremos apenas dos arquivos CSVs (Comma Separated Values) com as IES e Cursos por elas disponibilizados, organize a subpasta `datasets` executando os comandos abaixo para manter apenas a estrutura de pastas e dados estritamente necessários. 

```bash
rm microdados_censo_da_educacao_superior_2022.zip && mv microdados_educaЗ╞o_superior_2022 inep
mv inep/dados/*.CSV inep
rm -rf inep/dados && rm -rf inep/Anexos && rm -rf inep/leia-me
```

### Entendendo o processamento de texto

O `sed` (stream editor) é uma ferramenta de processamento de texto disponível em sistemas Linux, usada para analisar, transformar textos e operar em fluxos de dados, realizando operações como substituição, deleção e inserção. Sua flexibilidade vem do uso de expressões regulares, permitindo encontrar e substituir padrões de texto. O `sed` é frequentemente usado em conjunto com outras ferramentas de CLI, como `awk`, `grep` e `cut`, para criar soluções robustas de processamento de textos. Veja alguns exemplos de uso:

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
### Remoção e substituição de caracteres indesejados 

a) Precisaremos realizar a remoção e substituição de caracteres indesejados para viabilizar a correta importação do dataset. Vá até a subpasta do dataset (`cd /opt/idp-bigdata/mongodb/inep`) e execute o comando abaixo:

```bash
sed 's/\"//g; s/;/,/g' MICRODADOS_ED_SUP_IES_2022.CSV > MICRODADOS_ED_SUP_IES_2022_corrigido.csv
```

b) O `;` é utilizado para separar instruções na sintaxe do `sed`. O primeiro trecho `s/\"//g` está removendo todas as aspas duplas do arquivo. O segundo trecho `s/;/,/g` está substituindo todos os ponto e vírgula do texto por vírgulas. 

c) Estas medidas são necessárias para corrigir os dados e torná-los compatíveis para importação no MongoDB, especialmente no que se refere aos campos de endereço das IES, visto que alguns deles possuem `"` de forma inadvertida. Além disso, o dataset original possui campos separados por `;`, o que provocaria erros no processo de importação e não segmentaria os atributos para inserção na base de dados. 

### Verificação de encoding e conversão do dataset

a) Padrões de codificação de texto são conjuntos de mapeamentos de caracteres que definem como eles são representados em bytes para armazenamento e processamento em um computador. 

b) O padrão de codificação ISO 8859-1, também conhecido como Latin-1, é um conjunto de caracteres que inclui os caracteres comuns do ASCII (American Standard Code for Information Interchange) e os adicionais usados por várias línguas do oeste europeu, como acento e cedilha da língua portuguesa.

c) Nos sistemas Linux, o comando `file` é útil para mostrar informações sobre a tipagem do arquivo. A opção `-i` solicita a apresentação do padrão de codificação. Ambos utilizam o padrão ISO 8859-1. Seguem os comandos para verificar a codificação aplicada aos arquivos:

```bash
file -i MICRODADOS_ED_SUP_IES_2022_corrigido.csv
file -i MICRODADOS_CADASTRO_CURSOS_2022.CSV
```
d) Nos sistemas Linux, o utilitário `iconv` é utilizado para converter a codificação de caracteres de determinado arquivo. O trecho `-f ISO-8859-1` indica a codificação original do arquivo e o trecho `-t UTF-8` indica a codificação desejada (conversão). Assim, com o comando abaixo podemos converter os arquivos do formato ISO 8859-1 para UTF-8 requerido por nosso ambiente MongoDB: 

```bash
iconv -f ISO-8859-1 -t UTF-8 MICRODADOS_ED_SUP_IES_2022_corrigido.csv > MICRODADOS_ED_SUP_IES_2022_corrigido_UTF8.csv
```

### Processo de normalização de texto

a) A presença de acentos e caracteres especiais no texto pode causar problemas de inconsistência de codificação e interpretação, especialmente quando há transferência de dados entre diferentes sistemas ou plataformas. Além disso, as consultas aos bancos de dados podem ser dificultadas pela presença de caracteres especiais. Assim, a substituição desses caracteres ajuda a evitar problemas de compatibilidade e consistência. 

b) Dessa forma, a normalização de texto, incluindo a substituição de caracteres especiais, é uma prática comum ao empreender análises de Big Data, sendo crucial para obter resultados mais assertivos em análises de texto. Isso garante um grau mínimo de padronização e evita discrepâncias estatísticas causadas por variações na acentuação de palavras. 

c) Adicionalmente, no contexto de Machine Learning, especialmente nas aplicações envolvendo o processamento de linguagem natural e modelos de linguagem de grande escala (LLM), costuma-se empregar técnicas de stemming para reduzir palavras à sua forma base, facilitando o agrupamento semântico de palavras com mesmo radical, mas que apresentam formas diferentes devido à conjugação verbal, pluralização, dentre outros motivos. 

d) No nosso dataset faremos algo mais simples neste primeiro momento, apenas reduzindo eventuais discrepâncias causadas por acentuações e cedilhas. O comando abaixo utiliza novamente o `sed`, agora para substituir caracteres especiais por seus equivalentes sem acentuação. A opção `-i` indica que a modificação será feita diretamente no arquivo, sem a necessidade de criar um novo:

```bash
sed -i 'y/áàãâäéèêëíìîïóòõôöúùûüçñÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ/aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN/' MICRODADOS_ED_SUP_IES_2022_corrigido_UTF8.csv
```

### Importação para o MongoDB 

a) Uma vez que realizamos uma limpeza e preparação básicas, agora estamos prontos para efetuar a importação de dados para o MongoDB. Utilizaremos o `mongoimport`, uma ferramenta CLI que faz parte do MongoDB e é usada para importar dados no formato JSON, CSV ou TSV em uma coleção. 

b) O comando abaixo é utilizado para executar a ferramenta `mongoimport`, dentro do contêiner do MongoDB. As opções `--db` e `--collection` especificam o banco de dados e a coleção onde os dados serão importados, respectivamente. O parâmetro `--type csv` indica que o arquivo de entrada é um CSV. A opção `--file` especifica o caminho para o arquivo de entrada, no caso, o arquivo base de IES do dataset. O parâmetro `--headerline` indica que a primeira linha do arquivo contém os nomes das colunas. A opção `--ignoreBlanks` ignora campos em branco. Por fim, `--username`, `--password`, e `--authenticationDatabase` são utilizados para autenticação preliminar no MongoDB.

```bash
docker exec -it mongo_service mongoimport --db inep --collection ies --type csv --file /datasets/inep/MICRODADOS_ED_SUP_IES_2022_corrigido_UTF8.csv --headerline --ignoreBlanks --username root --password mongo --authenticationDatabase admin
```
c) Agora vamos repetir todo o processo de preparação, limpeza e importação para o arquivo que irá alimentar a collection `cursos`: 

```bash
sed 's/\"//g; s/;/,/g' MICRODADOS_CADASTRO_CURSOS_2022.CSV > MICRODADOS_CADASTRO_CURSOS_2022_corrigido.CSV

iconv -f ISO-8859-1 -t UTF-8 MICRODADOS_CADASTRO_CURSOS_2022_corrigido.CSV > MICRODADOS_CADASTRO_CURSOS_2022_corrigido_UTF8.CSV

sed -i 'y/áàãâäéèêëíìîïóòõôöúùûüçñÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ/aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN/' MICRODADOS_CADASTRO_CURSOS_2022_corrigido_UTF8.CSV

docker exec -it mongo_service mongoimport --db inep --collection cursos --type csv --file /datasets/inep/MICRODADOS_CADASTRO_CURSOS_2022_corrigido_UTF8.CSV --headerline --ignoreBlanks --username root --password mongo --authenticationDatabase admin
```

## 5. Exploração e Análise de Dados

A Análise Exploratória de Dados (AED) é um método estatístico que busca identificar padrões, relações e anomalias nos dados. Trata-se de uma abordagem para explorar dados de maneira flexível e visual, antes de aplicar métodos estatísticos mais rigorosos. Nesse contexto, a visualização de dados é um componente crucial e ajuda a comunicar informações complexas de maneira mais clara, auxiliando na compreensão dos resultados da análise. 

A seguir, temos um código em Python, que deve ser executado no seu ambiente Jupyter Notebook. Como já realizamos a preparação, limpeza e importação de dados, vamos conectar o Jupyter ao MongoDB e realizar consultas específicas para extrair informações relevantes e, posteriormente, utilizar essas informações para criar visualizações e ilustrar padrões e relações existentes nos dados. Execute cada bloco de código em células do seu Jupyter notebook e entenda como esta análise foi conduzida. Lembre-se de verificar e alterar o endereço IP correspondente ao seu contêiner MongoDB. 

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

### Discussão dos Resultados

A análise exploratória dos dados (AED), demonstrada no código Python acima, proporcionou insights preliminares sobre a situação da educação superior no Brasil, servindo como ponto de partida para investigações mais detalhadas e análises mais profundas. Observamos os seguintes resultados:

- Número de Instituições por Região: a região Sudeste se destaca com a maior concentração de instituições de ensino superior, seguida pelas regiões Nordeste, Sul, Centro-Oeste e Norte. Essa distribuição reflete tanto a densidade populacional quanto o desenvolvimento econômico de cada região.

- Número de Instituições por Estado: São Paulo, Minas Gerais e Rio de Janeiro, todos situados na região Sudeste, possuem a maior quantidade de instituições de ensino superior, o que corrobora os dados apresentados anteriormente.

- Número de Docentes por Faixa Etária: A maioria dos docentes se encontra nas faixas etárias de 35 a 59 anos, evidenciando um corpo docente experiente e consolidado. No entanto, essa concentração de profissionais mais experientes pode sinalizar uma potencial falta de renovação do corpo docente, com um número reduzido de professores mais jovens ingressando na carreira acadêmica. Uma investigação mais aprofundada é necessária para compreender as causas e implicações dessa tendência.

- Proporção de Docentes por Grau Acadêmico: A maioria dos docentes possui doutorado, seguido por mestrado, especialização e graduação, indicando um alto nível de qualificação. Embora o Ministério da Educação (MEC) estabeleça normas preferenciais para docentes com títulos de mestre ou doutor no ensino superior, seria interessante analisar de maneira mais refinada os dados para entender o percentual de docentes com apenas graduação ou especialização e buscar políticas públicas que incentivem a qualificação em nível de pós-graduação stricto sensu.

- Número de Docentes por Raça, Cor e Gênero: A maioria dos docentes se autodeclara branca, seguida por pardos, pretos, amarelos, indígenas e não declarados. É importante analisar se existe uma representação proporcional nas instituições educacionais. Assim, mesmo refletindo a realidade racial em termos absolutos considerando a localidade das IES, pode ser analisada uma falta de diversidade em contextos específicos, como em certas áreas do conhecimento (ciências exatas, humanas e biológicas). Quanto ao gênero, há um equilíbrio entre docentes femininos e masculinos, com uma leve predominância feminina, refletindo a distribuição populacional do Brasil.

## Conclusão 

Este guia apresentou uma AED do Censo da Educação Superior de 2022, adotando soluções como Jupyter e MongoDB, com intuito de oferecer uma experiência prática abrangente, englobando desde os processos iniciais de preparação e limpeza dos dados até as etapas finais de importação, análise e exploração. Assim, ao mesmo tempo que promovemos o desenvolvimento de competências alinhadas às abordagens modernas de Big Data e bancos de dados NoSQL, buscamos facilitar a compreensão acerca da realidade da educação superior no Brasil. Finalizada a análise preliminar, lembre-se de encerrar corretamente o ambiente para evitar perda de dados e corrupção da VM, utilizando o comando `shutdown -h now`. 