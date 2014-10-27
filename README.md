# dell-docker-phpbb
Docker image [phpBB](https://www.phpbb.com/) is an open-source internet forum software written in PHP.

* [Components](#components)
* [Usage](#usage)
    * [Basic Example](#basic-example)
    * [Advanced Example 1](#advanced-example-1)   
* [Administration](#administration)
    * [Connecting to MySQL](#connecting-to-mysql)
    * [Complete the installation](#complete-installation)
* [Reference](#reference)
    * [Image Details](#image-details)
    * [Dockerfile Settings](#dockerfile-settings)
    * [Port Details](#port-details)
    * [Volume Details](#volume-details)
    * [Additional Environmental Settings](#additional-environmental-settings)
* [Blueprint Details](#blueprint-details)
* [Building the Image](#building-the-image)
* [Issues](#issues)

<a name="components"></a>
## Components
The stack comprises the following components (some are obtained through [dell/lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)):

Name       | Version                 | Description
-----------|-------------------------|------------------------------
Ubuntu     | Trusty                  | Operating system
phpBB      | 3.0.12                  | Forum Software
MySQL      | refer to dell/lamp-base | Database
Apache     | refer to dell/lamp-base | Web server
PHP        | refer to dell/lamp-base | Scripting language

**If a component is an up-to-date, compatible version, as determined by the operating system package manager, at installation time, please complete the version information based on the install.**

<a name="usage"></a>
## Usage

<a name="basic-example"></a>
Start the docker container, as follows:

```no-highlight
    docker run -d -p 80:80 -p 443:443 -p 3306:3306 -v /app:/var/www/html \
    --name phpbb dell/phpbb
```

Test your deployment:


<a name="administration"></a>
## Administration

<a name="connecting-to-mysql"></a>
### Connecting to MySQL
The first time that you run your container, a new user admin with all privileges will be created in MySQL with a random password. To get the password, check the logs of the container by command <b>docker logs container_id<b>. You will see an output like the following:

```no-highlight
========================================================================
You can now connect to this MySQL Server using:

    mysql -uadmin -p47nnf4FweaKu -h<host> -P<port>

Please remember to change the above password as soon as possible!
MySQL user 'root' has no password but only allows local connections
========================================================================
```

In this case, **47nnf4FweaKu** is the password allocated to the admin user.

You can then connect to MySQL:

```no-highlight
mysql -uadmin -p47nnf4FweaKu
```

Note that the root user does not allow connections from outside the container. Please use this admin user instead.

<a name="complete-installation"></a>
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

<a name="image-details"></a>
### Image Details

Attribute         | Value
------------------|------
Based on          | 
Github Repository | [https://github.com/dell-cloud-marketplace/docker-phpbb](https://github.com/dell-cloud-marketplace/docker-phpbb)
Pre-built Image   | [https://registry.hub.docker.com/u/dell/phpbb](https://registry.hub.docker.com/u/dell/phpbb) 

<a name="dockerfile-settings"></a>
### Dockerfile Settings

Instruction | Value
------------|------
ENV         | ['PHP_UPLOAD_MAX_FILESIZE', '10M']
ENV         | ['PHP_POST_MAX_SIZE', '10M']
VOLUME      | ['/var/lib/mysql', '/var/www/html']
EXPOSE      | ['80', '3306','443']
CMD         | ['/run.sh']

<a name="port-details"></a>
### Port Details

Port | Details
-----|--------
80   | Apache web server
443  | SSL
3306 | MySQL admin

<a name="volume-details"></a>
### Volume Details

Path           | Details
---------------|--------
/var/lib/mysql | MySQL data
/var/www/html  | The PHP application

<a name="blueprint-details"></a>
## Blueprint Details
Under construction.

<a name="building-the-image"></a>
## Building the Image
To build the image, execute the following command in the docker-phpbb folder:

```no-highlight
docker build -t dell/phpbb .
```

<a name="issues"></a>
## Issues
