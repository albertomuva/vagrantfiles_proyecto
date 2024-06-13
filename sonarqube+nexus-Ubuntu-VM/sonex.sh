#!/bin/bash

echo "--------------------------Actualizando apt-get--------------------------"
sudo apt update

echo "--------------------------Instalando docker--------------------------"
sudo apt  install docker.io -y

echo "--------------------------Levantando contenedor de nexus--------------------------"
sudo docker run -d -p 8081:8081 sonatype/nexus3

echo "--------------------------Levantando contenedor de sonarqube--------------------------"
sudo docker run -d -p 9000:9000 sonarqube:lts-community

echo "--------------------------Configuración de red--------------------------"
ip a

echo "--------------------------Contenedores levantados--------------------------"
ID_CONTENEDOR=$(sudo docker ps | cut -d " " -f1 | tail -1)
sudo docker ps

echo "--------------------------Contraseña nexus--------------------------"
echo $ID_CONTENEDOR
sudo docker exec $ID_CONTENEDOR cat /nexus-data/admin.password

echo "--------------------------Configurando ssh--------------------------"
sudo rm -rf /etc/ssh/sshd_config.d/*
sudo systemctl restart sshd