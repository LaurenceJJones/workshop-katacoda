# Step 2: Configure Crowdsec

We'll configure crowdsec [Kubernetes audit logs datasource](https://docs.crowdsec.net/docs/next/log_processor/data_sources/kubernetes_audit) to receive the cluster audit logs over HTTP.

```bash
cat crowdsec-values.yaml
```{{exec}}

The main changes in this files are:
 - Installing the [k8s-audit](https://app.crowdsec.net/hub/author/crowdsecurity/collections/k8s-audit) collection, which contains the log parser and the various detection scenarios.
 - Configure the acquisition to expose a webhook to receive the audit logs.
 - Expose the webhook with a service

The configuration is:

```yaml
source: k8s-audit
listen_addr: 0.0.0.0
listen_port: 9876
webhook_path: /audit/webhook/event
labels:
  type: k8s-audit
```

Crowdsec will expose a HTTP server on port 9876 and will listen for request on the `/audit/webhook/event` path.

## Upgrade the helm deployment

```bash
helm upgrade crowdsec crowdsec/crowdsec --namespace crowdsec -f crowdsec-values.yaml -f crowdsec-values-audit.yaml
```{{exec}}