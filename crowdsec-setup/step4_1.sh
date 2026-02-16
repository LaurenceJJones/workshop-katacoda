# Disable firewall bouncer so web remediation can be demonstrated via nginx block page
ssh root@host01 "systemctl stop crowdsec-firewall-bouncer"
