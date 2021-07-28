#!/bin/bash
#
# Autor: Trescloud Cia. Ltda., Patricio Rangles
# 
# Fecha: 27-07-2021
#
# Obtiene la compilacion del archivo wkhtmltopdf-0.12.1 para arquietectura ARM64.
# Debe ejecutarse en un servidor de arquitectura ARM64
# 

docker build -t wkhtmltopdf-0.12.1:latest .
docker run --name wkhtmltopdf-0.12.1 -d -t wkhtmltopdf-0.12.1:latest
docker cp wkhtmltopdf-0.12.1:/root/wkhtmltopdf/wkhtmltopdf-0.12.1-qt-trescloud.com-arm64* $HOME/
docker stop wkhtmltopdf-0.12.1
docker rm wkhtmltopdf-0.12.1