FROM ubuntu:16.04

# dependencias requeridas para compilar
RUN apt-get update && apt-get install -y wget \
    openssl \
    build-essential \
    libssl-dev \
    libxrender-dev \
    git-core \
    libx11-dev \
    libxext-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    fontconfig 

WORKDIR /root
# Descargamos el codigo de la version 0.12.1
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/archive/refs/tags/0.12.1.tar.gz && \
    tar -xvf 0.12.1.tar.gz && \
    mv wkhtmltopdf-0.12.1 wkhtmltopdf && \
    cd wkhtmltopdf

# Archivos de configuracion faltantes en el codigo
COPY files/static_qt_conf_base wkhtmltopdf/static_qt_conf_base
COPY files/static_qt_conf_linux wkhtmltopdf/static_qt_conf_linux

# Descargamos el QT para esta version
RUN mkdir qt-wkhtmltopdf && cd qt-wkhtmltopdf \
    git clone https://www.github.com/wkhtmltopdf/qt --depth 1 --branch wk_4.8.7 --single-branch .

# Construimos QT segun lo lo requiere wkhtmltopdf
WORKDIR /root/qt-wkhtmltopdf
RUN ./configure -nomake tools,examples,demos,docs,translations -opensource -prefix "`pwd`" `cat ../wkhtmltopdf/static_qt_conf_base ../wkhtmltopdf/static_qt_conf_linux | sed -re '/^#/ d' | tr '\n' ' '`
RUN make -j8
RUN make install

# Compilamos wkhtmltopdf con el QT
WORKDIR /root/wkhtmltopdf
RUN ../qt-wkhtmltopdf/bin/qmake
RUN make -j8
RUN make install
