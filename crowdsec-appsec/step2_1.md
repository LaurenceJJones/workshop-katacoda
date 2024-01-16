So for the first part we walked through configuring the AppSec Component from scratch. However, we are CrowdSec and we have community rules that we can use to protect our services!

Lets install the community rules:

```
cscli hub update && cscli collections install crowdsecurity/appsec-virtual-patching
```{{execute T1}}

The `crowdsecurity/appsec-virtual-patching`{{}} collection contains a number of rules that are directly linked to the CISA advisories.

Lets take a look at the rules:

```
cscli appsec-rules list
```{{execute T1}}

However, our current AppSec component is not configured to use the community rules. Lets update the configuration file to use the community rules:

```
cat > /etc/crowdsec/appsec.yaml << EOF
source: appsec
name: myappsec
appsec_config: crowdsecurity/virtual-patching
listen_addr: 127.0.0.1:4242
labels:
  type: appsec
EOF
```{{execute T1}}

Lets restart the AppSec component:

```
systemctl restart crowdsec
```{{execute T1}}

Lets test a laravel debug vulnerability using the following snippet:

```
curl -s -vv http://localhost/ --data "0x[]=123" >/dev/null
```{{execute T1}}

You should see the same `403 Forbidden`{{}} response code which means that the request was blocked using community rules.

However, since we have now changed over to using the community rules, our wordpress rule is no longer loaded into the AppSec component. The current configuration file only loads the community rules.

Lets update the configuration file to load both the community rules and our custom rule:

Open `/etc/crowdsec/appsec-configs/virtual-patching.yaml` with your favorite editor and add the following line:

```
...
inband_rules:
 - crowdsecurity/base-config 
 - crowdsecurity/vpatch-*
 - "my/*" # <--- Add this line
## This is a GLOB rule, it will match any rule that starts with "my/"
...
```{{}}