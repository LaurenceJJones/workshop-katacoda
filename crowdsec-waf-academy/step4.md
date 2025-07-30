Now, we can test our setup.

We'll simply try to access our webserver and request a `.env` file:
```
curl localhost/.env
```{{execute T1}}

As you can see, the server returned a 403 error, meaning the request was blocked.

We can also view the alert with `cscli`:

```
cscli alerts list
```{{execute T1}}