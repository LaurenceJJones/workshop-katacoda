Before we can start, we have to add the repository.
This gives us access to the latest package versions:
`curl -s https://install.crowdsec.net | sudo sh`{{execute T1}}

Great, now we can install the `CrowdSec Security Engine`{{}} it allows you to detect bad behaviors by analyzing log files and other data sources.
:

`apt install crowdsec -y`{{execute T1}}

Once security engine is installed we can install the remediation components!

```
apt install crowdsec-firewall-bouncer-iptables crowdsec-nginx-bouncer -y
```{{exec}}
