FROM centos:centos6
MAINTAINER yukotan yukotan@gmail.com

# CentOS Official Image fix

# root directory is /
ADD root/.bash_profile /root/
ADD root/.bashrc /root/
RUN ln -s /root/.bash_profile /.bash_profile
RUN ln -s /root/.bashrc /.bashrc
# utf8 -> C
RUN echo 'LANG="C"' > etc/sysconfig/i18n
# http://blog.earth-works.com/2014/02/10/fixing-lc-locale-issues-in-centos-and-rhel/

# fix end -->

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.org
ADD CentOS-Base.repo /etc/yum.repos.d/

RUN yum clean all
RUN yum -y update
RUN yum -y install openssh-server sudo

RUN useradd nginx
# initial password
RUN echo 'nginx:pass' | chpasswd
RUN echo 'nginx ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# RUN mkdir -p /home/nginx/.ssh
# ADD authorized_keys /home/nginx/.ssh/
# RUN chown -R nginx:nginx /home/nginx/.ssh; chmod 700 /home/nginx/.ssh

ADD nginx/.bash_profile /home/nginx/
ADD nginx/.bashrc /home/nginx/
# RUN chown -R nginx:nginx /home/nginx/

# アプリケーション

RUN yum -y install sysstat telnet wget ngrep dstat bind-utils mlocate which
RUN yum -y install wget curl telnet mail tar
RUN yum -y install git

# yum repos
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN sed -e "s/enabled=0/enabled=1/g" /etc/yum.repos.d/remi.repo

# mysql server
RUN yum -y install http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
RUN yum -y install mysql-community-server.x86_64 mysql-community-devel.x86_64 mysql-community-client.x86_64

# memcached
RUN yum -y install libevent libevent-devel
RUN yum -y --enablerepo=remi install memcached.x86_64 memcached-devel.x86_64

# nginx
RUN useradd nginx
RUN echo 'nginx ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN yum -y list nginx --disablerepo=* --enablerepo=nginx
RUN yum -y install nginx --disablerepo=* --enablerepo=nginx

# php

# make log directory
RUN mkdir /var/log/php/ && chmod 777 /var/log/php/

RUN yum -y install libmcrypt libmcrypt-devel libxml2 libxml2-devel curl-devel gcc gcc++
RUN yum -y install --enablerepo=remi php.x86_64 php-mbstring.x86_64 php-fpm.x86_64 php-mcrypt.x86_64
RUN yum -y install php-phpunit-PHPUnit.noarch
RUN sed -e "s/apache/nginx/g" /etc/php-fpm.d/www.conf
RUN yum -y install --enablerepo=remi php-mysqlnd.x86_64
RUN yum -y install --enablerepo=remi php-pecl-memcached.x86_64
RUN yum -y install --enablerepo=remi php-pdo.x86_64
RUN yum -y install --enablerepo=remi php-pecl-apc.x86_64 php-pecl-apc-devel.x86_64
RUN yum -y install --enablerepo=remi php-gd
RUN cp -p /etc/php.ini /etc/php.ini.org && \
    sed \
    -e "s/^;error_log = php_errors.log/error_log = \/var\/log\/php\/php_errors.log/" \
    -e "s/^;date.timezone =/date.timezone = Asia\/Tokyo/" \
   /etc/php.ini
RUN cp -p /etc/php.d/apc.ini /etc/php.d/apc.ini.org && \
    sed \
    -e "s/^;apc.enabled=1/apc.enabled=1/" \
    /etc/php.d/apc.ini

# geo ip
RUN yum -y install GeoIP.x86_64 GeoIP-devel.x86_64
RUN mkdir -p /usr/local/src/pecl && \
    cd /usr/local/src/pecl && \
    wget "http://pecl.php.net/get/geoip-1.0.8.tgz" && \
    tar zxvf geoip-1.0.8.tgz && \
    cd geoip-1.0.8 && \
    phpize && ./configure && \
    make && \
    make install

# set init.sh
ADD init.sh /
RUN chmod 755 /init.sh && chmod 755 /start.sh

# ToDo 共有ディレクトリ

# ポート
EXPOSE 22 8080 3306
