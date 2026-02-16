# Step 1: Setup the Kubernetes cluster

Before starting, you will need to know about the context of the exercise. You have the following resources to get started:

* Kubernetes cluster
* Helm
* Kubernetes CLI (kubectl)

We can verify that the cluster is up and running by running the following commands:

```bash
kubectl cluster-info
```{{exec}}

```bash
kubectl get nodes
```{{exec}}

## Install Helm repositories needed

```bash
helm repo add crowdsec https://crowdsecurity.github.io/helm-charts
helm repo add traefik https://helm.traefik.io/traefik
helm repo add jetstack https://charts.jetstack.io
helm repo add emberstack https://emberstack.github.io/helm-charts
helm repo update
```{{exec}}

## Install cert-manager and reflector

We use [cert-manager](https://cert-manager.io/docs/) to create the certificates and re-generate them before they expire. Everything is done with a private PKI, so no external communication is required for DNS or HTTP validation.

Cert-manager creates the secrets in the same namespace as the CrowdSec LAPI and agents, but the bouncer is running in the Traefik pod, so it has no access to them – which is a good thing and the whole point of having namespaces. We delegate this problem to the [reflector](https://github.com/emberstack/kubernetes-reflector). It takes care of copying and deleting secrets in the namespaces that require them.

```bash
helm install cert-manager jetstack/cert-manager --create-namespace --namespace cert-manager --set installCRDs=true
```{{exec}}

```bash
helm install reflector emberstack/reflector --create-namespace --namespace reflector
```{{exec}}

When CrowdSec is installed, it asks cert-manager to create three secret objects for LAPI, agent, and the remediation component (bouncer). Each secret contains three files:

* `tls.crt`: The certificate file
* `tls.key`: The private key file
* `ca.crt`: The CA certificate file


Thanks to TLS, all internal communication is encrypted. Agents and bouncers are automatically registered at the first connection and don’t require API keys or passwords to authenticate. Certificates are automatically re-generated before they expire.
