echo 'githubciXXXXXXXXXXXXXXXXXXXXXXXX' > /etc/machine-id
apt update && apt upgrade -y
curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | bash
apt install crowdsec -y
systemctl enable --now crowdsec.service