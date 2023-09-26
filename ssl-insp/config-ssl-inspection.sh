#!/bin/bash

# Este script obtém o certificado digital utilizado na execução de SSL-Inspection
# a partir de redes tipicamente corporativas. Pode ser útil para viabilizar o acesso
# à Internet em modo Bridge, caso deseje implementar o ambiente de laboratório com 
# este modo de configuração. 

# Nome do certificado
CERT_NAME="firewall_certificate.crt"

# Verificar se o openssl está instalado. Se não, instalá-lo.
if ! command -v openssl &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y openssl
fi

# Baixar o certificado do site
echo -n | openssl s_client -connect www.globo.com:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $CERT_NAME

# Copiar o certificado para o diretório de certificados do sistema
sudo cp $CERT_NAME /usr/local/share/ca-certificates/

# Atualizar os certificados confiáveis do sistema
sudo update-ca-certificates

echo "Certificado baixado e adicionado com sucesso!"