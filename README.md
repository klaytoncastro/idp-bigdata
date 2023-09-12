# Instruções para os Laboratórios da disciplina de Big Data e NoSQL

Olá, aluno! Este repositório os recursos necessários para os nossos laboratórios. Siga atentamente as instruções abaixo para configurar seu ambiente.

## 1. Sobre a Imagem OVA


OVA (Open Virtual Appliance ou Open Virtualization Archive) é um formato de empacotamento de arquivos para máquinas virtuais. Basicamente, é um único arquivo que contém todo o conteúdo de uma máquina virtual, incluindo sua configuração, discos virtuais, entre outros. O formato OVA visa facilitar a portabilidade e o deploy de máquinas virtuais, independentemente do software de virtualização utilizado. Uma vez que você tenha um arquivo OVA, você pode importá-lo em várias plataformas de virtualização para iniciar a máquina virtual.

Oracle VirtualBox é um software de virtualização de propósito geral de código aberto. Ele permite que os usuários executem múltiplos sistemas operacionais simultaneamente em uma única máquina física. Ao usar o VirtualBox, você pode criar, gerenciar e executar máquinas virtuais, que são representações completas de computadores, contendo seu próprio sistema operacional, drivers, aplicativos e arquivos, tudo dentro de um ambiente virtualizado. O VirtualBox suporta a criação e gerenciamento de máquinas virtuais para vários sistemas operacionais, incluindo Windows, Linux, MacOS e outros. 

Por meio de um arquivo OVA, você pode importá-lo facilmente para o Oracle VirtualBox para criar uma nova máquina virtual. Essa é uma maneira comum de distribuir ambientes pré-configurados, como laboratórios de teste, ambientes de desenvolvimento ou demonstrações, pois garante que todos os usuários terão exatamente o mesmo ambiente, independentemente de onde eles estejam executando a máquina virtual.


A imagem OVA fornecida foi pré-configurada com 'docker' e 'docker-compose', facilitando a configuração e utilização dos ambientes de laboratório. 


### Como Usar:
1. Baixe a imagem OVA através do [link](https://1drv.ms/f/s!As9_hcVH7a82gpovWfhahtGkRSmriA?e=vFJ2u3).
2. Caso não esteja instalado, baixe e instale o Oracle VirtualBox através do [link](https://www.oracle.com/br/virtualization/technologies/vm/downloads/virtualbox-downloads.html). 
3. Clique em **Arquivo** > **Importar Appliance**.
4. Selecione o arquivo OVA baixado e siga as instruções na tela.

### Credenciais do Ambiente Virtual:

- **Usuário:** labihc
- **Senha:** L@b1hc

## 2. Ambientes de Laboratório

### Docker:

Em contextos de Big Data, é comum ter diversos serviços interconectados. Por exemplo, você pode ter uma pipeline de processamento de dados que utiliza o Spark para processamento em memória, o Hadoop para armazenamento de dados distribuídos e múltiplos bancos de dados NoSQL como MongoDB (para armazenamento de documentos), Redis (para armazenamento em cache), Cassandra (para dados altamente distribuídos) e Neo4j (para dados baseados em grafo). Configurar manualmente cada um desses serviços para funcionar em harmonia pode ser uma tarefa desafiadora. 

Nesse cenário, o Docker é uma plataforma que facilita esta tarefa, pois permite desenvolver e executar aplicações dentro de contêineres, que é uma unidade padrão de software que empacota o código e todas as suas dependências, de forma que a aplicação possa ser executada de forma confiável de um ambiente de computação para outro. Pense nos contêineres como uma caixa isolada onde sua aplicação e todas as suas dependências estão empacotadas juntas, o que garante que ela funcione de forma consistente em qualquer ambiente que suporte Docker.

Os contêineres Docker são leves e podem aproveitar a mesma infraestrutura de máquinas físicas ou virtuais. Costumam ser inicializados rapidamente e são portáteis, o que significa que você pode criar um contêiner no seu notebook e reaproveitá-lo facilmente para um ambiente de nuvem ou um servidor. 

### Docker Compose:

O Docker Compose é uma ferramenta do Docker que permite definir e gerenciar aplicações de vários contêineres. Com o Docker Compose, você pode definir uma aplicação multicontêiner em um único arquivo, o docker-compose.yml, e depois iniciar todos esses contêineres juntos com um único comando (docker-compose up -d). Isso facilita a orquestração e automação de aplicações complexas compostas por vários contêineres interconectados.

No entanto, com o Docker Compose, você pode definir toda essa configuração complexa em um único arquivo, o docker-compose.yml, e depois iniciar todos esses serviços juntos com um único comando (docker-compose up). Isso não apenas garante a integração correta desses componentes, mas também simplifica drasticamente o processo de configuração e implantação.

Por exemplo, se você tiver uma aplicação que requer um servidor web, um banco de dados MongoDB e um cache Redis, em vez de iniciar manualmente cada contêiner e configurá-los para se comunicar entre si, você pode definir essa configuração no docker-compose.yml e iniciar tudo de uma vez. Isso garante que os contêineres tenham a configuração correta e os recursos de rede necessários para se comunicarem entre si.

Assim, com Docker e Docker Compose temos uma grande conveniência e eficiência, permitindo nos concentrar diretamente no uso das ferramentas e aplicações, sem se preocupar com a instalação, configuração e orquestração manual. Além disso, com a imagem OVA padronizada, o ambiente poderá ser evoluído e configurado para compor sistemas distribuídos utilizando o poder computacional de todas as máquinas do Laboratório. 

Dentro deste projeto, temos diversos diretórios, cada um representando um ambiente específico:

### jupyter-spark
Este diretório contém um ambiente com Jupyter Notebook e Spark em modo standalone. 

- **Jupyter Notebook**: É uma aplicação web que permite criar e compartilhar documentos que contêm código ativo, equações, visualizações e texto. Muito usado para análise de dados.
  
- **Spark**: Uma estrutura de processamento de dados rápida, em memória, utilizada para big data analytics.

### mongodb
Dentro deste diretório, temos uma configuração para o MongoDB.

- **MongoDB**: É um banco de dados NoSQL baseado em documentos, onde cada registro é um documento, que é uma estrutura de dados composta por pares de campos e valores.

### neo4j
Neste diretório, está a configuração para o Neo4j.

- **Neo4j**: É um sistema de gerenciamento de banco de dados orientado a grafos, que permite trazer à tona relacionamentos complexos com padrões e estruturas de dados ricos.

## 3. Configurando o Ambiente de Laboratório

Depois de acessar o ambiente virtual:

1. Crie uma pasta e baixe os arquivos do projeto:

'''bash   
   sudo su -
   mkdir /opt/idp-bigdata
   cd /opt/idp-bigdata
   git clone https://github.com/klaytoncastro/idp-bigdata   
'''

3. Entre na subpasta de cada ambiente, construa e inicie os serviços usando o Docker Compose. Ex:

'''bash
   cd /opt/idp-bigdata/jupyter-spark
   docker-compose build
   docker-compose up -d
'''
