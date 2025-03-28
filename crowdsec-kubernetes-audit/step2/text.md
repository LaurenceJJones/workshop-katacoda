# Step 2: Review Crowdsec configuration

Crowdsec has been automatically configured to use the [Kubernetes audit logs datasource](https://docs.crowdsec.net/docs/next/log_processor/data_sources/kubernetes_audit) to receive the cluster audit logs over HTTP.

```bash
cat crowdsec-values.yaml
```{{exec}}

The main bits in this files are:
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

We also expose a `NodePort` service:
```yaml
  service:
    type: NodePort
    ports:
      - port: 9876
        targetPort: 9876
        nodePort: 30000
        protocol: TCP
        name: audit-wehbook
```

We are using `NodePort` here to avoid needing to resolve the service FQDN from inside the API server (as it's not possible).
Using `NodePort` allows us to configure the webhook target (in the next step) to `localhost`.