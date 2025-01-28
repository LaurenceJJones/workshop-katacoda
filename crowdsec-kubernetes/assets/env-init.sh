#!/bin/bash

# install helm
curl -LO https://get.helm.sh/helm-v3.17.0-linux-amd64.tar.gz
tar -zxvf helm-v3.17.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/

# Install hydra package for attacker demo
ssh root@node01 "apt update && apt install hydra nikto -y"