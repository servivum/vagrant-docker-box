#!/usr/bin/env bash

echo "Enabling nointeractive mode for Debian ..."
export DEBIAN_FRONTEND=noninteractive

echo "Updating and upgrading operation system ..."
apt-get update && apt-get upgrade

echo "Installing essentials ..."
apt-get install -y curl git mc rsync

echo "Adding command to jump into project folder after 'vagrant ssh'..."
echo "cd /vagrant/" >> /home/vagrant/.bashrc