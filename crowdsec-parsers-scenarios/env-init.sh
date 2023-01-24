echo 'ffffffffffffffffffffffffffffffff' > /etc/machine-id
curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | bash
apt install crowdsec -y
echo "db_config:
  use_wal: true" > /etc/crowdsec/config.yaml.local
cscli parsers remove crowdsecurity/whitelists
systemctl enable --now crowdsec.service
echo "
---
filenames:
  - /var/log/myapp.log
labels:
  type: myapp
" >> /etc/crowdsec/acquis.yaml
cd /opt/ && git clone https://github.com/LaurenceJJones/workshop-katacoda.git
cd workshop-katacoda/crowdsec-parsers-scenarios/assets/myapp/
/usr/local/go/bin/go mod download
/usr/local/go/bin/go build .
./myapp -password=$(openssl rand -base64 12) -user=$(shuf -n 1 users.txt)
