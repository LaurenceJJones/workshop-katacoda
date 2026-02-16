# Step 6: Test the setup

We can try to simulate an attack and verify that the attacker is blocked.

## Simulate an attack

To test CrowdSec detection, we can simulate an attack using the bash attack emulator:

```bash
attack-emulator web-scan http://helloworld.local:8000
```{{exec}}

## Verify the detection

Now, let's check CrowdSec decisions:

```bash
kubectl -n crowdsec exec -it $(kubectl -n crowdsec get pods -l type=lapi -o jsonpath='{.items[0].metadata.name}') -- cscli decisions list
```{{exec}}

## Check access to the app again

```bash
curl -I http://helloworld.local:8000
```{{exec}}

The attacker should be blocked, and you should see a 403 Forbidden response.

## Remove the decision

We can remove the decision, and try to access the app again.

```bash
kubectl -n crowdsec exec -it $(kubectl -n crowdsec get pods -l type=lapi -o jsonpath='{.items[0].metadata.name}') -- cscli decisions delete --all
```{{exec}}

## Access the app

```bash
curl -I http://helloworld.local:8000
```{{exec}}

The helloworld app is accessible again.
