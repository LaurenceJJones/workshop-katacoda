# Step 2: Enable the Crowdsec AppSec

We can install traefik using the official helm chart, and the values file provided.

## Show the values file

```bash
cat crowdsec-appsec-values.yaml
```{{exec}}

In this file:

* we enable the AppSec module by setting `appsec.enabled` to `true`.
* we setup the AppSec acquisition so that it can communicate with the remediation component middleware.
* we install the proper AppSec collections to detect attacks, see [the AppSec documentation](https://docs.crowdsec.net/docs/next/appsec/quickstart/traefik#collection-installation) for more information.

## Upgrade the helm deployment

```bash
helm upgrade crowdsec crowdsec/crowdsec --namespace crowdsec -f module2/crowdsec-values.yaml -f crowdsec-appsec-values.yaml
```{{exec}}

## Verify the installation

```bash
kubectl get pods -n crowdsec
```{{exec}}