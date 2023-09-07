#!/bin/bash

# setup elk stack
wget -qO- https://github.com/deviantony/docker-elk/archive/refs/tags/8.2302.1.tar.gz | tar xvz
cd docker-elk* || exit 1
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
filebeat modules enable system

cat <<-EOT > "/etc/filebeat/modules.d/nginx.yml"
- module: nginx
  access:
    enabled: true
    var.paths: ["/var/log/nginx/access.log*", "/var/log/pwn.log"]
  error:
    enabled: true
    var.paths: ["/var/log/nginx/error.log*"]
	EOT
cat <<-EOT > "/etc/filebeat/modules.d/system.yml"
- module: system
  auth:
    enabled: true
    var.paths: ["/var/log/auth.log*"]
	EOT

sleep 60
filebeat setup -e
systemctl enable --now filebeat
cd - || exit 1
git clone https://github.com/punk-security/pwnspoof
cd pwnspoof || exit 1
python pwnspoof.py wordpress --session-count 7000 --log-start-date "$(date -d '-30 days' +%Y%m%d)" --log-end-date "$(date +%Y%m%d)"  --spoofed-attacks 3 --attack-type command_injection --server-fqdn marysfarm.local --out /var/log/pwn.log --server-type NGINX

NUM=0
for i in $(grep "?cmd" /var/log/pwn.log | cut -d ' ' -f1 | sort -u); do
  NUM=$((NUM-1))
  compdate=$(date -d "$NUM days" "+%b  %d %H:%M:%S")
  echo "$compdate bullseye sshd[557]: Accepted publickey for root from $i port 365$NUM ssh2" >> /var/log/auth.log
done