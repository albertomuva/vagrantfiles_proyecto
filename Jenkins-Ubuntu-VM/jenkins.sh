#!/bin/bash

echo "--------------------------Añadiendo apt-keys--------------------------"
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key
gpg --no-default-keyring --keyring /usr/share/keyrings/jenkins-keyring.asc --list-keys
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list

echo "--------------------------Actualizando apt-get--------------------------"
sudo apt-get -y update

echo "--------------------------Instalando dependencias--------------------------"
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

echo "--------------------------Instalando openjdk--------------------------"
sudo apt -y install fontconfig openjdk-17-jre

echo "--------------------------Instalando jenkins--------------------------"
sudo apt-get -y install jenkins

echo "--------------------------Instalando docker--------------------------"
sudo apt  install docker.io -y
sudo chmod 666 /var/run/docker.sock

echo "--------------------------Instalando trivy--------------------------"
sudo apt-get install trivy -y

echo "--------------------------Iniciando el servicio Jenkins--------------------------"
sudo systemctl restart jenkins

echo "--------------------------Jenkins service status--------------------------"
sudo systemctl status jenkins

JENKINSPWD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

echo "--------------------------Configuración de red--------------------------"
ip a

echo "--------------------------Contraseña de jenkins--------------------------"
echo $JENKINSPWD

echo "--------------------------Configurando ssh--------------------------"
sudo rm -rf /etc/ssh/sshd_config.d/*
sudo systemctl restart sshd