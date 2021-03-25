FROM php:7.2-apache
MAINTAINER Lyu DongHui <lixiaolang87@qq.com>

# add helper script
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# install extra packages
RUN apt-get update \
	&& apt-get install -y \
		graphviz \
		mariadb-client \
		unzip \
	&& chmod uga+x /usr/local/bin/install-php-extensions \
	&& install-php-extensions \
		gd \
		ldap \
		mcrypt \
		mysqli \
		soap \
		zip

VOLUME /var/www/html

EXPOSE 80

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1
