# Step 3: Enable audit logging in k8s

We now need to configure the cluster to send its audit logs to crowdsec.

The configuration of the API server has been updated to include an audit policy and the webhook configuration.

The audit policy defines what gets logged.

```bash
cat /root/audit-policy.yaml
```{{exec}}

The webhook config tells the API server where to send the logs.

```bash
cat /root/audit-webhook.yaml
```{{exec}}