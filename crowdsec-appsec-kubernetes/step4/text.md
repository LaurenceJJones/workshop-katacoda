# Step 4: Test the setup

We can try to simulate an attack and verify that the attacker is blocked.

## Simulate an attack

To test Crowdsec detection, we can simulate an attack by using a simple http request:

```bash
curl -I http://helloworld.local:8000/.env
```{{exec}}

## Verify the detection

Now, let’s check crowdsec metrics:

```bash
kubectl -n crowdsec exec -it $(kubectl -n crowdsec get pods -l type=lapi -o jsonpath='{.items[0].metadata.name}') -- cscli metrics show appsec
```{{exec}}

## Explanation

What happened in the test that we just performed is:

1. We did a request `http://helloworld.local:8000/.env` which is a known attack vector.
2. Thanks to the remediation component middleware, forwarded the request to the CrowdSec WAF pod.
3. Our CrowdSec WAF pod analyzed the request
4. The request matches the [AppSec rule to detect .env access](https://app.crowdsec.net/hub/author/crowdsecurity/appsec-rules/vpatch-env-access)
5. The Crowdsec WAF pod thus answered with [HTTP 403](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/403) to the remediation component middleware, indicating that the request must be blocked.
6. The Traefik Ingress controller then answered with the default 403 page.