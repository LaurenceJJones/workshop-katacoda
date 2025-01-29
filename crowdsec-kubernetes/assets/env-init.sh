#!/bin/bash

# install helm
curl -LO https://get.helm.sh/helm-v3.17.0-linux-amd64.tar.gz
tar -zxvf helm-v3.17.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/
rm -rf linux-amd64 helm-v3.17.0-linux-amd64.tar.gz linux-amd64

# Install hydra package for attacker demo
apt update && apt install hydra nikto -y