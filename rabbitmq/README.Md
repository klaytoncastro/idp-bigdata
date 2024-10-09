# Sistemas de Mensageria

## 1. Visão Geral

Com o avanço da computação em nuvem e as crescentes necessidades de resiliência e escalabilidade, a comunicação eficiente entre serviços distribuídos se tornou um pilar na elaboração de arquiteturas para aplicações modernas. No contexto de Big Data, onde os dados são gerados e consumidos em volumes massivos e com alta velocidade, a troca de dados entre diferentes componentes dos sistemas precisa ser otimizada para garantir que diferentes serviços e aplicações possam trabalhar de forma colaborativa, muitas vezes em ambientes e infraestruturas bastante distintas. 

A estratégia de modelagem de sistemas cujas tarefas podem exigir comunicação síncrona ou assíncrona, depende da criticidade e dos requisitos de latência. Em muitos cenários de Big Data, o processamento em lote ou o processamento em tempo real de eventos pode ser feito de forma assíncrona, onde o tempo de resposta imediato não é crucial. Já em sistemas NoSQL, quando uma consulta de dados precisa ser retornada de maneira imediata, transações síncronas podem ser mais apropriadas.

Dessa forma, é essencial adotar uma abordagem tecnológica com suporte a transações síncronas e assíncronas, permitindo que os componentes das aplicações e serviços se comuniquem de maneira eficiente. Atualmente, essa comunicação precisa ser altamente eficiente e escalável para suportar o processamento paralelo de grandes volumes de dados distribuídos entre vários nós. 

Nesse cenário, soluções como RabbitMQ e Kafka desempenham um papel central na orquestração de dados entre diferentes partes de uma aplicação distribuída, garantindo que as mensagens e eventos possam ser processados adequadamente. O RabbitMQ é amplamente utilizado em casos onde é necessário garantir uma comunicação precisa entre sistemas, como em cenários de processamento de tarefas assíncronas em NoSQL, assegurando que mensagens sejam entregues de forma confiável e com latência controlada. Já o Kafka se destaca em arquiteturas de Big Data, proporcionando processamento em tempo real de grandes fluxos de dados, com suporte a replicação e alta disponibilidade. 

Essa flexibilidade de comunicação e o desacoplamento entre os componentes permitem que os sistemas sejam escaláveis e tolerantes a falhas, características indispensáveis em arquiteturas que lidam com grandes volumes de dados.

## 2. Tipos de Transação e Modelos de Comunicação Distribuída

### Transações Síncronas

Uma transação síncrona ocorre quando o cliente envia uma requisição para o servidor e aguarda até que o servidor retorne uma resposta antes de continuar com qualquer outra operação. Esse tipo de comunicação é bloqueante, o que significa que o processo cliente fica "parado" até receber a resposta. Por exemplo: 

- Chamadas a APIs REST: Quando o cliente faz uma solicitação HTTP e espera uma resposta, como o status de uma transação bancária.
- Sistemas de pagamento: O cliente aguarda a confirmação do pagamento antes de prosseguir.

Essa abordagem preza pela simplicidade, adotando um fluxo de controle sequencial e, portanto, mais fácil de seguir. Também verifica de forma imediata de sucesso ou falha: o cliente recebe imediatamente a confirmação do status da operação. Porém, o cliente pode ficar ocioso enquanto aguarda a resposta do servidor, o que pode ser ineficiente e tende-se a acoplamento Temporal, onde cliente e servidor precisam estar disponíveis ao mesmo tempo, o que pode ser um problema em sistemas distribuídos ou de ampla escala.

### Transações Assíncronas

Uma transação assíncrona ocorre quando o cliente envia uma requisição, mas não precisa esperar pela resposta imediata. Ele pode continuar executando outras operações enquanto a resposta é processada e entregue em algum momento futuro. O cliente pode ser notificado da resposta ou consultar o servidor mais tarde. Por exemplo: 

- Envio de emails: O sistema de email recebe a mensagem e a entrega quando o destinatário estiver disponível, sem bloquear o remetente.
- Fila de trabalho em sistemas de mensageria: O cliente coloca uma tarefa na fila, e o consumidor processa a tarefa conforme estiver disponível.

Essa abordagem prioriza a escalabilidade: O sistema pode processar mais requisições, já que não precisa esperar por uma resposta imediata. Também provê o Desacoplamento Temporal, visto que o cliente e i servidor não precisam estar ativos ao mesmo tempo. Entretanto, lidar com callbacks ou retries para confirmar se a resposta chegou pode aumentar a complexidade do sistema. Em cenários críticos, a espera por uma resposta assíncrona pode ser inconveniente se uma decisão imediata for necessária para o sistema. 

Agora que conhecemos o conceito de transações, existem dois padrões principais para troca de mensagens em sistemas distribuídos:

- **Request/Reply** (Requisição/Resposta): Frequentemente utilizado em RPC (Remote Procedure Call), onde o cliente solicita e aguarda uma resposta do servidor. Isso é útil em casos onde a troca de mensagens deve ser síncrona e o cliente espera uma resposta imediata, como em transações financeiras ou sistemas de e-commerce. Este padrão por vezes também é referenciado como **P2P** (Ponto a Ponto). 

- **Publish/Subscribe** (Publicação/Subscrição): Nesse modelo, os produtores de dados enviam mensagens para tópicos, e os consumidores se inscrevem nos tópicos de interesse. As mensagens publicadas podem ser consumidas por múltiplos consumidores, mesmo que eles não estejam ativos simultaneamente. O modelo Pub/Sub permite maior flexibilidade, pois permite que produtores e consumidores permaneçam desacoplados, promovendo escalabilidade e resiliência em arquiteturas distribuídas. 

### Vantagens do Modelo Request/Reply

O modelo Request/Reply (Requisição/Resposta), é um padrão de mensageria onde uma mensagem é enviada de um produtor (remetente) para um único consumidor (destinatário). Este modelo é amplamente utilizado em sistemas que necessitam de comunicação direta e controle preciso sobre o envio e o recebimento de mensagens.

- Entrega Garantida para um Consumidor Único: Uma das principais vantagens do modelo P2P é que cada mensagem é entregue para um único consumidor, garantindo que a mensagem seja processada apenas uma vez. Isso é particularmente útil em cenários de processamento de tarefas, como em sistemas de filas de trabalho, onde cada tarefa precisa ser executada por apenas uma instância do sistema.

- Simples Controle de Fluxo: Como a mensagem é removida da fila após o consumo, o controle de fluxo é direto. Esse comportamento evita que o mesmo dado seja processado várias vezes, simplificando o gerenciamento de filas e garantindo que uma mensagem seja processada de forma única.

- Simplicidade de Implementação: O modelo P2P é mais simples de implementar e gerenciar em termos de comunicação direta. Não há necessidade de gerenciar tópicos ou assinaturas, como no modelo Pub/Sub. Isso pode ser vantajoso em sistemas menores ou em casos onde não há necessidade de múltiplos consumidores para o mesmo dado.

- Baixa Latência em Cenários Diretos: Como não há múltiplos consumidores para competir pelo processamento da mensagem, a latência pode ser menor, especialmente em situações de baixa concorrência. Isso torna o modelo P2P eficaz em cenários onde o tempo de resposta rápido é necessário.

### Desvantagens do Modelo Request/Reply

- Escalabilidade Limitada: O modelo não escala tão bem quanto o Pub/Sub em ambientes distribuídos. Como cada mensagem só pode ser consumida por um único consumidor, adicionar novos consumidores ao sistema não aumenta a taxa de processamento global, pois apenas um consumidor pode processar uma mensagem específica.

- Ausência de Reprocessamento de Mensagens: Uma vez que uma mensagem é consumida, ela é removida da fila e não pode ser reprocessada. Isso pode ser um problema em casos onde é necessário recuperar ou reprocessar dados anteriores, o que não é possível sem arquiteturas adicionais.

- Dependência Direta entre Produtor e Consumidor: Neste modelo, os produtores e consumidores estão fortemente interligados. Se o consumidor falhar, a mensagem pode ser perdida, ou o sistema terá que lidar com tentativas de reenvio e lógica de falha manualmente. Isso torna o sistema menos flexível e resiliente em comparação ao modelo Pub/Sub.

- Maior Acoplamento: Ao contrário do Pub/Sub, o modelo Request/Reply oferece pouco ou nenhum desacoplamento entre os produtores e consumidores. O sistema não tem a flexibilidade de permitir múltiplos consumidores ou processar a mesma mensagem em diferentes serviços ou contextos.

### Vantagens do modelo Pub/Sub

O modelo Pub/Sub (Publicação/Subscrição) oferece uma série de vantagens no que diz respeito ao desacoplamento de sistemas distribuídos. Aqui estão os principais tipos de desacoplamento:

- Dissociação de Entidades: Produtores e consumidores não precisam saber da existência uns dos outros, permitindo uma evolução independente dos sistemas.
- Desacoplamento Temporal: As partes envolvidas na comunicação não precisam estar ativas ao mesmo tempo.
- Desacoplamento de Sincronização: A entrega das mensagens não precisa ocorrer de forma síncrona, permitindo que os consumidores operem com suas próprias taxas de consumo, sem sobrecarregar o sistema.

Esses fatores tornam sistemas Pub/Sub ideais para arquiteturas baseadas em microsserviços, processamento de eventos em larga escala e integração de componentes distribuídos.

### Desvantagens do Modelo Pub/Sub

Embora o modelo Pub/Sub ofereça muitos benefícios, ele também possui algumas desvantagens que devem ser consideradas:

- Complexidade na Garantia de Ordem: Quando as mensagens são distribuídas em múltiplas partições ou consumidas por diversos consumidores, pode ser difícil garantir que elas sejam processadas na ordem correta. Em sistemas onde a ordem das mensagens é importante, isso pode ser uma limitação significativa.

- Gerenciamento de Estado: Para sistemas distribuídos que dependem fortemente de consumidores, pode ser difícil coordenar e gerenciar o estado entre diferentes consumidores. Isso pode levar à duplicação de dados ou problemas de consistência.

- Sobrecarga no Tratamento de Falhas: Embora o desacoplamento ofereça resiliência, o tratamento de falhas pode se tornar mais complexo. Se um consumidor falhar ou perder mensagens, pode ser necessário reprocessar grandes quantidades de dados, o que pode ser custoso em termos de tempo e recursos.

- Latência em Alta Escala: A entrega de mensagens pode sofrer maior latência quando o número de consumidores cresce, especialmente se os consumidores tiverem velocidades de processamento muito diferentes. Isso pode atrasar a entrega de mensagens críticas.

- Gerenciamento de Offset e Persistência: No Kafka, por exemplo, a configuração e o gerenciamento dos offsets (posições de leitura dos consumidores) podem se tornar complexos, especialmente quando múltiplos consumidores estão envolvidos em diferentes tópicos e partições. A persistência de dados por longos períodos pode ser um problema em termos de custos e capacidade de armazenamento.

## 3. Principais Ferramentas 

Soluções como RabbitMQ, Redis e MQTT são alternativas leves para troca de mensagens, e são indicadas em cenários onde o volume de dados é moderado, baixa latência é uma prioridade e não há necessidade de retenção prolongada de mensagens: 

- RabbitMQ implementa o protocolo AMQP e é ideal para cenários que requerem garantias de entrega e gerenciamento de filas mais complexas.
- Redis é mais adequado para filas de processamento rápido em memória, com retenção temporária, sendo muito utilizado para tarefas com baixa durabilidade.
- MQTT é voltado para comunicação entre dispositivos IoT, sendo eficiente em ambientes com alta latência de rede e com baixa capacidade de processamento.

Por sua vez, o Apache Kafka é uma plataforma de streaming de dados distribuída e de código aberto, projetada para lidar com ingestão, armazenamento e processamento de dados em tempo real em larga escala e de modo mais tolerante a falhas, o que o torna ideal para sistemas que exigem alta disponibilidade e grandes volumes de dados, sendo a melhor escolha em cenários que exigem:

- Alta Escalabilidade e Volume de Dados: Kafka foi projetado para escalar horizontalmente e processar bilhões de eventos por dia.
- Persistência de Dados: As mensagens podem ser armazenadas por longos períodos, permitindo o reprocessamento e análise posterior dos dados.
- Múltiplos Consumidores: Kafka permite que diferentes consumidores leiam as mesmas mensagens, em tempos distintos, sem comprometer a performance.

Em sistemas tradicionais de mensageria, como o RabbitMQ, as mensagens são removidas após o consumo. A abordagem ponto a ponto é eficiente para processamento de tarefas onde a mensagem só precisa ser consumida uma vez, sendo a abordagem mais popular no modelo request/reply. Já no Kafka, as mensagens são persistidas e não são removidas imediatamente após o consumo, permitindo que múltiplos consumidores acessem os mesmos dados, ou que dados antigos sejam reprocessados. Isso é ideal para cenários como logs de auditoria e análises de eventos em tempo real.