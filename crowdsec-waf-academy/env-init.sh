#!/bin/bash
# Install nginx service for CrowdSec auto detection
ssh root@host01 "echo 'githubciXXXXXXXXXXXXXXXXXXXXXXXX' > /etc/machine-id && apt update && apt install nginx -y"

# Install hydra package for attacker demo
ssh root@node01 "apt update && apt install hydra nikto -y"

apt install nginx -y && sed -i 's/try_files $uri $uri\/ \=404\;/proxy_pass http:\/\/127.0.0.1:8080\;/' /etc/nginx/sites-enabled/default