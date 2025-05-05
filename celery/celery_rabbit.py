import os
from celery import Celery

broker_url = os.getenv('CELERY_BROKER_URL', 'pyamqp://guest:guest@rabbitmq//')
celery_rabbit = Celery('celery_rabbit', broker=broker_url)

@celery_rabbit.task
def soma_rabbit(x, y):
    return x + y