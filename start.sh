#!/bin/bash
set -e

# 1. Arranco PHP-FPM (Ubuntu 22.04 usa php8.1-fpm)
service php8.1-fpm start

# 2. Arranco Tomcat9 usando catalina.sh en background
/usr/share/tomcat9/bin/catalina.sh run &

# 3. Arranco NGINX en primer plano
nginx -g "daemon off;"

