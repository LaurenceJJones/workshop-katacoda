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
filebeat modules enable iptables

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
cat <<-EOT > "/etc/filebeat/modules.d/iptables.yml"
- module: iptables
  log:
    enabled: true
    var.paths: ["/var/log/iptables.log"]
    var.input: "file"
	EOT
sleep 60
filebeat setup -e
systemctl enable --now filebeat
cd - || exit 1

## Generate fake logs :D
git clone https://github.com/punk-security/pwnspoof
cd pwnspoof || exit 1
python pwnspoof.py wordpress --session-count 7000 --log-start-date "$(date -d '-30 days' +%Y%m%d)" --log-end-date "$(date +%Y%m%d)"  --spoofed-attacks 0 --attack-type command_injection --server-fqdn marysfarm.local --out /var/log/pwn.log --additional-attacker-ips 14.32.0.74,221.210.252.36,204.157.240.55,200.59.184.155,103.231.177.154 --server-type NGINX
## Use pwnspoof for nginx logs

min=34000
max=36000
NUM=0
## Grep malicious IP's out of the pwn.log and inject them into the other IOCS
echo "Injecting malicious IP's ssh and iptables"
for i in $(grep "?cmd" /var/log/pwn.log | cut -d ' ' -f1 | sort -u); do
  NUM=$((NUM-5))
  PORT=$((min + RANDOM % max))
  compdate=$(date -d "$NUM days" "+%b  %-d %H:%M:%S")
  ## Inject ssh IOCS
  echo "$compdate bullseye sshd[557]: Accepted password for root from $i port $PORT ssh2" >> /var/log/auth.log
  ## Set min num to base days and subtract 10 seconds for each port
  MIN_NUM=$((NUM*86400))
  ## Loop over common ssh ports
  for port in 22 2022 2222 2202 2002 2000 2220 202 220; do
    MIN_NUM=$((MIN_NUM-10))
    compdate=$(date -d "$MIN_NUM seconds" "+%b  %-d %H:%M:%S")
    ## Inject iptables IOCS
    if [ $port -eq 22 ]; then
      ## Inject accepted
      echo "$compdate bullseye kernel: [  659.418604] IN=eth0 OUT= MAC=52:54:00:83:ad:a5:52:54:00:99:c9:e0:08:00 SRC=$i DST=1.2.3.4 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=54729 DF PROTO=TCP SPT=41894 DPT=$port WINDOW=64240 RES=0x00 SYN URGP=0 ACCEPT" >> /var/log/iptables.log
    else
      ## Inject dropped
      echo "$compdate bullseye kernel: [  659.418604] IN=eth0 OUT= MAC=52:54:00:83:ad:a5:52:54:00:99:c9:e0:08:00 SRC=$i DST=1.2.3.4 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=54729 DF PROTO=TCP SPT=41894 DPT=$port WINDOW=64240 RES=0x00 SYN URGP=0" >> /var/log/iptables.log
    fi
  done
done


## Inject "legit" logins for a constant IP
echo "Injecting legit ssh logins"
NUM=0
for i in {1..100}; do
  NUM=$((NUM-i))
  PORT=$((min + RANDOM % max))
  compdate=$(date -d "$NUM days" "+%b  %-d %H:%M:%S")
  echo "$compdate bullseye sshd[557]: Accepted password for root from 1.2.3.4 port $PORT ssh2" >> /var/log/auth.log
done