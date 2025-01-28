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

## Access the Traefik dashboard

You can access the Traefik dashboard by clicking on the link below:

{{TRAFFIC_HOST1_8080}}