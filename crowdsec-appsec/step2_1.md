So for the first part we walked through configuring the AppSec Component from scratch. However, we are CrowdSec and we have community rules that we can use to protect our services!

Let's install the community rules:

```
cscli hub update && cscli collections install crowdsecurity/appsec-virtual-patching
```{{execute T1}}

The `crowdsecurity/appsec-virtual-patching`{{}} collection contains a number of rules that are directly linked to the CISA advisories.

Let's take a look at the rules:

```
cscli appsec-rules list
```{{execute T1}}

However, our current AppSec component is not configured to use the community rules. Let's update the configuration file to use the community rules:

```
cat > /etc/crowdsec/acquis.d/appsec.yaml << EOF
source: appsec
name: myappsec
appsec_config: crowdsecurity/virtual-patching
listen_addr: 127.0.0.1:4242
labels:
  type: appsec
EOF
```{{execute T1}}

Let's restart the AppSec component:

```
systemctl restart crowdsec
```{{execute T1}}

Let's test our Wordpress rule we implemented earlier:

```
curl -s -vv http://127.0.0.1/wp-login.php > /dev/null
```{{execute T1}}

You should see the following output:

```
*   Trying 127.0.0.1:80...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 80 (#0)
> GET /wp-login.php HTTP/1.1
> Host: localhost
> User-Agent: curl/7.68.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 403 Forbidden
< Server: nginx/1.18.0 (Ubuntu)
< Date: Tue, 16 Jan 2024 15:56:27 GMT
< Content-Type: text/html
< Transfer-Encoding: chunked
< Connection: keep-alive
< cache-control: no-cache
< 
{ [13882 bytes data]
```{{}}

You can see the `403 Forbidden`{{}} response code which means that the request was blocked by the AppSec component. If the request was blocked from within a browser they would see our standard CrowdSec block page.

However, since we switched to community rules, our WordPress rule is no longer loaded into the AppSec component. The current configuration file loads only community rules.

Let's update the configuration file to load both the community rules and our custom rule:

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
