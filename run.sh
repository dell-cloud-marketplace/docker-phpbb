#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
    /initialize_mysql.sh
else
    echo "=> Using an existing volume of MySQL"
fi

APPLICATION_HOME="/var/www/html"

if [[ ! -d $APPLICATION_HOME ]]; then
   echo "=> Copying application files"
   cp -r phpBB3/* $APPLICATION_HOME
   cd $APPLICATION_HOME
   for files in config.php cache files store images/avatars/upload/; \
   do chmod 777 $files; done
fi


exec supervisord -n
