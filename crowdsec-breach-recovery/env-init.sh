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
  allow_older_versions: true
  hosts: ["http://127.0.0.1:9200"]
  username: "elastic"
  password: "crowdsec" 
setup.kibana:
    host: "127.0.0.1:5601" 
    username: "elastic"  
    password: "crowdsec"
    filebeat.config:
filebeat.config:
    modules:
        enabled: true
        path: modules.d/*.yml
        reload.enabled: true
        reload.period: 10s
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

sleep 60
filebeat setup -e
systemctl enable --now filebeat
git clone https://github.com/punk-security/pwnspoof
cd pwnspoof || exit 1
python pwnspoof.py wordpress --log-start-date 20230801 --log-end-date 20230830 --spoofed-attacks 5 --attack-type command_injection --server-fqdn marysfarm.local --out /var/log/pwn.log --server-type NGINX