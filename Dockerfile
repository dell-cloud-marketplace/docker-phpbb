FROM dell/lamp-base:1.2
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Update existing packages.
RUN apt-get update

# Install packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
        php5-gd \
        imagemagick \
        wget \
        unzip
        
# Clean package cache
RUN apt-get -y clean && rm -rf /var/lib/apt/lists/*

# Add scripts.
COPY run.sh /run.sh
COPY initialize_mysql.sh /initialize_mysql.sh
RUN chmod 755 /*.sh

# Prepare phpBB (which is installed in the run.sh script).
RUN wget https://www.phpbb.com/files/release/phpBB-3.1.3.zip
RUN unzip phpBB-3.1.3.zip
RUN rm -fr /var/www/html/*

# Add volumes for MySQL and the application
VOLUME  ["/var/lib/mysql", "/var/www/html" ]

EXPOSE 80 443 3306
CMD ["/run.sh"]
