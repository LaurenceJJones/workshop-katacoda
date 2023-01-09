echo 'githubciXXXXXXXXXXXXXXXXXXXXXXXX' > /etc/machine-id
curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | bash
apt install crowdsec -y
echo "db_config:
  use_wal: true" > /etc/crowdsec/config.yaml.local
systemctl enable --now crowdsec.service
cd /opt/ && git clone https://github.com/LaurenceJJones/workshop-katacoda.git
cd workshop-katacoda/crowdsec-parsers-scenarios/assets/myapp/
go mod download
go build .
./myapp