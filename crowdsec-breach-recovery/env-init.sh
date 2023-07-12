#!/bin/bash

# setup elk stack
wget -qO- https://github.com/deviantony/docker-elk/archive/refs/tags/8.2302.1.tar.gz | tar xvz
cd docker-elk*
sed -i "s/''/crowdsec/g" .env
sed -i "s/'changeme'/crowdsec/g" .env
docker-compose up setup
docker-compose up -d

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.8.2-amd64.deb
sudo dpkg -i filebeat-8.8.2-amd64.deb

cat <<-EOT > "/etc/filebeat/filebeat.yml"
output.elasticsearch:
  hosts: ["https://127.0.0.1:9200"]
  username: "filebeat_internal"
  password: "crowdsec" 
  ssl:
    enabled: true
    ca_trusted_fingerprint: "b9a10bbe64ee9826abeda6546fc988c8bf798b41957c33d05db736716513dc9c" 
	EOT

filebeat modules enable nginx

cat <<-EOT > "/etc/filebeat/modules.d/nginx.yml"
- module: nginx
  access:
    enabled: true
    var.paths: ["/var/log/nginx/access.log*", "/var/log/pwn.log"]
  error:
    enabled: true
    var.paths: ["/var/log/nginx/error.log*"]
	EOT

filebeat setup -e
systemctl enable --now filebeat