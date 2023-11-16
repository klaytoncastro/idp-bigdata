# Apacha Kafka

O Apache Kafka é uma plataforma de streaming de dados distribuída e de código aberto que foi originalmente desenvolvida pelo LinkedIn e posteriormente doada à Apache Software Foundation, tornando-se um projeto de código aberto. A arquitetura do Apache Kafka é projetada para lidar com a ingestão, o armazenamento e o processamento de dados em tempo real em larga escala. Pode ser usado para criar aplicativos de streaming em tempo real para operacionalizar fluxos de dados, transformar ou deduzir alguma inteligência deles, provendo: 

- Escalabilidade: Capaz de lidar com a escalabilidade em todas as quatro dimensões (produtores de eventos, processadores de eventos, consumidores de eventos e conectores de eventos.
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

