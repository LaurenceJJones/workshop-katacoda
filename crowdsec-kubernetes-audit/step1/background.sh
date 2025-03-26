#!/bin/bash

# install helm
curl -LO https://get.helm.sh/helm-v3.17.0-linux-amd64.tar.gz
tar -zxvf helm-v3.17.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/
rm -rf linux-amd64 helm-v3.17.0-linux-amd64.tar.gz linux-amd64

# Add helm repos
helm repo add crowdsec https://crowdsecurity.github.io/helm-charts
helm repo update

# Install crowdsec
helm install crowdsec crowdsec/crowdsec --create-namespace --namespace crowdsec  -f crowdsec-values.yaml

# add host in /etc/hosts
echo "$(getent hosts node01 | awk '{ print $1 }') helloworld.local" | sudo tee -a /etc/hosts

# add done file
touch /root/done