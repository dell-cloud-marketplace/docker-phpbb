FROM dell/lamp-base:v0.1
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-gd
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install imagemagick
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install unzip

# Add scripts.
ADD run.sh /run.sh
ADD initialize_mysql.sh /initialize_mysql.sh
RUN chmod 755 /*.sh

# Prepare phpBB (which is installed in the run.sh script).
RUN wget https://www.phpbb.com/files/release/phpBB-3.0.12.zip
RUN unzip phpBB-3.0.12.zip
RUN rm -fr /var/www/html/*

# Add volumes for MySQL and the application
VOLUME  ["/var/lib/mysql", "/var/www/html" ]

EXPOSE 80 443 3306
CMD ["/run.sh"]
