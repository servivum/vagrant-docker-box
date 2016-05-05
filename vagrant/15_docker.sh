#!/usr/bin/env bash

apt-get install -y apt-transport-https bash-completion ca-certificates

echo "Adding GPG Key for Docker repository ..."
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "Adding Docker repository to apt ..."
cat > /etc/apt/sources.list.d/docker.list <<EOF
deb https://apt.dockerproject.org/repo debian-jessie main
EOF
apt-get update

echo "Installing Docker Engine ..."
apt-get install -y docker-engine

echo "Putting vagrant user in docker group"
gpasswd -a vagrant docker

echo "Starting Docker daemon"
service docker start

echo "Installing Docker Compose ..."
curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Installing command completion for Docker Compose ..."
curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose