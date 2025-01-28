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

## Simulate an attack

To test Crowdsec detection, we can simulate an attack by using nikto:

```bash
nikto -host http://helloworld.local
```{{execute T2}}

## Verify the detection

Now, let’s check crowdsec decisions:

```bash
kubectl -n crowdsec exec -it $(kubectl -n crowdsec get pods -l type=lapi -o jsonpath='{.items[0].metadata.name}') -- cscli decisions list
```{{exec}}

## Check access to the app

```bash
curl http://helloworld.local
```{{execute T2}}

The decision is present, but the attacker can still access the app. This is because we haven’t installed the bouncer yet. We will do that in the next step.


