Whilst we have the preview repositories installed we can also install the preview version of the Nginx lua remediation component. This will allow us to block requests using the Nginx lua module.

```
apt install crowdsec-nginx-bouncer-lua
```{{execute T1}}

Once the component has been installed the post installation script will automatically generate a key for the component. However, we will need to configure the `APPSEC_URL`{{}} using the following snippet:

```
echo "APPSEC_URL=http://127.0.0.1:4242/" >> /etc/default/crowdsec
```{{execute T1}}

Lets test the nginx configuration:

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

Lets test our Wordpress rule we implemented earlier:

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

Within the next steps we will be converting the AppSec component to use 