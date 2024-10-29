# Como colocar seu primeiro modelo de Machine Learning em produção usando Flask

## 1. Introdução

Como vimos em sala de aula, o Flask é um microframework Python para desenvolvimento ágil de aplicativos web, adequado tanto para iniciantes quanto para desenvolvedores mais experientes. Ele é bastante leve e extensível, permitindo expandir facilmente seu aplicativo para operar com bibliotecas mais avançadas, aproveitando todo o poder da linguagem Python e a flexibilidade da web. 

Ou seja, Flask permite que você comece pequeno, escolhendo apenas as peças necessárias, e cresça à medida que seu projeto se desenvolve. Neste tutorial, você criará uma API simples para executar seu modelo de Machine Learning, aprenderá sobre roteamento de aplicativos web, interação básica através de rotas de conteúdo estático e dinâmico, além de utilizar o depurador para corrigir eventuais erros.

## 2. Exportação do Modelo para Produção

Uma etapa crucial na implementação de um modelo de Machine Learning em produção é a exportação do modelo treinado para um formato que possa ser facilmente carregado e utilizado por aplicações. Geralmente optamos pelo uso do formato `pickle`, que oferece uma maneira padrão para serializar objetos em Python para realizar essa tarefa. Isso significa que ele pode transformar qualquer objeto Python, incluindo modelos complexos de Machine Learning, em uma sequência de bytes que pode ser salva em um arquivo.

### Por Que Usar o Formato Pickle?

O principal benefício de utilizar o formato `pickle` para exportar modelos de Machine Learning é a sua eficiência e simplicidade em armazenar e recuperar os modelos treinados. Em um cenário de produção, o tempo necessário para treinar um modelo pode ser proibitivo, especialmente com grandes volumes de dados ou algoritmos complexos que requerem alto poder computacional. Assim, treinar o modelo a cada nova requisição de previsão torna-se inviável.

Exportar o modelo treinado como um arquivo `pickle` permite que o modelo seja carregado rapidamente por nossa aplicação Flask, sem a necessidade de reprocessar os dados ou retreinar o modelo. Isso é essencial para garantir a agilidade das respostas em um ambiente de produção, onde a performance e o tempo de resposta são críticos.

### Como Exportar e Carregar um Modelo com Pickle

Exportar um modelo para um arquivo em formato `pickle` é um processo simples. Primeiro, o modelo é treinado e validado. Após o treinamento, o modelo é serializado com o módulo `pickle` e salvo em um arquivo `.pkl`. O código a seguir exemplifica este processo:

```python
import pickle
from sklearn.ensemble import RandomForestClassifier

# Treinando o modelo
model = RandomForestClassifier()
model.fit(x_train, y_train)

# Salvando o modelo em um arquivo pickle
with open('model.pkl', 'wb') as file:
    pickle.dump(model, file)
```

Para utilizar o modelo em nossa aplicação Flask, simplesmente carregamos o arquivo pickle, deserializamos o objeto e utilizamos para fazer previsões:
```python
# Carregando o modelo do arquivo pickle
with open('model.pkl', 'rb') as file:
    loaded_model = pickle.load(file)

# Usando o modelo carregado para fazer previsões
prediction = loaded_model.predict(X_new)
```

## 3. Implantação do Ambiente

### Pré-Requisitos

Siga as instruções iniciais contidas no repositório [idp-bigdata](https://github.com/klaytoncastro/idp-bigdata/) para implantação do ambiente de laboratório, certificando-se de ter compreendido a implantação da VM com Docker que atuará como servidor web, além das ferramentas de gerenciamento, incluindo acesso remoto via SSH e editor de textos Vim, cujos fundamentos e comandos essenciais foram introduzidos em sala de aula. 

### Criando o aplicativo

Acesse o ambiente via SSH e vá até o diretório `/opt/idp-bigdata/mlops`. Verifique o código do nosso aplicativo no script `app.py` (use o comando `vim app.py`) ou o editor de sua preferência. 

### Executando o aplicativo 

Agora suba o contêiner do Flask, tornando disponível a API que irá receber os dados. 

```bash
docker-compose build
docker-compose up -d
```

Verifique se o contêiner está ativo e sem erros de implantação. 

```bash
docker-compose ps
docker-compose logs
```

## 4. Roteamento e visualizações

Roteamento refere-se ao mapeamento de URLs específicas para funções em um aplicativo web. Em outras palavras, quando você acessa um determinado endereço em um navegador web (ou através de uma chamada API), o aplicativo precisa saber qual função deve ser executada e o que deve ser retornado para o usuário. No Flask, isso é feito através do uso de decoradores, como `@app.route()`, para associar funções específicas a URLs. Por exemplo:

```python
@app.route('/inicio')
def inicio():
    return "Página Inicial"
```

Dessa forma, você poderá acessar os *end-points* `http://127.0.0.1:8500/<nome_end-point>` e verá as respectivas páginas em seu navegador. 

Agora, acesse `http://127.0.0.1:8500/test` e verifique o retorno do `.json` de exemplo. 

## 5. Rotas Dinâmicas

Vamos permitir que os usuários interajam com o aplicativo por meio de rotas dinâmicas. Podemos submeter via método `HTTP/POST` um `.json` com as variáveis preditoras e o nosos aplicativo retornará a previsão da variável alvo. Abaixo, exemplo de uma amostra de vinho: 

```shell
curl -X POST -H "Content-Type: application/json" \
-d '{
    "fixed acidity": 6.6,
    "volatile acidity": 0.16,
    "citric acid": 0.4,
    "residual sugar": 1.5,
    "chlorides": 0.044,
    "free sulfur dioxide": 48.0,
    "total sulfur dioxide": 143.0,
    "density": 0.9912,
    "pH": 3.54,
    "sulphates": 0.52,
    "alcohol": 12.4,
    "color": 1
}' \
http://localhost:8500/predict
```

- Abaixo, mais um exemplo para outra amostra: : 

```shell
curl -X POST -H "Content-Type: application/json" \
-d '{
        "fixed acidity": 7.0,
        "volatile acidity": 0.27,
        "citric acid": 0.36,
        "residual sugar": 20.7,
        "chlorides": 0.045,
        "free sulfur dioxide": 45.0,
        "total sulfur dioxide": 170.0,
        "density": 1.0010,
        "pH": 3.00,
        "sulphates": 0.45,
        "alcohol": 8.8,
        "color": 1
      }' \
http://localhost:8500/predict
```

- Você também pode utilizar um arquivo para fazer `POST` do arquivo `.json`. Vá até pasta /opt/idp-bigdata/mlops/amostras e execute os comandos abaixo: 

```shell
curl -X POST -H "Content-Type: application/json" -d @amostra01.json http://localhost:8500/predict
```

```shell
curl -X POST -H "Content-Type: application/json" -d @amostra02.json http://localhost:8500/predict
```

## 6. Depurando seu aplicativo

O Flask possui um depurador embutido. No nosso ambiente, quando você executa o comando `docker-compose logs`, poderá verificar quais são os eventuais erros e assim corrigir o código de seu aplicativo. 

### Pronto! 

Você criou um pequeno aplicativo web com o Flask, adicionou rotas estáticas e dinâmicas e aprendeu a usar o depurador. A partir daqui, você pode expandir seu aplicativo, integrando-o com bancos de dados, formulários e aprimorando seu visual com CSS e HTML. A exportação de modelos em formato `pickle` é uma prática eficiente para a implantação de modelos de Machine Learning em produção, oferecendo uma forma rápida de disponibilizar as capacidades preditivas do modelo com a eficiência necessária para aplicações em tempo real.

## 7. Tarefa

Implementem uma nova rota em nossa aplicaçãoo Flask para avaliar textos utilizando um modelo de classificação de sentimentos pré-treinado da [Hugging Face](https://huggingface.co/blog/sentiment-analysis-python). 

Vocês deverão modificar o código existente para carregar o modelo de sentimentos e criar uma rota `/analyze_sentiment` que aceite requisições `POST` com um `JSON` contendo um texto e retorne o sentimento classificado como 'positivo', 'negativo' ou 'neutro'. Utilizem o seguinte formato `JSON` para a requisição: 

```json
{ "text": "Seu texto aqui" }
```
Testem a nova funcionalidade utilizando comandos `curl` similares aos mostrados anteriormente. Abaixo, segue código exemplo para importação de uma biblioteca popular de análise de sentimentos:

```python
# Importar Biblioteca da Hugging Face
from transformers import pipeline

# Carregar o modelo de classificação de sentimentos
sentiment_model = pipeline("sentiment-analysis")

```