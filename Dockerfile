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

# Add default configuration
COPY php.ini /usr/local/etc/php/php.ini

# install itop if volume is empty
ENV ITOP_VERSION=2.7.3
ENV ITOP_FILENAME=iTop-2.7.3-6624.zip
RUN if [ "`ls -A /var/www/html`" = "" ]; \
    then \
        mkdir -p /tmp/itop \
        && curl -SL -o /tmp/itop/itop.zip https://sourceforge.net/projects/itop/files/itop/$ITOP_VERSION/$ITOP_FILENAME \
	&& unzip /tmp/itop.zip -d /tmp/itop/ \
	&& mv /tmp/itop/web/* /var/www/html \
	&& rm -rf /tmp/itop \
    fi

EXPOSE 80
