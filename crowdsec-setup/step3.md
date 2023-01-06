## Optimizing NGINX bouncer

The default settings that ship with the NGINX bouncer can be used out of the box, however, if you run a medium-large sized website you can improve the performance.

Open `nano /etc/crowdsec/bouncers/crowdsec-nginx-bouncer.conf`{{exec}} and change `MODE=live`{{}} to `MODE=stream`{{}}

>Q:What does this do?
>A:Instead of the bouncer sending a query to LAPI everytime a request is sent to the webserver, it performs a cron on the configured `UPDATE_FREQUENCY=10`{{}} to get all IP's and caches them. The potential downside an attackers may be able to perform requests between crons.

Then we can reload nginx with `nginx -t && nginx -s reload`{{exec}}.