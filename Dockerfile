FROM php:7.2-apache
MAINTAINER lixiaolang87 <lixiaolang87@qq.com>

# set timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

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

# get itop
ARG ITOP_VERSION=2.7.3
ARG ITOP_FILENAME=iTop-2.7.3-6624.zip
RUN mkdir -p /tmp/itop \
    && curl -SL -o /tmp/itop/$ITOP_FILENAME https://sourceforge.net/projects/itop/files/itop/$ITOP_VERSION/$ITOP_FILENAME/download \
    && unzip /tmp/itop/$ITOP_FILENAME -d /tmp/itop/

# Add default configuration
COPY php.ini /usr/local/etc/php/php.ini
COPY scripts /

EXPOSE 80

# ENTRYPOINT ["/etc/init.d/my_init"]
