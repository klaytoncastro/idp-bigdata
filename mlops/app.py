import os
from flask import Flask, request, jsonify
from joblib import load

app = Flask(__name__)

# Obter o caminho completo para o arquivo modelo.pkl na pasta models
modelo_path = os.path.join('models', 'modelo.pkl')

# Carregar o modelo
modelo = load(modelo_path)

# Dados fictícios de exemplo
exemplo = {
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
}

@app.route('/test', methods=['GET'])
def test():
    # Fazer uma previsão de exemplo
    previsao = modelo.predict([list(exemplo.values())])
    return jsonify(previsao.tolist())

# Definir rota para receber requisições POST
@app.route('/predict', methods=['POST'])
def predict():
    # Receber dados JSON da requisição
    data = request.get_json()

    # Extrair os valores do JSON
    fixed_acidity = data['fixed acidity']
    volatile_acidity = data['volatile acidity']
    citric_acid = data['citric acid']
    residual_sugar = data['residual sugar']
    chlorides = data['chlorides']
    free_sulfur_dioxide = data['free sulfur dioxide']
    total_sulfur_dioxide = data['total sulfur dioxide']
    density = data['density']
    pH = data['pH']
    sulphates = data['sulphates']
    alcohol = data['alcohol']
    color = data['color']

    # Fazer a previsão usando o modelo
    predicao = modelo.predict([[fixed_acidity, volatile_acidity, citric_acid, residual_sugar, chlorides,free_sulfur_dioxide, total_sulfur_dioxide, density, pH, sulphates, alcohol, color]])

    # Mapear o resultado da previsão para uma resposta legível
    resultado = ['Vinho Ruim' if pred == 1 else 'Vinho Bom' for pred in predicao]

    # Retornar o resultado como JSON
    return jsonify(resultado)

# Executar o aplicativo Flask
if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)