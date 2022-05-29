#!/bin/bash

echo ">>> "$(date +%F%n%T) "Initializing Environment...... \n"

swapoff -a
rm -f /swapfile

docker image prune -a -f
docker rm -f jd1
docker rm -f `docker ps -q`
docker rmi -f `docker images -q`
docker volume rm -f `docker volume ls -q`

snap set system refresh.retain=2

apt -y autoremove --purge
apt clean -y

rm -rf /etc/apt/sources.list.d

apt update -y

echo ">>> "$(date +%F%n%T) "Update apt Successfully! \n"
echo ">>> "$(date +%F%n%T) "Installing docker...... \n"
apt -y install runc containerd docker docker.io docker-compose
echo "\n>>> "$(date +%F%n%T) "Install docker Successfully! \n"
echo ">>> "$(date +%F%n%T) "Starting docker Service...... "
systemctl enable docker
systemctl restart docker
echo ">>> "$(date +%F%n%T) "Docker Service Starts Successfully! \n"
echo ">>> "$(date +%F%n%T) "Initializing JD-Scripts-Docker...... \n"

cd /root/
rm -rf ./jd-scripts-docker/
git clone https://github.com/gywgyw216216/jd-scripts-docker.git
cd jd-scripts-docker

echo "\n>>> "$(date +%F%n%T) "Initialize JD-Scripts-Docker Successfully! \n"
echo ">>> "$(date +%F%n%T) "Building JD-Scripts-Docker...... \n"
docker-compose up --build --force-recreate --detach jd1
echo "\n>>> "$(date +%F%n%T) "Build JD-Scripts-Docker Successfully! \n"
echo ">>> "$(date +%F%n%T) "Running JD-Scripts-Docker...... \n"
docker exec jd1 bash -c 'set -o allexport; source /all; source /env; source /jd-scripts-docker/resolve.sh; cd /scripts; ls jd_*.js | xargs -i node {}'

