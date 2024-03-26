from flask import Flask
import redis

app = Flask(__name__)
db = redis.Redis(host='redis', port=6379)

# make redis
#redis_cache = redis.Redis(host='localhost', port=6379, db=0, password="redis_password")

@app.route('/')
def hello():
    count = db.incr('hits')
    return 'Hello World! I have been seen {} times.\n'.format(count)

@app.route('/sem-redis')
def hellow():
    #count = db.incr('hits')
    return 'Hello World! I have been seen times.'

@app.route('/set/<string:key>/<string:value>')
def set(key, value):
    if db.exists(key):
        pass
    else:
        db.set(key, value)
    return "OK"

@app.route('/get/<string:key>')
def get(key):
    if db.exists(key):
        return db.get(key)
    else:
        return f"{key} is not exists"

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
