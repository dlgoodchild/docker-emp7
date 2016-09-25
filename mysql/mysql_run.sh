#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

# Tweaks to give Apache/PHP write permissions to the app
chown -R mysql:staff /var/lib/mysql
chown -R mysql:staff /var/run/mysqld
chmod -R 770 /var/lib/mysql
chmod -R 770 /var/run/mysqld

#sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
#sed -i "s/user.*/user = mysql/" /etc/mysql/my.cnf

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"
    /mysql_create_users.sh
else
    echo "=> Using an existing volume of MySQL"
fi

exec supervisord -n