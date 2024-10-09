# Sistemas de Mensageria

## 1. Visão Geral

Com o avanço da computação em nuvem e a crescente demanda por resiliência e escalabilidade, a comunicação eficiente entre serviços distribuídos se tornou um pilar fundamental na criação de arquiteturas modernas. No contexto de Big Data, onde os dados são gerados e consumidos em grandes volumes e alta velocidade, a troca de informações entre os componentes precisa ser otimizada para garantir a colaboração eficiente entre serviços, mesmo em ambientes e infraestruturas distintos.

A escolha entre comunicação síncrona e assíncrona depende dos requisitos de criticidade e latência. O processamento assíncrono é comum em Big Data, especialmente quando a resposta imediata não é essencial, como no caso de ingestão e processamento de grandes volumes de dados. Em sistemas NoSQL, que muitas vezes priorizam alta disponibilidade e eventual consistência, o processamento tende a ser assíncrono, mas em alguns casos específicos, quando é necessário garantir respostas rápidas e consistência imediata, transações síncronas podem ser utilizadas.

É essencial adotar uma abordagem tecnológica que suporte ambos os modos de comunicação, garantindo eficiência e escalabilidade. Isso é particularmente importante para suportar o processamento paralelo de grandes volumes de dados distribuídos entre vários nós, uma característica indispensável em arquiteturas que buscam alta coesão e baixo acoplamento entre seus componentes.

Nesse cenário, RabbitMQ e Kafka emergem como soluções para a orquestração de dados em aplicações distribuídas. O RabbitMQ é amplamente utilizado em casos que exigem comunicação que as mensagens sejam entregues de maneira imediatamente confiável e com latência controlada. Ele é ideal para sistemas que envolvem tarefas assíncronas de menor volume e controle fino sobre o roteamento de mensagens, como processamento de filas e tarefas distribuídas.

Já o Kafka se destaca em arquiteturas de Big Data e streaming de eventos, sendo projetado para lidar com grandes fluxos de dados em tempo real. O Kafka é particularmente adequado para cenários onde a ingestão contínua e a alta demanda por escalabilidade são requisitos, oferecendo suporte nativo a replicação, alta disponibilidade e tolerância a falhas. Além disso, sua estrutura de logs de eventos e capacidade de processamento distribuído o tornam ideal para sistemas que precisam de processamento contínuo e análise de grandes volumes de dados.

## 2. Tipos de Transação e Modelos de Comunicação Distribuída

### Transações Síncronas

Uma transação síncrona ocorre quando o cliente envia uma requisição para o servidor e aguarda até que o servidor retorne uma resposta antes de continuar com qualquer outra operação. Esse tipo de comunicação é bloqueante, o que significa que o processo cliente fica "parado" até receber a resposta. Por exemplo: 

- Chamadas a APIs REST: Quando o cliente faz uma solicitação HTTP e espera uma resposta, como o status de uma transação bancária.
- Sistemas de pagamento: O cliente aguarda a confirmação do pagamento antes de prosseguir.

Essa abordagem preza pela simplicidade, adotando um fluxo de controle sequencial. Também verifica de forma imediata de sucesso ou falha: o cliente recebe imediatamente a confirmação do status da operação. Porém, o cliente pode ficar ocioso enquanto aguarda a resposta do servidor, o que pode ser ineficiente e tende-se a acoplamento temporal, onde cliente e servidor precisam estar disponíveis ao mesmo tempo, o que pode ser um problema em sistemas distribuídos ou de ampla escala. Quanto maior a distância, maior o tempo de resposta, o que pode afetar diretamente a experiência do usuário e a eficiência do sistema. Em grandes sistemas distribuídos, garantir uma baixa latência pode se tornar uma preocupação significativa, especialmente quando o cliente e o servidor estão localizados em diferentes regiões geográficas. 

### Transações Assíncronas

Uma transação assíncrona ocorre quando o cliente envia uma requisição, mas não precisa esperar pela resposta imediata. Ele pode continuar executando outras operações enquanto a resposta é processada e entregue em algum momento futuro. O cliente pode ser notificado da resposta ou consultar o servidor mais tarde. Por exemplo: 

- Envio de emails: O sistema de email recebe a mensagem e a entrega quando o destinatário estiver disponível, sem bloquear o remetente.
- Fila de trabalho em sistemas de mensageria: O cliente coloca uma tarefa na fila, e o consumidor processa a tarefa conforme estiver disponível.

Essa abordagem prioriza a escalabilidade: O sistema pode processar mais requisições, já que não precisa esperar por uma resposta imediata. Também provê o Desacoplamento Temporal, visto que o cliente e i servidor não precisam estar ativos ao mesmo tempo. Entretanto, lidar com callbacks ou retries para confirmar se a resposta chegou pode aumentar a complexidade do sistema. Em cenários críticos, a espera por uma resposta assíncrona pode ser inconveniente se uma decisão imediata for necessária para o sistema. Sistemas assíncronos também precisam lidar com falhas de forma robusta. Isso pode ser feito através de mecanismos como callbacks, onde o cliente é notificado quando a resposta está pronta, ou através de polling, onde o cliente periodicamente verifica o status da solicitação. Em arquiteturas modernas, o uso de promises ou arquiteturas reativas são populares para gerenciar tarefas assíncronas e garantir resiliência e tolerância a falhas.

### Padrões de Comunicação em Sistemas de Mensageria

Agora que conhecemos o conceito de transações, existem dois padrões principais para troca de mensagens em sistemas distribuídos:

- **Request/Reply** (Requisição/Resposta): Frequentemente utilizado em RPC (Remote Procedure Call), onde o cliente solicita e aguarda uma resposta do servidor. Isso é útil em casos onde a troca de mensagens deve ser síncrona e o cliente espera uma resposta imediata, como em transações financeiras ou sistemas de e-commerce. Este padrão por vezes também é referenciado como **P2P** (Ponto a Ponto). Em transações síncronas, é essencial implementar time-outs, para evitar que o cliente fique esperando indefinidamente por uma resposta. Isso permite que o sistema tome uma ação alternativa ou retorne uma mensagem de erro em caso de demora excessiva. 

- **Publish/Subscribe** (Publicação/Subscrição): Nesse modelo, os produtores de dados enviam mensagens para tópicos, e os consumidores se inscrevem nos tópicos de interesse. As mensagens publicadas podem ser consumidas por múltiplos consumidores, mesmo que eles não estejam ativos simultaneamente. O modelo Pub/Sub permite maior flexibilidade, pois permite que produtores e consumidores permaneçam desacoplados, promovendo escalabilidade e resiliência em arquiteturas distribuídas. Um dos cuidados em relação a essa abordagem é o gerenciamento dos offsets — que norteia a posição de leitura dos consumidores. Quando múltiplos consumidores estão distribuídos entre diferentes tópicos e partições, garantir que todos os dados sejam consumidos na ordem correta e sem perdas pode se tornar complexo. Além disso, o balanceamento de carga entre consumidores deve estar bem ajustado para evitar gargalos em sistemas com alta demanda. 

### Vantagens do Modelo Request/Reply

Vimos que o modelo Request/Reply (Requisição/Resposta), é um padrão de mensageria onde uma mensagem é enviada de um produtor (remetente) para um único consumidor (destinatário). Este modelo é amplamente utilizado em sistemas que necessitam de comunicação direta e controle preciso sobre o envio e o recebimento de mensagens, apresentando as seguintes vantagens: 

- Entrega Garantida para um Consumidor Único: Uma das principais vantagens do modelo P2P é que cada mensagem é entregue para um único consumidor, garantindo que a mensagem seja processada apenas uma vez. Isso é particularmente útil em cenários de processamento de tarefas, como em sistemas de filas de trabalho, onde cada tarefa precisa ser executada por apenas uma instância do sistema.

- Simples Controle de Fluxo: Como a mensagem é removida da fila após o consumo, o controle de fluxo é direto. Esse comportamento evita que o mesmo dado seja processado várias vezes, simplificando o gerenciamento de filas e garantindo que uma mensagem seja processada de forma única.

- Simplicidade de Implementação: O modelo P2P é mais simples de implementar e gerenciar em termos de comunicação direta. Não há necessidade de gerenciar tópicos ou assinaturas, como no modelo Pub/Sub. Isso pode ser vantajoso em sistemas menores ou em casos onde não há necessidade de múltiplos consumidores para o mesmo dado.

- Baixa Latência em Cenários Diretos: Como não há múltiplos consumidores para competir pelo processamento da mensagem, a latência pode ser menor, especialmente em situações de baixa concorrência. Isso torna o modelo P2P eficaz em cenários onde o tempo de resposta rápido é necessário.

### Desvantagens do Modelo Request/Reply

Por sua vez, seguem algumas limitações e desafios relativo à implementação deste modelo:

- Escalabilidade Limitada: O modelo não escala tão bem quanto o Pub/Sub em ambientes distribuídos. Como cada mensagem só pode ser consumida por um único consumidor, adicionar novos consumidores ao sistema não aumenta a taxa de processamento global, pois apenas um consumidor pode processar uma mensagem específica.

- Ausência de Reprocessamento de Mensagens: Uma vez que uma mensagem é consumida, ela é removida da fila e não pode ser reprocessada. Isso pode ser um problema em casos onde é necessário recuperar ou reprocessar dados anteriores, o que não é possível sem arquiteturas adicionais.

- Dependência Direta entre Produtor e Consumidor: Neste modelo, os produtores e consumidores estão fortemente interligados. Se o consumidor falhar, a mensagem pode ser perdida, ou o sistema terá que lidar com tentativas de reenvio e lógica de falha manualmente. Isso torna o sistema menos flexível e resiliente em comparação ao modelo Pub/Sub.

- Maior Acoplamento: Ao contrário do Pub/Sub, o modelo Request/Reply oferece pouco ou nenhum desacoplamento entre os produtores e consumidores. O sistema não tem a flexibilidade de permitir múltiplos consumidores ou processar a mesma mensagem em diferentes serviços ou contextos.

### Vantagens do modelo Pub/Sub

Vimos que o modelo Pub/Sub (Publicação/Subscrição) oferece uma série de vantagens no que diz respeito ao desacoplamento de sistemas distribuídos. Esses fatores tornam sistemas Pub/Sub ideais para arquiteturas baseadas em microsserviços, processamento de eventos em larga escala e integração de componentes em ambientes geograficamente mais dispersos. Aqui estão os principais benefícios desta abordagem: 

- Dissociação de Entidades: Produtores e consumidores não precisam saber da existência uns dos outros, permitindo uma evolução independente dos sistemas.
- Desacoplamento Temporal: As partes envolvidas na comunicação não precisam estar ativas ao mesmo tempo.
- Desacoplamento de Sincronização: A entrega das mensagens não precisa ocorrer de forma síncrona, permitindo que os consumidores operem com suas próprias taxas de consumo, sem sobrecarregar o sistema.

### Desvantagens do Modelo Pub/Sub

Embora o modelo Pub/Sub ofereça muitos benefícios, ele também possui algumas desvantagens que devem ser consideradas:

- Complexidade na Garantia de Ordem: Quando as mensagens são distribuídas em múltiplas partições ou consumidas por diversos consumidores, pode ser difícil garantir que elas sejam processadas na ordem correta. Em sistemas onde a ordem das mensagens é importante, isso pode ser uma limitação significativa.

- Gerenciamento de Estado: Para sistemas distribuídos que dependem fortemente de consumidores, pode ser difícil coordenar e gerenciar o estado entre diferentes consumidores. Isso pode levar à duplicação de dados ou problemas de consistência.

- Sobrecarga no Tratamento de Falhas: Embora o desacoplamento ofereça resiliência, o tratamento de falhas pode se tornar mais complexo. Se um consumidor falhar ou perder mensagens, pode ser necessário reprocessar grandes quantidades de dados, o que pode ser custoso em termos de tempo e recursos.

- Latência em Alta Escala: A entrega de mensagens pode sofrer maior latência quando o número de consumidores cresce, especialmente se os consumidores tiverem velocidades de processamento muito diferentes. Isso pode atrasar a entrega de mensagens críticas.

- Gerenciamento de Offset e Persistência: No Kafka, por exemplo, a configuração e o gerenciamento dos offsets (posições de leitura dos consumidores) podem se tornar complexos, especialmente quando múltiplos consumidores estão envolvidos em diferentes tópicos e partições. A persistência de dados por longos períodos pode ser um problema em termos de custos e capacidade de armazenamento.

## 3. Principais Ferramentas 

Soluções como RabbitMQ, Redis e MQTT são alternativas de soluções para troca de mensagens, sendo indicadas em cenários onde o volume de dados é moderado, baixa latência é uma prioridade e não há necessidade de retenção prolongada de mensagens: 

- RabbitMQ implementa o protocolo AMQP e é ideal para cenários que requerem garantias de entrega e gerenciamento de filas mais complexas.
- Redis é mais adequado para filas de processamento rápido em memória, com retenção temporária, sendo muito utilizado para tarefas com baixa durabilidade.
- MQTT é voltado para comunicação entre dispositivos IoT, sendo eficiente em ambientes com alta latência de rede e com baixa capacidade de processamento.

Por sua vez, o Kafka é uma plataforma de streaming de dados distribuída e de código aberto, projetada para lidar com ingestão, armazenamento e processamento de dados em tempo real em larga escala e de modo mais tolerante a falhas, o que o torna ideal para sistemas que exigem alta disponibilidade e grandes volumes de dados, sendo a melhor escolha em cenários que exigem:

- Alta Escalabilidade e Volume de Dados: Kafka foi projetado para escalar horizontalmente e processar bilhões de eventos por dia.
- Persistência de Dados: As mensagens podem ser armazenadas por longos períodos, permitindo o reprocessamento e análise posterior dos dados.
- Múltiplos Consumidores: Kafka permite que diferentes consumidores leiam as mesmas mensagens, em tempos distintos, sem comprometer a performance.

A abordagem ponto a ponto é eficiente para processamento de tarefas onde a mensagem só precisa ser consumida uma vez, sendo a abordagem mais popular no modelo request/reply, podendo ser implementada pelo RabbitMQ, sendo mais apropriada para cenários com volumes menores. Já no Kafka, as mensagens são persistidas e podem ser relidas mesmo após o consumo, permitindo que múltiplos consumidores acessem os mesmos dados, ou que dados antigos sejam reprocessados. Isso é ideal para cenários envolvendo logs de auditoria e análises de eventos em tempo real.

## 4. Prática

Esta seção básica de prática aborda a configuração e o uso de um ambiente **RabbitMQ** com interface de usuário (UI) para gerenciar filas, exchanges e monitorar mensagens publicadas e consumidas. Ao final, você será capaz de criar filas, publicar mensagens e consumir mensagens diretamente da interface gráfica.

### Acessando a UI do RabbitMQ

1. Certifique-se de que o container do **RabbitMQ** com UI esteja rodando (`docker compose up -d` && `docker ps`).
2. Acesse a interface do RabbitMQ no seu navegador através do seguinte endereço:
   - **URL**: `http://localhost:15672`
3. Faça login com as credenciais configuradas no seu `docker-compose.yml`. 

<!--(ou as padrão `guest` / `guest`, se não modificadas).-->

### Explorando a UI do RabbitMQ

1. Overview

- Ao acessar a interface, você verá a aba **Overview**, que fornece um resumo do estado atual do RabbitMQ, mostrando o número de conexões, filas, e mensagens processadas.

2. Filas (Queues)

- Navegue até a aba **Queues** para ver uma lista de filas criadas no RabbitMQ.
- Para criar uma nova fila:
  a. Clique em **Add a new queue**.
  b. Preencha os seguintes campos:
     - **Name**: Nome da fila.
     - **Durability**: Selecione se a fila deve ser persistida em disco ou em memória.
     - **Auto Delete**: Define se a fila deve ser excluída automaticamente quando não houver consumidores.
     - **Arguments**: Defina argumentos adicionais, como TTL (tempo de vida da mensagem).
  c. Clique em **Add Queue** para criar a fila.
- Depois de criada, clique no nome da fila para visualizar seus detalhes (número de mensagens e consumidores).

### 3. Exchanges

- Exchanges são responsáveis por rotear mensagens para as filas.
- Para criar um novo exchange:
  a. Navegue até a aba **Exchanges** e clique em **Add a new exchange**.
  b. Preencha os seguintes campos:
     - **Name**: Nome do exchange.
     - **Type**: Selecione o tipo de exchange (direct, topic, fanout, etc.).
     - **Durability**: Se o exchange será persistido ou não.
  c. Clique em **Add Exchange** para criá-lo.

4. Publicação de Mensagens

- Para enviar uma mensagem para uma fila:
  a. Vá até a aba **Queues** e selecione a fila para a qual deseja publicar a mensagem.
  b. Na parte inferior da página, na seção **Publish message**, insira o conteúdo da mensagem e clique em **Publish message**.

5. Consumo de Mensagens

- Você pode consumir mensagens de uma fila manualmente pela UI ou através de consumidores configurados no sistema. Para monitorar o consumo, veja o contador de mensagens na fila.

6. Monitoramento

- Use a aba **Connections** para ver as conexões ativas e **Channels** para monitorar os canais de comunicação entre produtores e consumidores.

7. Exemplo de Teste

a. Crie uma fila chamada `minha_fila`.
b. Publique uma mensagem simples na fila com o corpo: `"Olá, RabbitMQ!"`.
c. Verifique se a mensagem foi adicionada à fila e se há consumidores ativos.
