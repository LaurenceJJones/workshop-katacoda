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

We can access the app by using the node01 IP address.


we can modify `/etc/hosts` to add the hostname of the helloworld app.

```bash
echo "$(getent hosts node01 | awk '{ print $1 }') helloworld.local" | sudo tee -a /etc/hosts
```{{exec}}

```bash
curl http://helloworld.local
```{{exec}}

You should see a "Hello, World!" message.