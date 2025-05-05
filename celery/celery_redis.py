import os
from celery import Celery

broker_url = os.getenv('CELERY_BROKER_URL', 'redis://redis:6379/0')
celery_redis = Celery('celery_redis', broker=broker_url)

@celery_redis.task
def soma_redis(x, y):
    return x + y