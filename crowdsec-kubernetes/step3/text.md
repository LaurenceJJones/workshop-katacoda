# Step 4: Install CrowdSec

We can install CrowdSec using our helm chart, and the values file provided.

## Show the values file

```bash
cat crowdsec-values.yaml
```{{exec}}

In a production system, you’ll want to keep the Online API and pass your enrollment key in the environment. You can do this by setting the `DISABLE_ONLINE_API` environment variable to `false` in the `crowdsec-values.yaml` file.

## Install CrowdSec

```bash
helm install crowdsec crowdsec/crowdsec --create-namespace --namespace crowdsec  -f crowdsec-values.yaml
```{{exec}}

## Verify the installation

```bash
kubectl get pods -n crowdsec
```{{exec}}

## Check the Traefik pod

When the CrowdSec pods are ready, we can also check the Traefik pod to see if it successfully mounted the bouncer certificate:

```bash
kubectl -n traefik get pods
```{{exec}}

## Access the Traefik dashboard

Now the Traefik pod is ready, you can access the Traefik dashboard by clicking on the link below:

{{TRAFFIC_HOST1_8080}}

In the dashboard, you can have a look at the routers. Somethind is not right, because the bouncer plugin has been installed but not configured yet.