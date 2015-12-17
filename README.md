# docker-phpbb
This is a Docker image to run [phpBB](https://www.phpbb.com/), a popular open-source internet forum application.

Please note that, the application requires [post-installation configuration](#post-installation-configuration) via the command line.

## Components
The stack comprises the following components (some are obtained through [dell/lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)):

Name       | Version                 | Description
-----------|-------------------------|------------------------------
phpBB      | 3.1.3                   | Forum software
Ubuntu     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)                  | Operating system
MySQL      | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Database
Apache     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Web server
PHP        | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Scripting language


## Usage

### Start the Container
To start your container with:

* A named container ("phpbb")
* Host port 80 mapped to container port 80 (default HTTP port)
* Host port 443 mapped to container port 443 (default HTTPS port)
* Host port 3306 mapped to container port 3306 (default MySQL port)

Do:

    sudo docker run -d -p 80:80 -p 443:443 -p 3306:3306 --name phpbb dell/phpbb

A new admin user, with all privileges, will be created in MySQL with a random password. To get the password, check the container logs (```docker logs phpbb```). You will see output like the following:

    ====================================================================
    You can now connect to this MySQL Server using:

      mysql -uadmin -pca1w7dUhnIgI -h<host> -P<port>

    Please remember to change the above password as soon as possible!
    MySQL user 'root' has no password but only allows local connections
    =====================================================================

In this case, **ca1w7dUhnIgI** is the password allocated to the admin user.

You can then connect to the admin console...

    mysql -u admin -p ca1w7dUhnIgI --host 127.0.0.1 --port 3306


### Advanced Example
To start your image with a data volume (which will survive a restart) for the PHP application files, do:

    sudo docker run -d -p 80:80 -p 443:443 -p 3306:3306 -v /app:/var/www/html \
    -e MYSQL_PASS="password" --name phpbb dell/phpbb

The PHP application files will be available in folder **/app** on the host.

### Complete the Installation

Open a web browser and navigate to either the public DNS or IP address of your instance. For example, if the IP address is **54.75.168.125**, do:

    https://54.75.168.125/install

Your browser will warn you that the certificate is not trusted. If you are unclear about how to proceed, please consult your browser's documentation on how to accept the certificate.

You should see the Introduction page. Click on the Install tab. Next, click on "Proceed to the next step". Scroll to the bottom of the page and click "Start install".

Complete the following information:

* Database type: **MySQL**
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

Unless you have in depth knowledge of phpBB, you may wish to accept the defaults, and proceed through the installation until the final screen, which says "Congratulations!". Click on the login button, and supply the administrator details provided earlier.

<a name="post-installation-configuration"></a>
### Post-Installation Configuration
After completing the installation process, the **install** folder needs to be removed or renamed. Otherwise, the application will be limited to the administrator.

Currently (with Docker 1.2), the first step is to install [nsenter](https://github.com/jpetazzo/nsenter) on the host. If you are a DCM user, please ssh into the instance. Next, create file **install.sh**, with the following contents:


```no-highlight
apt-get install -y build-essential
curl https://www.kernel.org/pub/linux/utils/util-linux/v2.24/util-linux-2.24.tar.gz \
| tar -zxf-
cd util-linux-2.24
./configure --without-ncurses
make nsenter
cp nsenter /usr/local/bin
```

Next, do:

```no-highlight
chmod +x install.sh
sudo ./install.sh
```

Find the id of the phpBB container via ```sudo docker ps```. The output (truncated to the left of the screen), should look something like this:

```no-highlight
CONTAINER ID        IMAGE               COMMAND 
49ad89e9cc57        dell/phpbb:******   "/run.sh"      
```

Assuming, for example, a container ID of **49ad89e9cc57**, please do:

```no-highlight
PID=$(sudo docker inspect --format '{{.State.Pid}}' 49ad89e9cc57); \
sudo nsenter --target $PID --mount --uts --ipc --net --pid
```

You might get a warning, similar to the following, and a command prompt:

```no-highlight
bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
root@49ad89e9cc57:/# 
```

Finally, rename the install folder:

```no-highlight
cd /var/www/html/
mv install _install
exit
```

## Reference

### Environmental Variables

Variable   | Default  | Description
-----------|----------|----------------------------------
MYSQL_PASS | *random* | Password for MySQL user **admin**

### Image Details

Pre-built Image   | [https://registry.hub.docker.com/u/dell/phpbb](https://registry.hub.docker.com/u/dell/phpbb) 
