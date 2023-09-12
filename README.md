# Instruções para os Laboratórios da disciplina de Big Data e NoSQL

Olá, aluno(a)! Bem-vindo aos laboratórios da disciplina de Big Data e NoSQL. Aqui, você encontrará um conjunto diversificado de ferramentas que serão utilizadas ao longo do curso. Este repositório foi projetado para auxiliá-lo a configurar e gerenciar essas ferramentas. Siga atentamente as instruções abaixo para configurar seu ambiente. 

### Configuração do Ambiente: 

Para garantir uma experiência mais uniforme, fornecemos uma máquina virtual (VM) pré-configurada. Essa abordagem garante que todos comecem o curso com o mesmo ambiente e configurações. Embora o Docker possa rodar diretamente em diversos sistemas operacionais, esta padronização simplifica nosso suporte e proporciona soluções mais ágeis e consistentes diante de eventuais desafios técnicos.

- **Nota**: Se você tem experiência com Docker e prefere executá-lo diretamente no seu sistema operacional, sinta-se à vontade. A estrutura do repositório suporta este modo de operação. Para os usuários dos hardwares mais recentes da Apple, como o M2 e outros processadores novos, é especialmente relevante considerar esta opção, visto que algumas versões do Oracle Virtual Box podem não ser compatíveis com esses dispositivos. 

## 1. Sobre a Imagem OVA

OVA (Open Virtual Appliance ou Open Virtualization Archive) é um formato de empacotamento de arquivos para máquinas virtuais. Basicamente, é um único arquivo que contém todo o conteúdo de uma máquina virtual, incluindo sua configuração, discos virtuais, entre outros. O formato OVA visa facilitar a portabilidade e o deploy de máquinas virtuais, independentemente do software de virtualização utilizado. Uma vez que você tenha um arquivo OVA, você pode importá-lo em várias plataformas de virtualização para iniciar a máquina virtual.

Oracle VirtualBox é um software de virtualização de propósito geral de código aberto. Ele permite que os usuários executem múltiplos sistemas operacionais simultaneamente em uma única máquina física. Ao usar o VirtualBox, você pode criar, gerenciar e executar máquinas virtuais, que são representações completas de computadores, contendo seu próprio sistema operacional, drivers, aplicativos e arquivos, tudo dentro de um ambiente virtualizado. O VirtualBox suporta a criação e gerenciamento de máquinas virtuais para vários sistemas operacionais, incluindo Windows, Linux, MacOS e outros. 

Por meio de um arquivo OVA, você pode importá-lo facilmente para o Oracle VirtualBox para criar uma nova máquina virtual. Essa é uma maneira comum de distribuir ambientes pré-configurados, como laboratórios de teste, ambientes de desenvolvimento ou demonstrações, pois garante que todos os usuários terão exatamente o mesmo ambiente, independentemente de onde eles estejam executando a máquina virtual.

A imagem OVA fornecida foi pré-configurada com 'docker', 'docker-compose', 'git', 'ssh' e outras ferramentas, facilitando a configuração e utilização dos ambientes de laboratório. 

### Como Usar:
1. Baixe a imagem OVA através do [link](https://1drv.ms/f/s!As9_hcVH7a82gpovWfhahtGkRSmriA?e=vFJ2u3).
2. Caso não esteja instalado, baixe e instale o Oracle VirtualBox através do [link](https://www.oracle.com/br/virtualization/technologies/vm/downloads/virtualbox-downloads.html). 
3. Execute o Oracle Virtual Box e clique em **Arquivo** > **Importar Appliance**.
4. Selecione o arquivo OVA baixado e siga as instruções na tela.

### Credenciais para acesso à VM:

- **Usuário:** labihc
- **Senha:** L@b1hc

## 2. Descrição das Ferramentas Utilizadas

### Docker:

Em contextos de Big Data, é comum ter diversos serviços interconectados. Por exemplo, você pode ter uma pipeline de processamento de dados que utiliza o Spark para processamento em memória, o Hadoop para armazenamento de dados distribuídos e múltiplos bancos de dados NoSQL como MongoDB (para armazenamento de documentos), Redis (para armazenamento em cache), Cassandra (para dados altamente distribuídos) e Neo4j (para dados baseados em grafo). Configurar manualmente cada um desses serviços para funcionar em harmonia pode ser uma tarefa desafiadora. 

Nesse cenário, o Docker é uma plataforma que facilita esta tarefa, pois permite desenvolver e executar aplicações dentro de contêineres, que é uma unidade padrão de software que empacota o código e todas as suas dependências, de forma que a aplicação possa ser executada de forma confiável de um ambiente de computação para outro. Pense nos contêineres como uma caixa isolada onde sua aplicação e todas as suas dependências estão empacotadas juntas, o que garante que ela funcione de forma consistente em qualquer ambiente que suporte Docker.

Os contêineres Docker são leves e podem aproveitar a mesma infraestrutura de máquinas físicas ou virtuais. Costumam ser inicializados rapidamente e são portáteis, o que significa que você pode criar um contêiner no seu notebook e reaproveitá-lo facilmente para um ambiente de nuvem ou um servidor. 

### Docker Compose:

O Docker Compose é uma ferramenta dentro do ecossistema Docker que simplifica a definição e gestão de aplicações multicontêiner. Com ele, é possível orquestrar aplicações complexas compostas por vários contêineres interligados, usando um único arquivo: docker-compose.yml. Com um comando simples (docker-compose up -d), todos os contêineres definidos no arquivo são iniciados simultaneamente, garantindo a integração e configuração correta de cada componente.

Imagine uma aplicação que envolve um servidor web, um banco de dados MongoDB e um cache Redis. Em vez de iniciar e configurar cada contêiner manualmente, com o Docker Compose, é possível definir toda essa configuração em um arquivo e ativá-la de uma vez, assegurando que cada contêiner esteja devidamente configurado e interligado.

Dessa forma, com as ferramentas Docker e Docker Compose, ganhamos em conveniência e eficiência, focando no uso das aplicações e eliminando preocupações com instalações e configurações manuais. A imagem OVA padronizada amplia esse benefício, permitindo a evolução e integração do ambiente, aproveitando o poder computacional do laboratório.

Dentro deste projeto, temos diversos diretórios, cada um representando um ambiente específico:

### Hadoop
Neste diretório, você encontrará o ambiente para o Hadoop. 

- **Hadoop**: Framework de código aberto para armazenamento distribuído e processamento de conjuntos de dados grandes, usando o modelo de programação MapReduce.

### Jupyter/Spark
Neste diretório, você encontrará o ambiente com Jupyter Notebook e Spark. 

- **Jupyter Notebook**: É uma aplicação web que permite criar e compartilhar documentos que contêm código ativo, equações, visualizações e texto. Muito usado para análise de dados.
  
- **Spark**: Uma estrutura de processamento de dados rápida, em memória, utilizada para big data analytics.

### MongoDB
Neste diretório, você encontrará o ambiente para o MongoDB.

- **MongoDB**: É um banco de dados NoSQL baseado em documentos, onde cada registro é um documento, que é uma estrutura de dados composta por pares de chave e valor.

### Redis
Neste diretório, você encontrará o ambiente para o Redis.

- **Redis**: Armazenamento de estrutura de dados em memória, usado como banco de dados NoSQL da família chave-valor. É conhecido por sua alta velocidade e flexibilidade em aplicações como cache e corretor de mensagens. 

### Cassandra
Neste diretório, você encontrará o ambiente para o Cassandra.

- **Cassandra**: Banco de dados NoSQL distribuído, projetado para gerenciar grandes volumes de dados em múltiplos servidores sem nenhum ponto único de falha.

### Neo4j
Neste diretório, você encontrará o ambiente para o Neo4j.

- **Neo4j**: É um sistema de gerenciamento de banco de dados NoSQL orientado a grafos, que permite modelar relacionamentos complexos por meio de padrões e estruturas de dados que utilizam os conceitos de nós e arestas. 

## 3. Preparando o Ambiente de Laboratório

Depois de acessar o ambiente virtual:

1. Crie uma pasta e baixe os arquivos do projeto:

```bash   
   sudo su -
   cd /opt
   git clone https://github.com/klaytoncastro/idp-bigdata   
```

3. Entre na subpasta de cada ambiente, construa e inicie os serviços usando o Docker Compose. Por exemplo, para o Jupyter-Spark:

```bash
   cd /opt/idp-bigdata/jupyter-spark
   docker-compose build
   docker-compose up -d
```

### Usando o SSH para para conexão

SSH (Secure Shell) é um protocolo que possibilita a conexão e controle de servidores remotos, como nossa VM no Virtual Box. Para gerenciar nossa VM nos laboratórios, recomendamos o uso de conexões SSH em vez da console física. O [Putty](https://www.putty.org/) é uma opção popular e confiável como cliente SSH, especialmente útil para sistemas Windows, embora esteja disponível para outras plataformas. Sua interface intuitiva e funcionalidades robustas o estabeleceram como preferência entre muitos administradores de sistemas e desenvolvedores ao longo dos anos. 

- **Nota**: Se você já possui outras ferramentas de SSH ou tem uma preferência particular, sinta-se à vontade para utilizá-las em nossos laboratórios. 

1. Conveniência e Eficiência

- **Copiar e Colar**: Ao utilizar SSH, fica muito mais fácil copiar e colar comandos, scripts ou até mesmo arquivos entre o host e a VM. Essa funcionalidade torna a execução de tarefas mais rápida e evita erros humanos que podem ocorrer ao digitar manualmente.

- **Multitarefa**: Com o SSH, é possível abrir várias sessões em paralelo, permitindo que você execute várias tarefas simultaneamente. 

2. Evita limitações da console "física"

- **Resolução e Interface**: A console física do Virtual Box pode apresentar limitações, como resolução de tela reduzida ou interações de interface de usuário não intuitivas. O SSH fornece uma interface padronizada, independentemente do software de virtualização usado.

- **Padrão de Gerenciamento**: Ao se familiarizar com o SSH, você estará equipando-se com uma habilidade crucial, não apenas para este ambiente de laboratório, mas para qualquer situação futura que envolva administração de sistemas, trabalho em cloud, times de infraestrutura, DevOps ou desenvolvimento de soluções profissionais.

### Pronto! 

Agora você está com o ambiente preparado e pronto para começar os laboratórios. Em caso de dúvidas, não hesite em me contactar: [klayton.castro@idp.edu.br](klayton.castro@idp.edu.br). 
