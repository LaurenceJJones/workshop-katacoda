# Install nginx service for CrowdSec auto detection
ssh root@host01 "echo 'githubciXXXXXXXXXXXXXXXXXXXXXXXX' > /etc/machine-id && apt update && apt install nginx -y"

# Install hydra package for attacker demo
ssh root@node01 "apt update && apt install hydra nikto -y"
