# Introdução

Este projeto consiste em criar um ambiente de envio e coleta de dados via streamming, utilizando um dataset da Formula 1 obtido no [Kaggle](https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020), resultado da coleta via API [Ergast](http://ergast.com/mrd/), conforme descrito neste [artigo](https://www.kdnuggets.com/building-a-formula-1-streaming-data-pipeline-with-kafka-and-risingwave).  

## Como utilizar

1 - Abra o Jupyter em seu navegador e carregue os notebooks. 

2 - Os dados coletados contém informações de diversos anos de corridas da F1, vamos utilizar apenas o ano de 2022. Para isto, execute o notebook `F1.ipynb`. Este deve gerar os dados de 2022 em um arquivo csv que vamos utilizar como fonte para o nosso processo de streamming. 

3 - O Notebook `F1_v2` faz a mesma coisa que o anterior, mas utilizando um arquivo para cada ano de corrida disponível.

4 - Para monitorar o funcionamento Kafka, utilizamos o Kafka-UI. Caso queira visualizar o processo de Consumers e Producers, acesse `http://localhost:8083`. 

5 - Execute o notebook que simula o produtor de conteudo do Kafka: `Producer.ipynb`. 

6 - No projeto original, foi utilizado SGBD PostgreSQL. Adapte o notebook `Consumer.ipynb` para inserir os dados no MongoDB ou Cassandra. 

<!--
para isto vamos usar o pgadmin para fazer a gestão do banco de dados. Acesse pela URL `link: <`http://localhost:80`. Como login e senha, utilize admin/admin <br>
7 - Configure a conexão ao banco do postgres. <br>
    hostname: postgres <br>
    port: 5432 <br>
    username: admin <br>
10 - Crie o banco de dados f1. <br>
11 - Crie o Schema f1_schema. <br>
12 - Execute o notebook [TABELAS_F1](jupyter\TABELAS_F1.ipynb) <br>
13 - Acesse o Grafana: <http://localhost:3000> . Provavelmente irá pedir login e senha: admin/admin <br>
14 - Faça o import do arquivo Json [F1](grafana\f1.json) no Grafana <br>
15 - Execute o notebook [Consumer](jupyter\Consumer.ipynb) <br>
16 - Abra o Grafana novamente e visualize os graficos e dados sendo atualizados. 
-->