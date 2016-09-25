FROM ubuntu:14.04.3

ENV ROOTPASS R4nd0m_Initi4L_pa554_Ro07
ENV DOCKER_USER_ID 501
ENV DOCKER_USER_GID 20
ENV BOOT2DOCKER_ID 1000
ENV BOOT2DOCKER_GID 50

ENV DEBIAN_FRONTEND noninteractive

RUN echo "mysql-server mysql-server/root_password select ${ROOTPASS}" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again select ${ROOTPASS}" | debconf-set-selections

# Tweaks to give MySQL write permissions to the app
RUN useradd -r mysql -u ${BOOT2DOCKER_ID} && \
	usermod -G staff mysql
RUN groupmod -g $(($BOOT2DOCKER_GID + 10000)) $(getent group $BOOT2DOCKER_GID | cut -d: -f1)
RUN groupmod -g ${BOOT2DOCKER_GID} staff

RUN apt-get update && apt-get install -y \
	git \
	mysql-server-5.5 \
	vim \
	wget \
	supervisor \
	pwgen \
	zip \
	unzip

ADD ./mysql_create_users.sh /mysql_create_users.sh
ADD ./mysql_start.sh /mysql_start.sh
ADD ./mysql_run.sh /mysql_run.sh
RUN chmod 755 /*.sh
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Update my.cnf
RUN sed -i -e"s#^user\s*=\s*mysql#user = mysql#" /etc/mysql/my.cnf
RUN sed -i -e"s#^bind-address\s*=\s*127.0.0.1#bind-address = 0.0.0.0#" /etc/mysql/my.cnf

# Remove pre-installed database
# RUN rm -rf /var/lib/mysql

ENV MYSQL_PASS:-$(pwgen -s 12 1)

VOLUME ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 3306
CMD ["/mysql_run.sh"]