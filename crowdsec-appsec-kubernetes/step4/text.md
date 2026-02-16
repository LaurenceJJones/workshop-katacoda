# Step 4: Test the setup

We can try to simulate an attack and verify that the attacker is blocked.

## Simulate an attack

To test CrowdSec detection, we can simulate an attack with a simple HTTP request:

```bash
curl -I http://helloworld.local:8000/.env
```{{exec}}

## Verify the detection

Now, let's check CrowdSec metrics:

```bash
kubectl -n crowdsec exec -it $(kubectl -n crowdsec get pods -l type=appsec -o jsonpath='{.items[0].metadata.name}') -- cscli metrics
```{{exec}}

## Explanation

What happened in this test is:

1. We sent a request to `http://helloworld.local:8000/.env`, which is a known attack vector.
2. The remediation middleware forwarded the request to the CrowdSec AppSec pod.
3. The CrowdSec AppSec pod analyzed the request.
4. The request matches the [AppSec rule to detect .env access](https://app.crowdsec.net/hub/author/crowdsecurity/appsec-rules/vpatch-env-access)
5. The CrowdSec AppSec pod returned [HTTP 403](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/403) to the remediation middleware, indicating the request must be blocked.
6. The Traefik Ingress controller then answered with the default 403 page.
