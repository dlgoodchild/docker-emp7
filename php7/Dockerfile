FROM ubuntu:14.04.3

ARG github_auth=""
ARG github_php_version="php-7.1.0RC1"
ARG github_xdebug_version="master"
#tags/XDEBUG_2_4_1, but doesn't work for php-7.1

# Some validation requiring a github authentication key. Github sometimes throttles non-auth'd access and can cause
# issues with multiple builds. Add a readonly authentication key as this isn't a secure channel.
RUN echo "Using github authentication key '$github_auth'"
RUN if [ -z "$github_auth" ]; then echo "Empty authentication key"; exit 1; else echo "Authentication key provided"; exit 0; fi

USER root

# Setup all the directories we're going to need:
RUN mkdir -p /usr/local/bison
RUN mkdir -p /usr/local/php
RUN mkdir -p /etc/php.d

# Install basic requirements and tools
RUN apt-get update && apt-get install -y \
	curl \
	git \
	memcached \
	snmp \
	vim \
	wget

RUN apt-get update && apt-get install -y \
	build-essential

RUN apt-get build-dep -y php5

RUN apt-get update && apt-get install -y \
	libfcgi-dev \
	libfcgi0ldbl \
	libjpeg62-dbg \
	libmcrypt-dev \
	libssl-dev \
	libc-client2007e \
	libc-client2007e-dev

# Install bison for compiling PHP >= 5.4
WORKDIR /usr/local/bison
RUN wget http://ftp.gnu.org/gnu/bison/bison-2.6.4.tar.gz && tar --strip-components=1 -xvzf bison-2.6.4.tar.gz

RUN ./configure \
	&& make \
	&& make install \
	&& ln -s /usr/lib/libc-client.a /usr/lib/x86_64-linux-gnu/libc-client.a

WORKDIR /usr/local/php

# Clone the version of PHP we want
RUN git clone --branch ${github_php_version} https://${github_auth}:x-oauth-basic@github.com/php/php-src.git /usr/local/php

# PHP Compile options
RUN ./buildconf --force
RUN ./configure --prefix=/usr/local/php --with-config-file-scan-dir=/etc/php.d \
	--disable-rpath \
	--enable-bcmath \
	--enable-calendar \
	--enable-exif \
	--enable-fpm \
	--enable-ftp \
	--enable-gd-native-ttf \
	--enable-inline-optimization \
	--enable-mbregex \
	--enable-mbstring \
	--enable-opcache \
	--enable-pcntl \
	--enable-phpdbg \
	--enable-soap \
	--enable-sockets \
	--enable-sysvsem \
	--enable-sysvshm \
	--enable-zip \
	--with-bz2 \
	--with-curl \
	--with-fpm-user=www-data \
	--with-fpm-group=www-data \
	--with-freetype-dir \
	--with-gd \
	--with-gettext \
	--with-iconv \
	--with-imap \
	--with-imap-ssl \
	--with-jpeg-dir=/usr \
	--with-kerberos \
	--with-libdir=/lib/x86_64-linux-gnu \
	--with-libxml-dir=/usr \
	--with-mcrypt \
	--with-mhash \
	--with-mysql \
	--with-mysqli \
	--with-openssl \
	--with-pcre-regex \
	--with-pdo-mysql \
	--with-pdo-pgsql \
	--with-pear \
	--with-pgsql \
	--with-png-dir=/usr \
	--with-snmp \
	--with-xmlrpc \
	--with-xsl \
	--with-zlib \
	--with-zlib-dir

# Other options and variations:
# --with-zlib-dir=/usr \
# --with-xpm-dir=/usr \
# --with-freetype-dir=/usr \
# --enable-gd-jis-conv \ ; reports to cause issues with accented chars
# --with-recode=/usr \
# --with-mysqli=/usr/bin/mysql_config
# --with-t1lib=/usr \
# --with-gmp \
# --with-pspell \

RUN make && make install

# Create the php.ini
RUN cp php.ini-production /usr/local/php/php.ini
RUN ln -s /usr/local/php/php.ini /etc/php.ini

# A little php.ini tweaking
RUN sed -i -e 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /usr/local/php/php.ini
RUN sed -i -e 's/^output_buffering\s*=\s*[0-9]\+/output_buffering=0/' /usr/local/php/php.ini
RUN sed -i -e 's/^error_reporting\s*=\s*.\+/error_reporting=E_ALL/' /usr/local/php/php.ini

# Setup the php-fpm.conf
RUN cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
RUN sed -i -e 's/;daemonize = yes/daemonize = no/' /usr/local/php/etc/php-fpm.conf
RUN sed -i -e 's/listen = .*/listen = 9000/' /usr/local/php/etc/php-fpm.conf

# Setup the pool files (in /usr/local/php/etc/php-fpm.d/)
RUN cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf
RUN sed -i -e 's/listen = .*/listen = 9000/' /usr/local/php/etc/php-fpm.d/www.conf

# Setup an init script (actual script needs updated)
COPY ./scripts/php-fpm.init /usr/local/php/php-fpm.init
RUN cp /usr/local/php/php-fpm.init /etc/init.d/php-fpm \
	&& chmod +x /etc/init.d/php-fpm \
	&& update-rc.d php-fpm defaults

# Install wkhtmltopdf library
WORKDIR /root
RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
RUN apt-get update && apt-get install -y \
	fontconfig \
	libxrender1 \
	xfonts-base \
	xfonts-75dpi
RUN dpkg -i wkhtmltox-0.12.2.1_linux-trusty-amd64.deb

# Install xdebug extension (PHP7)
RUN mkdir -p /root/xdebug-src
WORKDIR /root/xdebug-src
RUN git clone --branch ${github_xdebug_version} https://${github_auth}:x-oauth-basic@github.com/xdebug/xdebug.git . \
	&& /usr/local/php/bin/phpize \
	&& ./configure --enable-xdebug --with-php-config="/usr/local/php/bin/php-config" \
	&& make \
	&& make install

# Install ImageMagick
RUN apt-get update && apt-get install -y \
	imagemagick \
	libmagickwand-dev \
	libmagickcore-dev

# Install IMagick extension (PHP 7)
RUN mkdir -p /root/imagick-src
WORKDIR /root/imagick-src
RUN git clone https://${github_auth}:x-oauth-basic@github.com/mkoppanen/imagick.git . \
	&& /usr/local/php/bin/phpize \
	&& ./configure --with-php-config="/usr/local/php/bin/php-config" \
	&& make \
	&& make install
	&& cp /root/imagick-src/modules/imagick.so /usr/local/php/lib/php/extensions/no-debug-non-zts-20160303/

COPY ./php.d/imagick.ini /etc/php.d/imagick.ini
COPY ./php.d/uploads.ini /etc/php.d/uploads.ini
COPY ./php.d/xdebug.ini /etc/php.d/xdebug.ini

ENV PATH "$PATH:/usr/local/php/bin:/usr/local/php/sbin"
RUN echo "export PATH=\$PATH:/usr/local/php/bin:/usr/local/php/sbin" >> ~/.bashrc
RUN echo $PATH

RUN mkdir -p /root/sass
WORKDIR /root/sass
RUN git clone https://${github_auth}:x-oauth-basic@github.com/sass/libsass.git \
	&& git clone https://${github_auth}:x-oauth-basic@github.com/sass/sassc.git
ENV SASS_LIBSASS_PATH /root/sass/libsass
WORKDIR /root/sass/sassc
RUN make

RUN mkdir -p /root/composer-src
WORKDIR /root/composer-src
COPY ./scripts/install-composer.sh ./install-composer.sh
RUN sh ./install-composer.sh && cp ./composer.phar /usr/local/bin/composer

# Fix permissions for OSX
# <OSX-ONLY>
#	RUN usermod -u 1000 www-data
# </OSX-ONLY>

WORKDIR /root

CMD ["/etc/init.d/php-fpm", "start"]