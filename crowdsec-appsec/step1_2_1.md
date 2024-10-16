Since we have now configured the AppSec component we can install the official `crowdsecurity/appsec-virtual-patching` collection which contains commonly exploited vulnerabilities.

```
cscli collections install crowdsecurity/appsec-virtual-patching crowdsecurity/appsec-generic-rules
```{{execute T1}}

Once we have installed the collection we can now enable the AppSec component:

```
sudo systemctl restart crowdsec
```{{execute T1}}

We can ensure the AppSec port is connectable by running a simple nc command:

```
nc -zv 127.0.0.1 4242
```{{execute T1}}

In the next section we will installing and configure Nginx lua remediation to use our new AppSec component.
