The OWASP CRS (CRS for short) is a set of generic attack detection rules initially designed for ModSecurity.

Thanks to the CrowdSec WAF support for modsecurity rules, you can very easily use them.

Crowdsec and nginx are already installed on our test machine, so we'll just need to configure them.

The CRS rules are available in the hub, we just need to install them with `cscli`:
```
cscli collections install crowdsecurity/appsec-crs
```{{execute T1}}

We now need to configure crowdsec to load those rule.
Let's create a new acquisition file:
```
cat > /etc/crowdsec/acquis.d/appsec.yaml << EOF
source: appsec
appsec_config: crowdsecurity/crs
labels:
  type: appsec
EOF
```{{execute T1}}

We can now restart crowdsec:
```
systemctl restart crowdsec
```{{execute T1}}

Now, we can tell nginx to forward request to the Security Engine:
```
echo "APPSEC_URL=http://127.0.0.1:7422/" >> /etc/crowdsec/bouncers/crowdsec-nginx-bouncer.conf
```{{execute T1}}

Finally, we can restart nginx:
```
systemctl restart nginx
```{{execute T1}}