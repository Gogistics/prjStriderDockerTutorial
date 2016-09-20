#Tutorial for Strider CI/CD with Docker

1. Create Project Folder, in this tutorial it's called **customized_docker_strider** and under this folder create another folder called **strider**

   ```
   $ mkdir customized_docker_strider
   ```

2. Before we start to build the Strider container, MongoDB standalone, replica set, or sharding, should be deployed in advance for further use. Let's start with MongoDB standalone. Fisrt create a folder called **myMongoDB** under the folder **customized_docker_strider**, and then under that folder let's create another folder called **mongoStandalone**. Switch to the folder **mongoStandalone**.

   If you set port forwarding as 27107:27017

   If you set port forwarding as localhost:27017 or 127.0.0.1:27017

   If you don't set port forwarding, then you have to find the IP address of the container running mongodb by the following command.

   ```
   $ docker inspect -f '{{ .NetworkSettings.IPAddress }}'
   ```

   Let's start to build the container which runs a standalone mongodb

   ```
   $ cd customized_docker_strider

   $ mkdir -p myMongoDB/mongoStandalone

   $ cd myMongoDB/mongoStandalone

   $ docker build -t alantai/my_mongodb_standalone .

   $ docker run --name mongo_standalone -p [MY_HOST_PORT]:27017 -d alantai/my_standalone_mongodb
   ```

   Create script used by the System V init tools (SysVinit).

   ```
$ cp my_docker_mongo /etc/init.d/

$ chmod 755 /etc/init.d/my_docker_mongo

$ update-rc.d my_docker_mongo defaults
```

3. Clone projects' repositories from GitHub [Strider on GitHub](https://github.com/Strider-CD/strider) and [Strider Docker Container on GitHub](https://github.com/Strider-CD/docker-strider)

4. Copy the content of [official Strider repository](https://github.com/Strider-CD/strider) to the directory **customized_docker_strider/strider**, and copy start.sh, strider.conf, and sv_stdout.conf to the directory **customized_docker_strider/**

5. Register GitHub Application. In order to access from third-party application, a new GitHub application should be created. Once you successfully create the application, you will be able to get the app id(client id) and app secret(client secret) for further use.

6. Build Docker image and then run container

   ```
   $ docker build -t [MY_IMAGE_TAG_NAME] .

   $ docker run --name [MY_CONTAINER_NAME] -e "DB_URI=mongodb://[MY_USER_NAMR]:[MY_USER_PWD]@[MY_MONGO_URL]:[MY_MONGO_PORT]/[MY_DB]" -p 9999:3000 -d [MY_IMAGE_TAG_NAME]
   ```

7. Once Strider is running up, the DNS should be updated to be consistent with the previous setting of **Homepage URL** on GitHub **Register GitHub Application** page and allow users to access the application.

8. Let's add a project from GitHub for CI/CD practice and the project repo. is [here](https://github.com/Gogistics/prjNodeStriderDemo)


NOTE:

1. If the admin account is not set up, then ssh into container and change dir to /opt/strider/src and execute **strider addUser** to create a admin account

2. If you are going to install plugins before docker image is created, 

======

Reference Links:

[Strider CD](https://strider-cd.github.io/)

[StriderCD Book 1.4 documentation](http://strider.readthedocs.io/en/latest/intro.html)

[Strider Tutorial by Marcus Pöhls](https://futurestud.io/blog/strider-getting-started-platform-overview)

[Strider on GitHub](https://github.com/Strider-CD/strider)

[Strider Docker Container on GitHub](https://github.com/Strider-CD/docker-strider)

[Google's SMTP Server](https://www.digitalocean.com/community/tutorials/how-to-use-google-s-smtp-server)

[Mailgun SMTP](https://help.mailgun.com/hc/en-us/articles/203380100-Where-can-I-find-my-API-key-and-SMTP-credentials-)
