The first step for configuring and enabled the CrowdSec WAF is to add the crowdsec repository to our machine:

```
curl -s https://install.crowdsec.net/ | sudo sh
```{{execute T1}}

Once the repository has been added, we can install the `CrowdSec Security Engine`{{}}

```
apt install crowdsec -y
```{{execute T1}}