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

#############################################################
# Primera forma de compilar, usando el codigo completo de esa version
#

# Descargamos el codigo de la version 0.12.1
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/archive/refs/tags/0.12.1.tar.gz && \
    tar -xvf 0.12.1.tar.gz && \
    mv wkhtmltopdf-0.12.1 wkhtmltopdf

# Descargamos el QT para esta version
RUN mkdir qt-wkhtmltopdf && cd qt-wkhtmltopdf && \
    git clone https://www.github.com/wkhtmltopdf/qt --depth 1 --branch wk_4.8.7 --single-branch .

# Archivos de configuracion faltantes en el codigo
COPY files/static_qt_conf_base wkhtmltopdf/static_qt_conf_base
COPY files/static_qt_conf_linux wkhtmltopdf/static_qt_conf_linux

# Construimos QT segun lo requiere wkhtmltopdf
WORKDIR /root/qt-wkhtmltopdf
# RUN ./configure -confirm-license -nomake tools,examples,demos,docs,translations -opensource -prefix "`pwd`" `cat ../wkhtmltopdf/static_qt_conf_base ../wkhtmltopdf/static_qt_conf_linux | sed -re '/^#/ d' | tr '\n' ' '`
RUN ./configure -confirm-license -nomake tools,examples,demos,docs,translations -opensource -prefix "../wkqt" -release -static
# opcion retirada
# -no-openssl
RUN make -j8
RUN make install

# Compilamos wkhtmltopdf con el QT
WORKDIR /root/wkhtmltopdf
RUN ../qt-wkhtmltopdf/bin/qmake
RUN make -j8
RUN make install

# #############################################################
# # Otra forma de compilar, usando el codigo completo de esa version
# # https://github.com/wkhtmltopdf/qt/tree/82b568bd2e1dfb76208128e682fe0ade392e48d4

# # instalar XORG no ayuda a resolver los problemas
# #RUN apt-get install -y xorg

# # Descargamos wkhtmltopdf y QT incluido
# RUN git clone --recursive https://github.com/wkhtmltopdf/wkhtmltopdf.git
# WORKDIR /root/wkhtmltopdf
# RUN git checkout 2b560d5e4302b5524e47aa61d10c10f63af0801c

# # Archivos de configuracion faltantes en el codigo
# # No es necesario
# COPY files/static_qt_conf_base wkhtmltopdf/static_qt_conf_base
# COPY files/static_qt_conf_linux wkhtmltopdf/static_qt_conf_linux

# # Construimos QT segun lo requiere wkhtmltopdf
# WORKDIR /root/wkhtmltopdf/qt
# #RUN ./configure -confirm-license -nomake tools,examples,demos,docs,translations -opensource -prefix "`pwd`" `cat ../wkhtmltopdf/static_qt_conf_base ../wkhtmltopdf/static_qt_conf_linux | sed -re '/^#/ d' | tr '\n' ' '`
# RUN ./configure -confirm-license -nomake tools,examples,demos,docs,translations -opensource -prefix "../wkqt" -release -static -no-openssl

# RUN make -j8
# RUN make install

# ## Headers para X11 (No funciona)
# #RUN apt-get install -y libx11-dev
# #RUN apt-get install -y xorg

# # Compilamos wkhtmltopdf con el QT
# WORKDIR /root/wkhtmltopdf
# RUN ../wkhtmltopdf/qt/bin/qmake
# RUN make -j8
# RUN make install

################################################################
# Empaquetado Final

# Creacion del paquete .deb
RUN apt-get install -y checkinstall build-essential automake autoconf libtool pkg-config libcurl4-openssl-dev intltool libxml2-dev libgtk2.0-dev libnotify-dev libglib2.0-dev libevent-dev
RUN checkinstall --default \
    --pkgname wkhtmltopdf-0.12.1-qt-trescloud.com-arm64 \
    --maintainer "info@trescloud.com"
RUN mv wkhtmltopdf-0.12.1-qt-trescloud.com-arm64* wkhtmltopdf-0.12.1-qt-trescloud.com-arm64.deb

