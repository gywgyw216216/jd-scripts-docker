#!/bin/bash

echo ">>> "$(date +%F%n%T) "Updating apt...... \n"
apt update
echo ">>> "$(date +%F%n%T) "Update apt Successfully! \n"
echo ">>> "$(date +%F%n%T) "Installing git...... \n"
apt -y install git
echo "\n>>> "$(date +%F%n%T) "Install git Successfully! \n"
echo ">>> "$(date +%F%n%T) "Installing docker...... \n"
apt -y install runc
apt -y install containerd
apt -y install docker
apt -y install docker.io
echo "\n>>> "$(date +%F%n%T) "Install docker Successfully! \n"
echo ">>> "$(date +%F%n%T) "Installing docker-compose...... \n"
apt -y install docker-compose
echo "\n>>> "$(date +%F%n%T) "Install docker-compose Successfully! \n"
echo ">>> "$(date +%F%n%T) "Starting docker Service...... "
systemctl enable docker
systemctl restart docker
echo ">>> "$(date +%F%n%T) "Docker Service Starts Successfully! \n"
echo ">>> "$(date +%F%n%T) "Initializing JD-Scripts-Docker...... \n"
cd /root/

rm -rf ./jd-scripts-docker/

git clone https://github.com/gywgyw216216/jd-scripts-docker.git

cd jd-scripts-docker

docker rm -f jd1
docker rmi -f `docker images -q`
echo "\n>>> "$(date +%F%n%T) "Initialize JD-Scripts-Docker Successfully! \n"
echo ">>> "$(date +%F%n%T) "Building JD-Scripts-Docker...... \n"
docker-compose up --build --force-recreate --detach jd1
echo "\n>>> "$(date +%F%n%T) "Build JD-Scripts-Docker Successfully! \n"
echo ">>> "$(date +%F%n%T) "Running JD-Scripts-Docker...... \n"
docker exec jd1 bash -c 'set -o allexport; source /all; source /env; source /jd-scripts-docker/resolve.sh; cd /scripts; ls jd_*.js | xargs -i node {}'

