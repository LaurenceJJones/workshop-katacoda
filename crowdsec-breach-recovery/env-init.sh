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
python pwnspoof.py wordpress --log-start-date "$(date -d '-15 days' +%Y%m%d)" --spoofed-attacks 0 --attack-type command_injection --server-fqdn marysfarm.local --out /var/log/pwn.log --additional-attacker-ips 14.32.0.74,221.210.252.36,204.157.240.55,200.59.184.155,103.231.177.154 --server-type NGINX
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
  ## Set min num to base days and subtract 1 second for each port
  MIN_NUM=$((NUM*86400))
  ## Loop over common ssh ports
  for port in 22 2022 2222 2202 2002 2000 2220 202 220; do
    MIN_NUM=$((MIN_NUM-1))
    compdate=$(date -d "$MIN_NUM seconds" "+%b  %-d %H:%M:%S")
    ## Inject iptables IOCS
    if [ $port -eq 22 ]; then
      ## Inject accepted
      echo "$compdate bullseye kernel: [  659.418604] ACCEPT IN=eth0 OUT= MAC=52:54:00:83:ad:a5:52:54:00:99:c9:e0:08:00 SRC=$i DST=1.2.3.4 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=54729 DF PROTO=TCP SPT=$PORT DPT=$port WINDOW=64240 RES=0x00 SYN URGP=0" >> /var/log/iptables.log
    else
      ## Inject dropped
      echo "$compdate bullseye kernel: [  659.418604] DROP IN=eth0 OUT= MAC=52:54:00:83:ad:a5:52:54:00:99:c9:e0:08:00 SRC=$i DST=1.2.3.4 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=54729 DF PROTO=TCP SPT=$PORT DPT=$port WINDOW=64240 RES=0x00 SYN URGP=0" >> /var/log/iptables.log
    fi
  done
done

NUM=0
## Range over 15 days
for i in {0..16}; do
  NUM=$((NUM-1))
  MIN_NUM=$((NUM*86400))
  echo "Injecting iptables noise"
  for ip in $(cat /var/log/pwn.log |cut -d ' ' -f1 | sort -u); do
      PORT=$((min + RANDOM % max))
      MIN_NUM=$((MIN_NUM-2))
      compdate=$(date -d "$MIN_NUM seconds" "+%b  %-d %H:%M:%S")
      echo "$compdate bullseye kernel: [  659.418604] ACCEPT IN=eth0 OUT= MAC=52:54:00:83:ad:a5:52:54:00:99:c9:e0:08:00 SRC=$ip DST=1.2.3.4 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=54729 DF PROTO=TCP SPT=$PORT DPT=443 WINDOW=64240 RES=0x00 SYN URGP=0" >> /var/log/iptables.log
  done
  MIN_NUM=$((NUM*86400))
  echo "Injecting ssh noise"
  for ip in 1.2.3.4 1.2.4.5 1.1.1.1 1.0.0.1; do
    PORT=$((min + RANDOM % max))
    MIN_NUM=$((MIN_NUM-3600))
    compdate=$(date -d "$MIN_NUM seconds" "+%b  %-d %H:%M:%S")
    echo "$compdate bullseye sshd[557]: Accepted password for root from $ip port $PORT ssh2" >> /var/log/auth.log
  done
done


echo "ELK Stack setup complete!"


curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash

sudo apt-get install crowdsec -y

cscli hub update

cscli collections install crowdsecurity/nginx crowdsecurity/iptables

systemctl restart crowdsec

cat <<-EOT > "/etc/crowdsec/scenarios/2-little-ducks.yaml"
type: leaky
name: blueteam/2-little-ducks
description: "Common ssh ports being scanned"
filter: |
  evt.Meta.log_type == 'iptables_drop' &&
  evt.Meta.service == 'tcp' &&
  evt.Parsed.dst_port in ['22', '2022', '2222', '2202', '2002', '2000', '2220', '202' ,'220']"
groupby: evt.Meta.source_ip
capacity: 3
leakspeed: 10s
blackhole: 1m
labels:
  service: tcp
  type: scan
  remediation: true
	EOT

cat <<-EOT > "/etc/crowdsec/scenarios/php-cmd.yaml"
type: trigger
name: blueteam/php-cmd
description: "PHP cmd injection"
filter: |
  evt.Meta.log_type in ['http_access-log', 'http_error-log'] &&
  evt.Parsed.http_args matches 'cmd(=|%3D)' &&
  evt.Parsed.http_status == '200' &&
  evt.Parsed.request matches '.php$'
blackhole: 1m
labels:
  service: tcp
  type: scan
  remediation: true
	EOT
