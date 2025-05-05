from flask import Flask, request, jsonify
from celery_redis import soma_redis
from celery_rabbit import soma_rabbit

app = Flask(__name__)

@app.route('/soma_redis', methods=['POST'])
def somar_redis():
    dados = request.json
    x = dados.get('x')
    y = dados.get('y')
    task = soma_redis.delay(x, y)
    return jsonify({"task_id": task.id}), 202

@app.route('/soma_rabbit', methods=['POST'])
def somar_rabbit():
    dados = request.json
    x = dados.get('x')
    y = dados.get('y')
    task = soma_rabbit.delay(x, y)
    return jsonify({"task_id": task.id}), 202

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)