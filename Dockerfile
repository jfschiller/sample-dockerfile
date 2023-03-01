FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

#install all the system dependencies and enable PHP modules
RUN apt-get update
RUN apt -y install software-properties-common
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get install -yq --force-yes \
      php7.4\
      libapache2-mod-php\
      php7.4-common\
      php7.4-zip \
      php7.4-curl \
      php7.4-xml \
      php7.4-xmlrpc \
      php7.4-json \
      php7.4-mysql \
      php7.4-pdo \
      php7.4-gd \
      php7.4-imagick \
      php7.4-ldap \
      php7.4-imap \
      php7.4-mbstring \
      php7.4-intl \
      php7.4-cli \
      php7.4-tidy \
      php7.4-bcmath \
      php7.4-opcache \
      php7.4-sqlite3 \
      php7.4-soap \
      wkhtmltopdf \
      curl \
      tree \
      ufw \
      gnupg \
      libicu-dev \
      libpq-dev \
      libmcrypt-dev \
      mysql-client \
      git \
      zip \
      unzip
      
      
#set our application folder as an environment variable
ENV APP_HOME /var/www/html

# COPY . $APP_HOME
# COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

RUN chmod -R 755 /var/www/html

# install all PHP dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
RUN composer install --no-interaction --ignore-platform-reqs
# RUN npm install
# RUN npm run prod

# install node
# RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
# RUN curl -fsSL https://deb.nodesource.com/setup_19.x | bash &&\
#     apt-get install -y nodejs

RUN tree -L 3 $APP_HOME

# activate php 7.3 by default
RUN update-alternatives --set php /usr/bin/php7.4
RUN a2enmod php7.4

RUN a2enmod rewrite

# change ownership of our applications
RUN chown -R www-data:www-data $APP_HOME
EXPOSE 80
CMD apachectl -D FOREGROUND
