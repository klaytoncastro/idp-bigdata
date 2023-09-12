# Instruções para os Laboratórios da disciplina de Big Data e NoSQL

Olá, aluno(a)! Bem-vindo aos laboratórios da disciplina de Big Data e NoSQL. Aqui, você encontrará um conjunto diversificado de ferramentas que serão utilizadas ao longo do curso. Este repositório foi projetado para auxiliá-lo a configurar e gerenciar essas ferramentas. Siga atentamente as instruções abaixo para configurar seu ambiente. 

### Configuração do Ambiente: 

Para garantir uma experiência mais uniforme, fornecemos uma máquina virtual (VM) pré-configurada. Essa abordagem garante que todos comecem o curso com o mesmo ambiente e configurações. Embora o Docker possa rodar diretamente em diversos sistemas operacionais, esta padronização simplifica nosso suporte e proporciona soluções mais ágeis e consistentes diante de eventuais desafios técnicos.

- **Nota**: Se você tem experiência com Docker e prefere executá-lo diretamente no seu sistema operacional, sinta-se à vontade. A estrutura do repositório suporta este modo de operação. Para os usuários dos hardwares mais recentes da Apple, como o M2 e outros processadores novos, é especialmente relevante considerar esta opção, visto que algumas versões do Oracle Virtual Box podem não ser compatíveis com esses dispositivos. 

## 1. Sobre o Oracle Virtual Box e a imagem OVA

Oracle VirtualBox é um software de virtualização de propósito geral de código aberto. Ele permite que os usuários executem múltiplos sistemas operacionais simultaneamente em uma única máquina física. Ao usar o VirtualBox, você pode criar, gerenciar e executar máquinas virtuais, que são representações completas de computadores, contendo seu próprio sistema operacional, drivers, aplicativos e arquivos, tudo dentro de um ambiente virtualizado. O VirtualBox suporta a criação e gerenciamento de máquinas virtuais para vários sistemas operacionais, incluindo Windows, Linux, MacOS e outros. 

OVA (Open Virtual Appliance ou Open Virtualization Archive) é um formato de empacotamento de arquivos para máquinas virtuais. Basicamente, é um único arquivo que contém todo o conteúdo de uma máquina virtual, incluindo sua configuração, discos virtuais, entre outros. O formato OVA visa facilitar a portabilidade e o deploy de máquinas virtuais, independentemente do software de virtualização utilizado. Uma vez que você tenha um arquivo OVA, você pode importá-lo em várias plataformas de virtualização para iniciar a máquina virtual.

Por meio de um arquivo OVA, você pode importá-lo facilmente para o Oracle VirtualBox para criar uma nova máquina virtual. Essa é uma maneira comum de distribuir ambientes pré-configurados, como laboratórios de teste, ambientes de desenvolvimento ou demonstrações, pois garante que todos os usuários terão exatamente o mesmo ambiente, independentemente de onde eles estejam executando a máquina virtual.

A imagem OVA fornecida foi pré-configurada com 'docker', 'docker-compose', 'git', 'ssh' e outras ferramentas, facilitando a configuração e utilização dos ambientes de laboratório. 

### Como Usar:
1. Baixe a imagem OVA através do [link](https://1drv.ms/f/s!As9_hcVH7a82gpovWfhahtGkRSmriA?e=vFJ2u3).
2. Caso não esteja instalado, baixe e instale o Oracle VirtualBox através do [link](https://www.oracle.com/br/virtualization/technologies/vm/downloads/virtualbox-downloads.html).
3. Escolha a versão correspondente ao seu sistema operacional e siga as instruções de instalação. 
4. Execute o Oracle Virtual Box, vá até **Arquivo** e clique em **Importar Appliance**.
5. Selecione o arquivo OVA baixado e siga as instruções na tela.

### Credenciais para acesso à VM:

- **Usuário:** labihc
- **Senha:** L@b1hc

## 2. Descrição das Ferramentas Utilizadas

### Docker:

Em contextos de Big Data, é comum a interconexão de diversos serviços. Por exemplo, uma pipeline de processamento de dados pode envolver o Spark para processamento em memória, o Hadoop para armazenamento distribuído e bancos de dados NoSQL como MongoDB, Redis, Cassandra e Neo4j para diferentes finalidades. Manualmente, configurar esses serviços para trabalharem em conjunto é desafiador.

O Docker surge como solução, permitindo desenvolver e executar aplicações em contêineres. Esses contêineres são unidades padrão de software que contêm o código e todas as suas dependências, garantindo consistência em diferentes ambientes. Eles são leves, iniciam rapidamente e são altamente portáteis, facilitando a transição entre, por exemplo, um notebook e um servidor ou ambiente de nuvem.

### Docker Compose:

O Docker Compose é uma ferramenta do ecossistema Docker projetada para definir e gerenciar aplicações multicontêiner. Através do arquivo docker-compose.yml, é possível orquestrar aplicações complexas compostas por diversos contêineres. Com o comando docker-compose up -d, todos os contêineres especificados são iniciados simultaneamente, garantindo sua configuração e integração correta.

Por exemplo, para uma aplicação que combina um servidor web, um banco de dados MongoDB e um cache Redis, o Docker Compose elimina a necessidade de configuração manual de cada contêiner. Basta definir a configuração em um arquivo e ativá-la.

Com Docker e Docker Compose, simplificamos o processo de implantação e integração de aplicações, reduzindo preocupações com procedimentos manuais. A utilização de uma imagem OVA padronizada eleva essa eficiência, maximizando o aproveitamento do poder computacional disponível.

Dentro deste projeto, temos diversos diretórios, cada um representando um ambiente específico:

### Hadoop
Neste diretório, você encontrará o ambiente para o Hadoop. 

- **Hadoop**: Framework de código aberto para armazenamento distribuído e processamento de conjuntos de big data, usando o modelo de programação MapReduce.

### Jupyter/Spark
Neste diretório, você encontrará o ambiente com Jupyter Notebook e Spark. 

- **Jupyter Notebook**: É uma aplicação web que permite criar e compartilhar documentos que contêm código ativo, equações, visualizações e texto. Muito usado para análise de dados.
  
- **Spark**: Uma estrutura de processamento de dados rápida, em memória, utilizada para big data analytics.

### MongoDB
Neste diretório, você encontrará o ambiente para o MongoDB.

- **MongoDB**: É um banco de dados NoSQL baseado em documentos, onde cada registro é um documento, e sua estrutura de dados é composta por pares de chave e valor agrupadas em coleções.

### Redis
Neste diretório, você encontrará o ambiente para o Redis.

- **Redis**: É um banco de dados NoSQL da família chave-valor, voltado ao armazenamento de estrutura de dados em memória. É conhecido por sua alta velocidade e flexibilidade em aplicações como cache e broker de mensagens. 

### Cassandra
Neste diretório, você encontrará o ambiente para o Cassandra.

- **Cassandra**: Banco de dados NoSQL distribuído, orientado a colunas, projetado para gerenciar grandes volumes de dados em múltiplos servidores.

### Neo4j
Neste diretório, você encontrará o ambiente para o Neo4j.

- **Neo4j**: É um sistema de gerenciamento de banco de dados NoSQL orientado a grafos, que permite modelar relacionamentos complexos por meio de padrões e estruturas de dados que utilizam os conceitos de nós e arestas. 

## 3. Preparando o Ambiente de Laboratório

### Usando o SSH para para conexão

SSH (Secure Shell) é um protocolo que possibilita a conexão e controle de servidores remotos, como nossa VM no Virtual Box. Para gerenciar nossa VM nos laboratórios, recomendamos o uso de conexões SSH em vez da console física. O [Putty](https://www.putty.org/) é uma opção popular e confiável como cliente SSH, especialmente útil para sistemas Windows, embora esteja disponível para outras plataformas. Sua interface intuitiva e funcionalidades robustas o estabeleceram como preferência entre muitos administradores de sistemas e desenvolvedores ao longo dos anos. 

- **Nota**: Se você já possui outras ferramentas de SSH ou tem uma preferência particular, sinta-se à vontade para utilizá-las em nossos laboratórios. 

1. Conveniência e Eficiência

- **Copiar e Colar**: Ao utilizar SSH, fica muito mais fácil copiar e colar comandos, scripts ou até mesmo arquivos entre o host e a VM. Essa funcionalidade torna a execução de tarefas mais rápida e evita erros humanos que podem ocorrer ao digitar manualmente.

- **Multitarefa**: Com o SSH, é possível abrir várias sessões em paralelo, permitindo que você execute várias tarefas simultaneamente. 

2. Evita limitações da console "física"

- **Resolução e Interface**: A console física do Virtual Box pode apresentar limitações, como resolução de tela reduzida ou interações de interface de usuário não intuitivas. O SSH fornece uma interface padronizada, independentemente do software de virtualização usado.

- **Padrão de Gerenciamento**: Ao se familiarizar com o SSH, você estará equipando-se com uma habilidade crucial, não apenas para este ambiente de laboratório, mas para qualquer situação futura que envolva administração de sistemas, trabalho em cloud, times de infraestrutura, DevOps ou desenvolvimento de soluções profissionais.

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

### Pronto! 

Agora você está com o ambiente preparado e pronto para começar os laboratórios. Em caso de dúvidas, não hesite em me contactar: [klayton.castro@idp.edu.br](klayton.castro@idp.edu.br). 
