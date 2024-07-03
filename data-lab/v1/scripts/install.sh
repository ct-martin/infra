#!/bin/bash

# This script assumes Microk8s on Ubuntu

# Dependencies from apt

sudo apt install postgresql-client mysql-client python3-venv

# Add Kubernetes CLI utils

sudo snap install kubectl --classic
sudo snap install docker
sudo snap install helm --classic

# Install Microk8s per https://microk8s.io/docs/getting-started

sudo snap install microk8s --classic --channel=1.30

sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
chmod 0700 ~/.kube

microk8s status --wait-ready
echo "To update your groups, log out and back in or run 'su - \$USER'"

# Add kube config file to current user

sudo microk8s config > ~/.kube/config
sudo chown -f -R $USER:$USER ~/.kube/config
chmod 600 ~/.kube/config

# Install useful addons

microk8s enable cert-manager
microk8s enable dashboard
microk8s enable dns
microk8s enable helm
microk8s enable hostpath-storage
microk8s enable host-access
microk8s enable ingress
microk8s enable minio
microk8s enable metrics-server

# Done

echo "Done"
