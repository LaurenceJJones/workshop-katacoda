# Step 4: Generate an alert

You can check that crowdsec is reading the audit logs properly:
```bash
kubectl -n crowdsec exec -it $(kubectl -n crowdsec get pods -l type=agent -o jsonpath='{.items[0].metadata.name}') -- cscli metrics
```{{exec}}


The scenarios installed by default focus on detecting potentially abnormal actions in the cluster:
 - A new privileged pod has been started
 - A new pod has requested a `HostPath` mount
 - Someone exec'ed into a running pod
 - ...

While each of those actions is not necessarily malicious, it could be an indicator of something unwanted happening in the cluster.

Let's create a privileged pod in our cluster with the `priv-pod.yaml` file:
```bash
cat priv-pod.yaml
```{{exec}}

```bash
kubectl apply -f priv-prod.yaml
```{{exec}}

Now that our privileged pod has been created, we can check crowdsec alerts (you may need to run the command a few times, as kubernetes buffers the audit logs before sending them to crowdsec):

```bash
kubectl -n crowdsec exec -it $(kubectl -n crowdsec get pods -l type=agent -o jsonpath='{.items[0].metadata.name}') -- cscli metrics
```{{exec}}