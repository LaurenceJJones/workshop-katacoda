# Step 3: Enable audit logging in k8s

We now need to configure the cluster to send its audit logs to crowdsec.

The configuration of the API server has been updated to include an audit policy and the webhook configuration.

The audit policy defines what gets logged and the scenarios provided by the audit collection will require different log levels based on what they need to detect.
You can see the required logs [here](https://app.crowdsec.net/hub/author/crowdsecurity/collections/k8s-audit) in each scenario details.

The policy we use for this workshop is fairly basic. Choosing what to log is dependant on what you want to detect and the load on your cluster:

```bash
cat /root/audit-policy.yaml
```{{exec}}

Finally, the webhook config tells the API server where to send the logs.

```bash
cat /root/audit-webhook.yaml
```{{exec}}

You can find more about auditing in Kubernetes in the [official documentation](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)