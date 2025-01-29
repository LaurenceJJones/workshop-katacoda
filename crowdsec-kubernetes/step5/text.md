# Step 3: Install the helloworld app

We use this simple app to test the setup. It is a simple web server that returns a "Hello, World!" message with 200 status code.

## Install the helloworld app

```bash
helm install helloworld crowdsec/helloworld --namespace default --set ingress.enabled=true
```{{exec}}

## Verify the installation

```bash
kubectl get pods -n default
```{{exec}}

## Access the app

we can modify `/etc/hosts` to add the hostname of the helloworld app.

```bash
echo "$(getent hosts node01 | awk '{ print $1 }') helloworld.local" | sudo tee -a /etc/hosts
```{{execute T2}}

```bash
curl http://helloworld.local
```{{execute T2}}

You should see a "Hello, World!" message.