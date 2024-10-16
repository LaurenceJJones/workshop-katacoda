Whilst we have the repositories installed we can also install the version of the Nginx lua remediation component. This will allow us to block requests using the Nginx lua module.

```
apt install crowdsec-nginx-bouncer -y
```{{execute T1}}

Once the component has been installed the post installation script will automatically generate a key for the component. However, we will need to configure the `APPSEC_URL`{{}} using the following snippet:

```
echo "APPSEC_URL=http://127.0.0.1:4242/" >> /etc/crowdsec/bouncers/crowdsec-nginx-bouncer.conf
```{{execute T1}}

Let's test the nginx configuration using the following command:

```
sudo nginx -t
```{{execute T1}}

Within the output you should see the following:

```
nginx: [error] [lua] crowdsec.lua:99: init(): APPSEC is enabled on '127.0.0.1:4242'
```{{}}

This means that the component is configured but we need to reload the Nginx service to load the new configuration:

```
sudo nginx -s reload
```{{execute T1}}

Let's test a Laravel debug vulnerability using the following snippet:

```
curl -s -vv http://localhost/ --data "0x[]=123" >/dev/null
```{{execute T1}}

You should see a `403 Forbidden`{{}} response code which means that the request was blocked using community rules.

```{14}
*   Trying 127.0.0.1:80...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 80 (#0)
> POST / HTTP/1.1
> Host: localhost
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 8
> Content-Type: application/x-www-form-urlencoded
> 
} [8 bytes data]
* upload completely sent off: 8 out of 8 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 403 Forbidden
< Server: nginx/1.18.0 (Ubuntu)
< Date: Wed, 17 Jan 2024 17:11:36 GMT
< Content-Type: text/html
< Transfer-Encoding: chunked
< Connection: keep-alive
< cache-control: no-cache
< 
{ [13882 bytes data]
* Connection #0 to host localhost left intact
```{{}}

In the next section we will break down the laravel debug rule and understand how it works.
