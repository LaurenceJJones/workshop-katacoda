echo 'githubciXXXXXXXXXXXXXXXXXXXXXXXX' > /etc/machine-id
apt update && apt upgrade -y
curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | bash
apt install crowdsec -y
echo "db_config:
  use_wal: true" > /etc/crowdsec/config.yaml.local
systemctl enable --now crowdsec.service