Now it's time to check whether everything was set up properly.

Let's simulate an XSS exploitation attempt:
```
curl -I "localhost/?a=<script>alert(42)</script>"
```{{execute T1}}

The request was not blocked.

This is expected: by default, crowdsec configures the CRS in out of band mode.

This means they won't block requests and will only generate events for CrowdSec scenarios.

If we repeat multiple requests matching the CRS, CrowdSec will block our IP.

The CRS are provided in out of band by default, because due to their generic nature, they have a higher chance of false positives and will most likely require some additional configuration on most websites (but they can block a lot more malicious requests).
