#!/bin/bash

# install helm
curl -LO https://get.helm.sh/helm-v3.17.0-linux-amd64.tar.gz
tar -zxvf helm-v3.17.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/
rm -rf linux-amd64 helm-v3.17.0-linux-amd64.tar.gz linux-amd64

# Install hydra package for attacker demo
apt update && apt install hydra nikto -y

# Add helm repos
helm repo add crowdsec https://crowdsecurity.github.io/helm-charts
helm repo add traefik https://helm.traefik.io/traefik
helm repo add jetstack https://charts.jetstack.io
helm repo add emberstack https://emberstack.github.io/helm-charts
helm repo update

## Install cert-manager and reflector
helm install cert-manager jetstack/cert-manager --create-namespace --namespace cert-manager --set installCRDs=true
helm install reflector emberstack/reflector --create-namespace --namespace reflector

# Install traefik
helm install traefik traefik/traefik --create-namespace --namespace traefik -f module2/traefik-values.yaml

# Install crowdsec
helm install crowdsec crowdsec/crowdsec --create-namespace --namespace crowdsec  -f module2/crowdsec-values.yaml

# Install the bouncer middleware
kubectl apply -f module2/bouncer-middleware.yaml

# Install helloworld app
helm install helloworld crowdsec/helloworld --namespace default --set ingress.enabled=true

# add host in /etc/hosts
echo "$(getent hosts node01 | awk '{ print $1 }') helloworld.local" | sudo tee -a /etc/hosts

# add done file
touch /root/done