from celery import Celery

# Configure a instância do Celery
celery = Celery(__name__)

# Configurações do Celery
celery.conf.broker_url = 'redis://redis:6379/0'
# Adicione outras configurações do Celery conforme necessário

# Autodiscover tasks
celery.autodiscover_tasks(['modulo_celery'])
