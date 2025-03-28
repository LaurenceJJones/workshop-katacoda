# Step 4: Generate an alert

You can check that crowdsec is reading the audit logs properly (as the auditing was just enabled, it may take a few attempts before anything is shown):
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
kubectl apply -f priv-pod.yaml
```{{exec}}

Now that our privileged pod has been created, we can check crowdsec alerts (you may need to run the command a few times, as the pod will take a few seconds to be created and kubernetes buffers the audit logs before sending them to crowdsec):

```bash
kubectl -n crowdsec exec -it $(kubectl -n crowdsec get pods -l type=agent -o jsonpath='{.items[0].metadata.name}') -- cscli alerts list
```{{exec}}

You'll also see other alerts related to the exec commands we just performed.

You can get more details about each alerts with:
```bash
kubectl -n crowdsec exec -it $(kubectl -n crowdsec get pods -l type=agent -o jsonpath='{.items[0].metadata.name}') -- cscli alerts inspect -d <ALERT_ID>
```{{exec}}