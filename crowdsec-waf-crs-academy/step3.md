Now, we will configure the CRS in in-band mode, meaning they can actually block requests.

First thing to do is to create a new appsec config that will load them in in-band:
```
cat > /etc/crowdsec/appsec-configs/crs-blocking.yaml << EOF
name: custom/blocking-crs
default_remediation: ban
inband_rules:
 - crowdsecurity/crs
EOF
```{{execute T1}}

And tell crowdsec to use this appsec-config instead:

```
sed -i s@crowdsecurity/crs@custom/blocking-crs@ /etc/crowdsec/acquis.d/appsec.yaml
```{{execute T1}}

Restart crowdsec:
```
systemctl restart crowdsec
```{{execute T1}}


Let's try the same request again:

```
curl -I "localhost/?a=<script>alert(42)</script>"
```{{execute T1}}

We've been blocked !

As usual you can see the alert with `cscli`:
```
cscli alerts list
```{{execute T1}}