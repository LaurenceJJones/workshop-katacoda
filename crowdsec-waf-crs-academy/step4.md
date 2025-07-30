Because CRS can lead to false positives, you may want to disable some specific at runtime.

The CrowdSec WAF offers 2 ways to do this:
 - Manually creating ModSecurity rules using `SecRuleUpdateById` or `SecRuleRemoveById`
 - Using hooks to dynamically change the behavior of the WAF.

Here, we'll be focusing on hooks, as they are easier to work with.

Hooks are defined in an appsec config.

There are 4 types of hooks:
 - on_load
 - pre_eval
 - post_eval
 - on_match

They will be explained in more details in the next module, for now, we'll just use the `pre_eval` hook.

It is called just before a request is processed by the WAF.

Let's say our website has an admin panel, and the CRS generate false positive matches because some request look like they could be XSS attempt.

Let's add the following configuration to our custom appsec config:
```
cat >> /etc/crowdsec/appsec-configs/crs-blocking.yaml << EOF
pre_eval:
 - filter: IsInBand == true && req.URL.Path startsWith "/admin/"
   apply:
    - RemoveInBandRuleByTag("attack-xss")
EOF
```{{execute T1}}

The hook is composed of 2 elements:
 - a filter: If the filter returns `true`, the action will be evaluated
 - one or more action: Here we are removing all rules that have the tag `attack-xss`. This tag is specific to the CRS.

We can restart crowdsec:
```
systemctl restart crowdsec
```{{execute T1}}

We can now try our requests.

First, we can confirm a request on `/` is still blocked:

```
curl -I localhost/?a=<script>alert(42)</script>
```{{execute T1}}

If we make the same request on `/admin`, it will be allowed:
```
curl -I localhost/admin/?a=<script>alert(42)</script>
```{{execute T1}}