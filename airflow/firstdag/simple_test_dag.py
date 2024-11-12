from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime

# Função simples para imprimir uma mensagem
def print_hello():
    print("Hello, Airflow! Tudo está funcionando bem.")

# Definindo o DAG
with DAG(
    'simple_test_dag',
    start_date=datetime(2023, 11, 5),
    schedule_interval='@daily',  # Roda uma vez por dia
    catchup=False                # Evita rodar em datas passadas
) as dag:

    # Tarefa para imprimir a mensagem
    task_hello = PythonOperator(
        task_id='print_hello_task',
        python_callable=print_hello,
    )

