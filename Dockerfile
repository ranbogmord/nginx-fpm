FROM ubuntu:16.04
MAINTAINER John Eriksson <root@ranbogmord.com>

RUN apt-get update -y && apt-get install -y nginx php-fpm php-mysql php-gd php-intl php-soap wget php-xml php-curl php-mbstring
RUN service nginx stop
RUN sed -i 's#/run/php/php7.0-fpm.sock#9000#' /etc/php/7.0/fpm/pool.d/www.conf
RUN service php7.0-fpm start
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN mkdir -p /code

ADD ./nginx.conf /etc/nginx/sites-enabled/default
ADD ./docker-entrypoint.sh /docker-entrypoint.sh
WORKDIR /code

CMD ["bash", "/docker-entrypoint.sh"]

