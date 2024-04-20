# Como colocar seu primeiro modelo de Machine Learning em produção usando Flask

## 1. Introdução

Como vimos em sala de aula, o Flask é um microframework Python para desenvolvimento ágil de aplicativos web, adequado tanto para iniciantes quanto para desenvolvedores mais experientes. Ele é bastante leve e extensível, permitindo expandir facilmente seu aplicativo para operar com bibliotecas mais avançadas, aproveitando todo o poder da linguagem Python e a flexibilidade da web. 

Ou seja, Flask permite que você comece pequeno, escolhendo apenas as peças necessárias, e cresça à medida que seu projeto se desenvolve. Neste tutorial, você criará uma API simples para executar seu modelo de Machine Learning, aprenderá sobre roteamento de aplicativos web, interação através de rotas de conteúdo estático e dinâmico, além de utilizar o depurador para corrigir eventuais erros.

## 2. Exportação do Modelo para Produção

Uma etapa crucial na implementação de um modelo de Machine Learning em produção é a exportação do modelo treinado para um formato que possa ser facilmente carregado e utilizado por aplicações. Geralmente optamos pelo uso do formato `pickle` para realizar essa tarefa. O formato `pickle` oferece uma maneira padrão para serializar objetos em Python. Isso significa que ele pode transformar qualquer objeto Python, incluindo modelos complexos de Machine Learning, em uma sequência de bytes que pode ser salva em um arquivo.

### Por Que Usar o Formato Pickle?

O principal benefício de utilizar o formato `pickle` para exportar modelos de Machine Learning é a sua eficiência e simplicidade em armazenar e recuperar os modelos treinados. Em um cenário de produção, o tempo necessário para treinar um modelo pode ser proibitivo, especialmente com grandes volumes de dados ou algoritmos complexos que requerem alto poder computacional. Assim, treinar o modelo a cada nova requisição de previsão torna-se inviável.

Exportar o modelo treinado como um arquivo `pickle` permite que o modelo seja carregado rapidamente por nossa aplicação Flask, sem a necessidade de reprocessar os dados ou retreinar o modelo. Isso é essencial para garantir a agilidade das respostas em um ambiente de produção, onde a performance e o tempo de resposta são críticos.

### Como Exportar e Carregar um Modelo com Pickle
Exportar um modelo para um arquivo pickle é um processo simples. Primeiro, o modelo é treinado. Após o treinamento, o modelo é serializado com o módulo `pickle` e salvo em um arquivo `.pkl`. O código a seguir exemplifica este processo:

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

Acesse o ambiente via SSH e vá até o diretório `/opt/idp-machinelearning/production`. Crie o arquivo `app.py` com o Vim (use o comando `vim app.py`) ou editor de sua preferência para dar manutenção ao código. 

### Executando o aplicativo 

Vá até o diretório `/opt/idp-machinelearning/production` e suba o contêiner do Flask. 

```bash
docker-compose build
docker-compose up -d
```

Verifique se o contêiner está ativo e sem erros de implantação. 

```bash
docker-compose ps
docker-compose logs
```
Agora, acesse `http://127.0.0.1:8500/example` e verifique o retorno do `.json` de exemplo. 

## 4. Roteamento e visualizações

Roteamento refere-se ao mapeamento de URLs específicas para funções em um aplicativo web. Em outras palavras, quando você acessa um determinado endereço em um navegador web (ou através de uma chamada API), o aplicativo precisa saber qual função deve ser executada e o que deve ser retornado para o usuário. No Flask, isso é feito através do uso de decoradores, como `@app.route()`, para associar funções específicas a URLs. Por exemplo:

```python
@app.route('/inicio')
def inicio():
    return "Página Inicial"
```

Dessa forma, você poderá acessar os *end-points* `http://127.0.0.1:8500/<nome_end-point>` e verá as respectivas páginas em seu navegador. 

## 5. Rotas Dinâmicas

Vamos permitir que os usuários interajam com o aplicativo por meio de rotas dinâmicas. Podemos submeter via método `HTTP POST` um `.json` com as variáveis preditoras e o nosos aplicativo retornará a previsão da variável alvo. Abaixo, exemplo de um vinho de qualidade "ruim": 

```shell
 curl -X POST   -H "Content-Type: application/json"   -d '{
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
      }'   http://localhost:8500/predict
```

- Abaixo, exemplo de código para um vinho de qualidade "boa": 

```shell
 curl -X POST   -H "Content-Type: application/json"   -d '{
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
      }'   http://localhost:8500/predict
```

- Você também pode utilizar um arquivo para fazer `POST` do arquivo `.json`. Seguem exemplos: 

```shell
curl -X POST -H "Content-Type: application/json" -d @bom.json http://localhost:8500/predict
```

```shell
curl -X POST -H "Content-Type: application/json" -d @ruim.json http://localhost:8500/predict
```

## 6. Depurando seu aplicativo

O Flask possui um depurador embutido. No nosso ambiente, quando você executa o comando `docker-compose logs`, poderá verificar quais são os eventuais erros e assim corrigir o código de seu aplicativo. 

### Pronto! 

Você criou um pequeno aplicativo web com o Flask, adicionou rotas estáticas e dinâmicas e aprendeu a usar o depurador. A partir daqui, você pode expandir seu aplicativo, integrando-o com bancos de dados, formulários e aprimorando seu visual com CSS e HTML. A exportação de modelos em formato pickle é uma prática eficiente para a implantação de modelos de Machine Learning em produção, oferecendo uma forma rápida de disponibilizar as capacidades preditivas do modelo com a eficiência necessária para aplicações em tempo real.