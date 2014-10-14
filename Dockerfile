FROM ubuntu:trusty

# Install packages
RUN apt-get update
Run DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libapache2-mod-php5
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-gd
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php-apc
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pwgen
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install imagemagick

# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Remove pre-installed application 
RUN rm -fr /var/www/html

# Add phpBB
ADD phpBB3 /var/www/phpBB3

# Add MySQL utils
ADD initialize_mysql.sh /initialize_mysql.sh
RUN chmod 755 /*.sh

# Config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Environment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

# Add volumes for MySQL and the application
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/var/www/phpBB3" ]

EXPOSE 80 3306
CMD ["/run.sh"]

