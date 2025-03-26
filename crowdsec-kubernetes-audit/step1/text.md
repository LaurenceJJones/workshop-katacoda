# Step 1: Check the Kubernetes cluster

Before starting, we can check if the Kubernetes cluster is up and running and all the previous module (crowdsec-kubernetes) work is in place (it takes a few minutes to start).

For the purpose of this workshop, we'll be sending the audit logs to a crowdsec instance running in the cluster itself.
In real life, you'll probably want to run crowdsec outside the cluster it is monitoring for resilience.

We can verify that the cluster is up and running by running the following commands:

```bash
kubectl cluster-info
```{{exec}}

```bash
kubectl get nodes
```{{exec}}

## Check CrowdSec

```bash
kubectl get pods -n crowdsec
```{{exec}}