FROM httpd:2.2.29

# system update
RUN apt-get -y update && apt-get -y upgrade

# locale
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# timezone (Asia/Tokyo)
ENV TZ JST-9

# etc
ENV TERM xterm

# tools
RUN apt-get -y install less vim git

# apache setting
RUN mkdir /var/www/ && chmod 705 /var/www/ && \
    mkdir -p /usr/local/apache2/conf.d/virtualhost/ && \
    { \
      echo ''; \
      echo 'DirectoryIndex index.php index.html'; \
      echo '<FilesMatch \.php$>'; \
      echo '    SetHandler "proxy:fcgi://php:9000"'; \
      echo '</FilesMatch>'; \
      echo ''; \
      echo '# Default Virtualhost Configuration'; \
      echo '<VirtualHost *:80>'; \
      echo '  DocumentRoot /usr/local/apache2/htdocs/'; \
      echo '  ServerName 127.0.0.1'; \
      echo '  <Directory "/usr/local/apache2/htdocs/">'; \
      echo '    DirectoryIndex index.html'; \
      echo '    Options FollowSymLinks'; \
      echo '    AllowOverride None'; \
      echo '    Order allow,deny'; \
      echo '    Allow from all'; \
      echo '  </Directory>'; \
      echo '</VirtualHost>'; \
      echo ''; \
      echo '# SSL'; \
      echo 'Include conf/extra/httpd-ssl.conf'; \
      echo ''; \
      echo '# Virtualhost Configuration'; \
      echo '# Load config files in the "/usr/local/apache2/conf.d/virtualhost/" directory, if any.'; \
      echo 'Include conf.d/virtualhost/*.conf'; \
    } >> /usr/local/apache2/conf/httpd.conf

COPY ./server.key /usr/local/apache2/conf/server.key
COPY ./server.crt /usr/local/apache2/conf/server.crt
RUN sed -i -e "s/www.example.com/127.0.0.1/g" /usr/local/apache2/conf/extra/httpd-ssl.conf

# Enabling module rewrite.
# RUN a2enmod rewrite

# user setting
WORKDIR /usr/local/apache2/
RUN usermod -u 500 www-data \
    && groupmod -g 500 www-data
