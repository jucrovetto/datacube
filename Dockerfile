# 1. Imagen base
FROM ubuntu:22.04

# 2. Metadatos
LABEL maintainer="ju.crovetto@duocuc.cl" \
      description="JCrov DataCube v1 - CI Image: NGINX, PHP-FPM, Tomcat9 y OpenJDK 24.0.1"

# 3. Evitar interactividad en apt
ENV DEBIAN_FRONTEND=noninteractive

# 4. Instalo dependencias básicas (incluye dos2unix para convertir scripts),
#    PHP-FPM, Tomcat9 y NGINX
RUN apt-get update && \
    apt-get install -y \
      wget \
      gnupg2 \
      ca-certificates \
      php-fpm \
      tomcat9 \
      tomcat9-admin \
      nginx \
      dos2unix && \
    rm -rf /var/lib/apt/lists/*

# 5. Descargo e instalo OpenJDK 24.0.1
WORKDIR /opt
RUN wget https://download.java.net/java/GA/jdk24.0.1/24a58e0e276943138bf3e963e6291ac2/9/GPL/openjdk-24.0.1_linux-x64_bin.tar.gz && \
    tar -xzf openjdk-24.0.1_linux-x64_bin.tar.gz && \
    rm openjdk-24.0.1_linux-x64_bin.tar.gz && \
    update-alternatives --install /usr/bin/java java /opt/jdk-24.0.1/bin/java 1 && \
    update-alternatives --install /usr/bin/javac javac /opt/jdk-24.0.1/bin/javac 1

# 5.1. Configuro variables de entorno para Java
ENV JAVA_HOME=/opt/jdk-24.0.1
ENV PATH="$JAVA_HOME/bin:$PATH"

# 6. Copio la configuración personalizada de NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# 7. Copio y preparo el script de arranque
COPY start.sh /start.sh
RUN dos2unix /start.sh && \
    chmod +x /start.sh

# 8. Defino el directorio de trabajo donde se montará el volumen de la web
WORKDIR /var/www/html

# 9. Expongo el puerto HTTP
EXPOSE 80

# 10. Arranco los servicios: PHP-FPM, Tomcat9 y NGINX
ENTRYPOINT ["/start.sh"]
