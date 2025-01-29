# Step 5: Install the remediation component middleware

Traefik expects a resource of “Middleware” type named “bouncer”, which we will create now.

## Show the values file

```bash
cat bouncer-middleware.yaml
```{{exec}}

We are using crowdsecMode: none, because it works in real-time, but it queries the database for each connection. In production, we recommend stream for any substantial amount of traffic. For all the possible modes see [the plugin’s documentation](https://plugins.traefik.io/plugins/6335346ca4caa9ddeffda116/crowdsec-bouncer-traefik-plugin).

## Install the bouncer middleware

```bash
kubectl apply -f bouncer-middleware.yaml
```{{exec}}

For more information, see [Routing Configuration / Kind: Middleware](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/#kind-middleware).

We can verify that there is no errors in the dashboard.

## Access the Traefik dashboard

{{TRAFFIC_NODE1_8080}}

In the dashboard, you can have a look at the routers. The bouncer plugin is now installed and configured.