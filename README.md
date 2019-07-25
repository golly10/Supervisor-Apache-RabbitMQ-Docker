# Supervisor-Apache-RabbitMQ-Docker
This repository contains the needed files to create a docker container that runs supervisor in the background and Apache and RabbitMQ as foreground. The steps to run it are as follows:
- First, create the images:
> docker build -t [image-name] .
- Lastly, create the container mapping the ports
> docker run -p [apache-port]:80 -p [supervisor-port]:9001 -p 5672:5672 -p [rabbitmq-port]:15672 -it [image-name]

##### Notes: 
###### The default user and password for supervisor are _root_ and _root_ respectively.
###### The default user and password for rabbitMQ are _guest_ and _guest_ respectively.
###### In order to change supervisor authentication, change [inet_http_server] in supervisor.conf. To change it for RabbitMQ, use RabbitMQ Administrator

