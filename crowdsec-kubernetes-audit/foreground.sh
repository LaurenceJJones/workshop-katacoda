#!/bin/sh

echo "Downloading yq"

wget https://github.com/mikefarah/yq/releases/download/v4.45.1/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq

echo "Updating api-server configuration to enable audit logging"


yq -e -i '.spec.volumes += [{"hostPath": {"path": "/etc/kubernetes/manifests/audit-policy.yaml", "type": "File"}, "name": "audit-policy"}]' /etc/kubernetes/manifests/kube-apiserver.yaml
yq -e -i '.spec.containers[0].volumeMounts += [{"mountPath": "/etc/kubernetes/manifests/audit-policy.yaml", "name": "audit-policy", "readOnly": true}]' /etc/kubernetes/manifests/kube-apiserver.yaml

mkdir -p /tmp/k8s-audit
yq -e -i '.spec.volumes += [{"hostPath": {"path": "/tmp/k8s-audit", "type": "DirectoryOrCreate"}, "name": "audit-log"}]' /etc/kubernetes/manifests/kube-apiserver.yaml
yq -e -i '.spec.containers[0].volumeMounts += [{"mountPath": "/var/log/k8s-audit", "name": "audit-log"}]' /etc/kubernetes/manifests/kube-apiserver.yaml

yq -e -i  '.spec.containers[0].command += "--audit-policy-file=/etc/kubernetes/manifests/audit-policy.yaml"' /etc/kubernetes/manifests/kube-apiserver.yaml
yq -e -i  '.spec.containers[0].command += "--audit-log-path=/var/log/k8s-audit/audit.log"' /etc/kubernetes/manifests/kube-apiserver.yaml
yq -e -i  '.spec.containers[0].command += "--audit-log-maxage=30"' /etc/kubernetes/manifests/kube-apiserver.yaml
yq -e -i  '.spec.containers[0].command += "--audit-log-maxbackup=1"' /etc/kubernetes/manifests/kube-apiserver.yaml
yq -e -i  '.spec.containers[0].command += "--audit-log-maxsize=100"' /etc/kubernetes/manifests/kube-apiserver.yaml

while true; do
  echo "Waiting for kube-apiserver to restart"
  kubectl -n kube-system get pods -l component=kube-apiserver 2> /dev/null | grep -q "Running" && break
  sleep 5
done

