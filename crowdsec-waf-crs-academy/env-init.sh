#!/bin/bash
# Install nginx service for CrowdSec auto detection
ssh root@host01 "echo 'githubciXXXXXXXXXXXXXXXXXXXXXXXX' > /etc/machine-id && apt update && apt install nginx -y"

#install crowdsec
ssh root@host01 "curl https://install.crowdsec.net | sudo sh && apt install crowdsec -y"

#install bouncer
ssh root@host01 "apt install crowdsec-nginx-bouncer -y"
