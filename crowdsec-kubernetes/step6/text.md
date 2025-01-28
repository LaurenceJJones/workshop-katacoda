# Step 6: Test the setup

We can try to access the helloworld app again, and see if the attacker is blocked.

## Access the app

```bash
curl -I http://helloworld.local
```{{execute T2}}

The attacker should be blocked, and you should see a 403 Forbidden response.

## Remove the decision

We can remove the decision, and try to access the app again.

```bash
kubectl -n crowdsec exec -it $(kubectl -n crowdsec get pods -l type=lapi -o jsonpath='{.items[0].metadata.name}') -- cscli decisions delete --ip{{TRAFFIC_HOST2}}
```{{exec}}

## Access the app

```bash
curl -I http://helloworld.local
```{{execute T2}}

The helloworld app is accessible again.