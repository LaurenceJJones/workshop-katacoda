#!/bin/bash
# Install nginx service for CrowdSec auto detection
ssh root@host01 "echo 'githubciXXXXXXXXXXXXXXXXXXXXXXXX' > /etc/machine-id && apt update && apt install nginx -y"

#install crowdsec
#FIXME: this is using the testing repo because 1.7.0rc1 is required for the demo
ssh root@host01 "curl https://install.dev.crowdsec.net | sudo repo=crowdsec-testing sh && apt install crowdsec -y"

#install bouncer
ssh root@host01 "apt install crowdsec-nginx-bouncer -y"
