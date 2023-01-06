## Optimizing NGINX bouncer

The default settings that ship with the NGINX bouncer can be used out of the box, however, if you run a medium-large sized website you can improve the performance.

Open `nano /etc/crowdsec/bouncers/crowdsec-nginx-bouncer.conf`{{exec}} and change `MODE=live`{{}} to `MODE=stream`{{}}

>Q:What does this do?

>A:Instead of the bouncer sending a query to LAPI everytime a request is sent to the webserver, it performs a cron on the configured `UPDATE_FREQUENCY=10`{{}} to get all IP's and caches them. The potential downside an attackers may be able to perform requests between crons.

Then we can reload nginx with `nginx -t && nginx -s reload`{{exec}}.

## Configuring HTTP bans

We want to provide a block page to users that have an active decision against them including the word HTTP. If we don't do this the user will see nothing and think the website is not operating correctly, leading to a negative experience.

#### Edit profiles.yaml

We need to have a separate decision that is made that the firewall bouncer does not act upon. In this example we will use "captcha".

```
echo "
name: captcha_remediation
filters:
  - Alert.Remediation == true && Alert.GetScope() == \"Ip\" && Alert.GetScenario() contains \"http\"
decisions:
 - type: captcha
   duration: 4h
on_success: break
---
" > /tmp/profiles.yaml
cat /etc/crowdsec/profiles.yaml >> /tmp/profiles.yaml
mv /tmp/profiles.yaml /etc/crowdsec/profiles.yaml
systemctl restart crowdsec.service
```{{exec}}