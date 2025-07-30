Now, it's time to check if everything was setup properly.

Let's simulate an XSS exploitation attempt:
```
curl -I localhost/?a=<script>alert(42)</script>
```{{execute T1}}

The request was not blocked !

This is expected: by default, crowdsec configures the CRS in out of band mode.

This means that they won't block any request, and will just generate an event for crowdsec scenarios.

If we were to repeat multiple requests matching the CRS, crowdsec would block our IP.

The CRS are provided in out of band by default, because due to their generic nature, they have a higher chance of false positives and will most likely require some additional configuration on most websites (but they can block a lot more malicious requests).