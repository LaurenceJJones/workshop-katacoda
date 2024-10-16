We keep seeing bots requesting `wp-login.php`, however, we dont host wordpress so we want to block these requests.

Let's create a rule that will block any request that contains `wp-login.php` within the URI.

We are going to create a rule using the CrowdSec AppSec Rule Language.

Let's create our rule using the below snippet:

```
cat > /etc/crowdsec/appsec-rules/my_rule.yaml << EOF
## We don't host wordpress so block bots attempting to fetch wp-login.php
name: my/rule
description: "Detect bots attempting wordpress login page"
rules:
  - and:
    - zones:
        - URI
      transform:
        - lowercase
      match:
        type: contains
        value: "wp-login.php"
EOF
```{{execute T1}}

Great since we created the rule we need to edit the `AppSec`{{}} configuration file to load the rule.

Open `/etc/crowdsec/appsec-configs/appsec-default.yaml` with your favorite editor and add the following line:

```
...
inband_rules:
 - crowdsecurity/base-config 
 - crowdsecurity/vpatch-*
 - crowdsecurity/generic-*
 - "my/*" # <--- Add this line
```{{}}

Let's restart the AppSec component:

```
systemctl restart crowdsec
```{{execute T1}}

Let's test our Wordpress rule we implemented earlier:

```
curl -s -vv http://127.0.0.1/wp-login.php > /dev/null
```{{execute T1}}

You should see the following output:

```{14}
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

You can see the `403 Forbidden`{{}} response code which means that the request was blocked by the AppSec component.

How easy was that? We just created our first custom rule using the CrowdSec AppSec Rule Language.
