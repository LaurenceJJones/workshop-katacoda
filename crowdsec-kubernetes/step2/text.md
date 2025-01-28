# Step 2: Install Traefik Ingress Controller

We can install traefik using the official helm chart, and the values file provided.

## Show the values file

```bash
cat traefik-values.yaml
```{{exec}}

## Install Traefik

```bash
helm install traefik traefik/traefik --create-namespace --namespace traefik -f traefik-values.yaml
```{{exec}}

## Verify the installation

```bash
kubectl get pods -n traefik
```{{exec}}

you will notice that the traefik pod is not ready yet. 

## Describe the pod

```bash
kubectl -n traefik describe pod
```{{exec}}

Since the plugin cannot start without a bouncer certificate, which in turn is created by CrowdSec+Cert-manager, the whole Traefik pod will be on hold waiting for CrowdSec to be installed.