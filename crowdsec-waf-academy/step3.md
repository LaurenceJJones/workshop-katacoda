Now, we need to configure our nginx to forward the request to the Security Engine for analysis.

First step is to install the nginx remediation component:
```
apt install crowdsec-nginx-bouncer
```{{execute T1}}

We need to tell nginx where to forward the request to.
To do so, simply edit the remediation component configuration:

```
echo "APPSEC_URL=http://127.0.0.1:7422/" >> /etc/crowdsec/bouncers/crowdsec-nginx-bouncer.conf
```{{execute T1}}

Finally, we can restart nginx:
```
systemctl restart nginx
```{{execute T1}}