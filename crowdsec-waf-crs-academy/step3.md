The hub also provides a blocking version of the CRS.

As usual, it can be installed with `cscli`:

```
cscli collections install crowdsecurity/appsec-crs-inband
```{{execute T1}}

Update the acquisition config to load this appsec-config instead:

```
sed -i s@crowdsecurity/crs@crowdsecurity/blocking-crs@ /etc/crowdsec/acquis.d/appsec.yaml
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