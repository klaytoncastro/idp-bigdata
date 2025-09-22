FROM docker.elastic.co/elasticsearch/elasticsearch:8.14.3

# Instala o processor para extrair texto/metadados de PDFs/Office via Tika

RUN elasticsearch-plugin install --batch ingest-attachment
