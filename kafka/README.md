# Apacha Kafka

O Apache Kafka é uma plataforma de streaming de dados distribuída e de código aberto que foi originalmente desenvolvida pelo LinkedIn e posteriormente doada à Apache Software Foundation, tornando-se um projeto de código aberto. A arquitetura do Apache Kafka é projetada para lidar com a ingestão, o armazenamento e o processamento de dados em tempo real em larga escala. Pode ser usado para criar aplicativos de streaming em tempo real para operacionalizar fluxos de dados, transformar ou deduzir alguma inteligência deles, provendo: 

- Escalabilidade: Capaz de lidar com a escalabilidade em todas as quatro dimensões (produtores de eventos, processadores de eventos, consumidores de eventos e conectores de eventos).
- Alto Volume: Capaz de trabalhar com enorme volume de fluxos de dados.
- Transformações de Dados: Capaz de derivar novos fluxos de dados usando os fluxos de dados dos produtores.
- Baixa latência: Capaz de atender casos de uso tradicionais de mensagens, que requerem baixa latência.
- Tolerância à Falha: Capaz de lidar com falhas com os nós mestres e as bases de dados.

Os principais componentes de sua arquitetura incluem: 

- Produtores (Producers): Os produtores são responsáveis por enviar dados para os tópicos do Kafka. Eles podem ser aplicativos, sistemas ou dispositivos que geram dados em tempo real e desejam transmiti-los para o Kafka. 

- Tópicos (Topics): Os tópicos são canais de comunicação de dados no Kafka. Eles servem como categorias que organizam os dados. Os produtores enviam dados para tópicos específicos, e os consumidores leem dados de tópicos específicos.

- Brokers: Os brokers são servidores Kafka que armazenam os dados e os disponibilizam para os consumidores. Os tópicos são divididos em partições, e cada partição é replicada para garantir alta disponibilidade e durabilidade. Os brokers gerenciam essas partições e replicam os dados entre eles.

- Consumidores (Consumers): Os consumidores são aplicativos ou sistemas que leem dados dos tópicos do Kafka. Eles podem processar os dados em tempo real ou armazená-los em outro local para análises posteriores.

- ZooKeeper: Embora o Kafka tenha originalmente usado o Apache ZooKeeper para gerenciamento de metadados e coordenação de cluster, em versões mais recentes começou a priorizar sua própria implementação de coordenação interna, tornando-se menos dependente do ZooKeeper.

<!--

Principais Componentes da Arquitetura do Kafka
Produtores (Producers): Enviam dados para tópicos no Kafka. Eles podem ser aplicativos, sistemas ou dispositivos que geram dados em tempo real.

Tópicos (Topics): São canais de comunicação que categorizam os dados. Os produtores enviam dados para tópicos, e os consumidores leem desses tópicos.

Brokers: Servidores que armazenam os dados e os disponibilizam para os consumidores. Eles replicam e distribuem as partições dos tópicos entre diferentes nós para garantir alta disponibilidade.

Consumidores (Consumers): Aplicativos ou sistemas que leem dados dos tópicos. Podem processar em tempo real ou armazenar para análise posterior.

ZooKeeper: Originalmente utilizado para gerenciar metadados e coordenar clusters. Em versões mais recentes, Kafka passou a usar um sistema de coordenação interna, eliminando a dependência do ZooKeeper.

Por Que Kafka é Rápido?
Zero Copy: O Kafka utiliza técnicas de otimização de dados que permitem mover dados diretamente no kernel do sistema operacional, reduzindo a latência.
Gravação Sequencial em Disco: Kafka escreve dados sequencialmente, evitando operações aleatórias de disco, o que melhora a performance de I/O.
Batching de Dados: Kafka agrupa os dados em blocos para melhorar a eficiência.
Armazenamento Persistente: Kafka armazena as mensagens em logs, que podem ser replicados para garantir durabilidade e resiliência em caso de falhas.


O modelo P2P é ideal em cenários onde:

A comunicação deve ser direta e garantida: Processos em que uma mensagem só deve ser entregue a um único destinatário, como sistemas de filas de trabalho ou filas de processamento de pedidos.
Baixa complexidade de comunicação: Sistemas menores ou menos complexos onde a simplicidade na entrega e no controle de mensagens é uma prioridade.
Necessidade de baixa latência: Aplicações que precisam de respostas rápidas e não se beneficiam de múltiplos consumidores.
Exemplos de Uso:
Sistemas de Processamento de Pedidos: Um sistema de e-commerce que processa pedidos e distribui cada pedido para um único servidor de processamento.
Filas de Trabalho: Sistemas que dividem tarefas entre diferentes consumidores, como no processamento de imagens, onde cada imagem é processada por apenas uma instância.
Comparação com Pub/Sub
Característica	Point-to-Point (P2P)	Pub/Sub
Destinatário	Um único consumidor por mensagem	Múltiplos consumidores
Escalabilidade	Limitada	Alta escalabilidade
Desacoplamento	Fracamente desacoplado	Fortemente desacoplado
Persistência de Mensagens	Não há persistência	Persistência configurável
Reprocessamento de Mensagens	Não é possível	Permitido com configuração
Latência	Baixa em ambientes simples	Pode aumentar com mais consumidores



-->