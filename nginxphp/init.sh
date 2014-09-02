#/bin/bash

# jp
rm /etc/localtime
cp /usr/share/zoneinfo/Japan /etc/localtime
sed -e "s/^;date.timezone =/date.timezone = Asia\/Tokyo/" /etc/php.ini

# start services
echo 'starting services'

chkconfig sshd on
service sshd start
echo '
sshd started'

chkconfig memcached on
service memcached start
echo '
memcached started'

chkconfig php-fpm on
service php-fpm start
echo '
php-fpm started'

chkconfig nginx on
service nginx start
echo '
nginx started'

chkconfig mysqld on
service mysqld start
echo '
mysqld started'

# init mysql

/usr/bin/mysqladmin -u root password 'initpass'
echo 'mysql'\''s password is "initpass". you should change real password.'

echo '
init ended'

echo 'enter "/usr/bin/mysql_secure_installation"'
