# 1. Construccion usando https://github.com/wkhtmltopdf/packaging

se descarga el repositorio en el servidor arm64
git clone https://github.com/wkhtmltopdf/packaging.git


git clone --recursive https://github.com/wkhtmltopdf/wkhtmltopdf.git
cd wkhtmltopdf
git checkout 2b560d5e4302b5524e47aa61d10c10f63af0801c


se modifica docker para permitir uso de "experimental" https://thenewstack.io/how-to-enable-docker-experimental-features-and-encrypt-your-login-credentials/

sudo nano /etc/docker/daemon.json

{
"experimental": true
}

sudo systemctl restart docker

Se instala las librerias requeridas

sudo apt install -y python-yaml docker.io vagrant

Se modifica el archivo build dentro de packaging, la primera linea para que use python3 
#!/usr/bin/env python3

./build --no-qemu package-docker xenial-arm64 /home/ubuntu/wkhtmltopdf

Problema:
Status: Downloaded newer image for wkhtmltopdf/fpm:1.10.2-20200531
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested


# 2. build-wkhtmltopdf, usando la logica estandar de construccion
Repositorio usado para construir la libreria wkhtmltopdf 0.12.1 para ser compatible en Ubuntu 16.04 en arquitectura ARM64

Para obtener el archivo ejecutar el script automatico que se encuentra en el raiz repositorio:

bash get_wkhtmltopdf-0.12.1-deb.sh

Requiere un servidor basado en arquitectura ARM64

Problema:
Object::connect: No such signal wkhtmltopdf::MyNetworkAccessManager::sslErrors(QNetworkReply*, const QList<QSslError>&)
Loading pages (1/6)
[======>                                                     ] 10%
De esta parte no pasa!


# 3. Uso de la libreria en una version superior

https://github.com/odoo/odoo/wiki/Wkhtmltopdf
https://github.com/odoo/odoo/pull/28864/files

Segun lo leido, se puede usar la version wkhtmltopdf 0.12.5 siempre y cuando el parche o codigo indicado en el segundo enlace este disponible
Debido a que esta version no tiene candidato para ARM64 se prueba con la version 0.12.6.1 que es la mas opcionada segun los cambios identificados

https://github.com/wkhtmltopdf/packaging/releases/0.12.6-1
https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.xenial_arm64.deb

PR requerido para funcionar en Odoo:
https://github.com/TRESCLOUD/odoo/pull/546