# docker-phpbb
[phpBB](https://www.phpbb.com/) is open-source internet forum software.

## Components
The stack comprises the following components (some are obtained through [dell/lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)):

Name       | Version                 | Description
-----------|-------------------------|------------------------------
Ubuntu     | Trusty                  | Operating system
phpBB      | 3.0.12                  | Forum software
MySQL      | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Database
Apache     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Web server
PHP        | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Scripting language

## Usage

### Start the Container
Start the container, as follows:

    docker run -d -p 80:80 -p 443:443 -p 3306:3306 -v /app:/var/www/html \
    --name phpbb dell/phpbb

You need to check the container logs, in order to get the MySQL password:

    docker logs phpbb

You should see an output like the following:

    ====================================================================
    You can now connect to this MySQL Server using:

      mysql -uadmin -pca1w7dUhnIgI -h<host> -P<port>

    Please remember to change the above password as soon as possible!
    MySQL user 'root' has no password but only allows local connections
    =====================================================================

In this case, **ca1w7dUhnIgI** is the password allocated to the admin user. Copy the value to the clipboard.

### Complete the installation

Open a web browser and navigate to either the public DNS or IP address of your instance. For example, if the IP address is **54.75.168.125**, do:

    https://54.75.168.125/install

Your browser will warn you that the certificate is not trusted. If you are unclear about how to proceed, please consult your browser's documentation on how to accept the certificate.

You should see the Introduction page. Click on the Install tab. Next, click on "Proceed to the next step". Scroll to the bottom of the page and click "Start install".

Complete the following information:

* Database server hostname or DSN: **localhost**
* Database name: **phpbb**
* Database username: **admin**
* Database password: (paste the value you copied from the logs)

Click on "Proceed to the next step". You should get a message saying "Successful connection". Again, click on "Proceed to the next step".

Next, provide the following details (you are free to choose the values):

* Administrator username
* Administrator password
* Confirm administrator password
* Contact e-mail address
* Confirm contact e-mail

Unless you have in depth knowledge of phpBB, you may wish to accept the defaults, and proceed through the installation until the final screen, which says "Congratulations!". Click on the login button, and supply the administrator details provided earlier.

### Remove the **install** folder.
TBD

### Image Details

Pre-built Image   | [https://registry.hub.docker.com/u/dell/phpbb](https://registry.hub.docker.com/u/dell/phpbb) 
