# Use a imagem oficial do Python como base
FROM python:3.8-slim

# Defina o diretório de trabalho no container
WORKDIR /app

# Copie o arquivo de requisitos para o diretório de trabalho
COPY requirements.txt .

# Instale as dependências Python listadas no requirements.txt
RUN pip install --no-cache-dir --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r requirements.txt

# Exponha a porta em que o Streamlit estará em execução (padrão: 8501)
EXPOSE 8501

# Copie o arquivo app.py para o diretório de trabalho
COPY app.py .

# Comando para iniciar o aplicativo Streamlit
CMD ["streamlit", "run", "app.py"]

