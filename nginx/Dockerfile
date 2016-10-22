FROM ubuntu:14.04.3

# Install all requirements and minimum system tools
RUN apt-get update && apt-get install -y \
	git \
	nginx \
	vim \
	wget

RUN mv /etc/nginx/sites-enabled /etc/nginx/ignored.sites-enabled
RUN mkdir -p /etc/nginx/sites-enable
RUN mkdir -p /var/www/default/www

COPY ./sites/default.site /etc/nginx/sites-enabled/default.site

RUN sed -i -e 's/emp-php7/${project_prefix}-php7/' /etc/nginx/sites-enabled/default.site

ENV PATH /usr/local/nginx/bin:$PATH

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

# Fix permissions for OSX
# <OSX-ONLY>
#	RUN usermod -u 1000 www-data
# </OSX-ONLY>

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]