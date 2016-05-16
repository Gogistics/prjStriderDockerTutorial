#Tutorial for Strider CI/CD with Docker

1. Create Project Folder, in this tutorial it's called **customized_docker_strider** and under this folder create another folder called **strider**

2. Clone projects' repositories from GitHub [Strider on GitHub](https://github.com/Strider-CD/strider) and [Strider Docker Container on GitHub](https://github.com/Strider-CD/docker-strider)

3. Copy the content of [official Strider repository](https://github.com/Strider-CD/strider) to the directory **customized_docker_strider/strider**, and copy start.sh, strider.conf, and sv_stdout.conf to the directory **customized_docker_strider/**

4. Register GitHub Application
In order to access from third-party application, a new GitHub application should be created.

5. Build Docker image and then run container

```$ docker build -t [MY_IMAGE_TAG_NAME] .```

```$ docker run --name [MY_CONTAINER_NAME] -e "DB_URI=mongodb://[MY_USER_NAMR]:[MY_USER_PWD]@[MY_MONGO_URL]:[MY_MONGO_PORT]/[MY_DB]" -p 9999:3000 -d [MY_IMAGE_TAG_NAME]```

NOTE: if the admin account is not set up, then ssh into container and change dir to /opt/strider/src and execute bin/strider addUser to create a admin account

======

Reference Links:

[Strider Tutorial by Marcus Pöhls](https://futurestud.io/blog/strider-getting-started-platform-overview)

[Strider on GitHub](https://github.com/Strider-CD/strider)

[Strider Docker Container on GitHub](https://github.com/Strider-CD/docker-strider)

[Google's SMTP Server](https://www.digitalocean.com/community/tutorials/how-to-use-google-s-smtp-server)

