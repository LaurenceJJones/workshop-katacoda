# Step 2: Enable the Crowdsec WAF

We can install traefik using the official helm chart, and the values file provided.

## Show the values file

```bash
cat crowdsec-waf-values.yaml
```{{exec}}

## Upgrade the helm deployment

```bash
helm upgrade crowdsec crowdsec/crowdsec --namespace crowdsec -f module2/crowdsec-values.yaml -f crowdsec-waf-values.yaml
```{{exec}}

## Verify the installation

```bash
kubectl get pods -n crowdsec
```{{exec}}