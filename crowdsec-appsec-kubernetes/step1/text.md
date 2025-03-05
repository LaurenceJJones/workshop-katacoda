# Step 1: Check the Kubernetes cluster

Before starting, we can check if the Kubernetes cluster is up and running and all the previous module (crowdsec-kubernetes) work is in place.

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

## Check Traefik

```bash
kubectl get pods -n traefik
```{{exec}}

And access the Traefik dashboard by clicking on the link below:

[ACCESS TRAEFIK DASHBOARD]({{TRAFFIC_HOST2_8080}}/dashboard/#)

## Check helloworld app

```bash
curl http://helloworld.local:8000
```{{exec}}

You should see a "Hello, World!" message.


Now that we have verified that the Kubernetes cluster is up and running, we can tackle the interesting part.
