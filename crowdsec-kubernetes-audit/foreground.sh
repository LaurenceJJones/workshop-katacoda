#!/bin/sh

echo "Updating api-server configuration to enable audit logging"

yq -e -i  '.spec.containers[0].command += "--audit-policy-file=/etc/kubernetes/manifests/audit-policy.yaml"' /etc/kubernetes/manifests/kube-apiserver.yaml
yq -e -i  '.spec.containers[0].command += "--audit-log-path=/var/log/kubernetes/audit.log"' /etc/kubernetes/manifests/kube-apiserver.yaml
yq -e -i  '.spec.containers[0].command += "--audit-log-maxage=30"' /etc/kubernetes/manifests/kube-apiserver.yaml
yq -e -i  '.spec.containers[0].command += "--audit-log-maxbackup=1"' /etc/kubernetes/manifests/kube-apiserver.yaml
yq -e -i  '.spec.containers[0].command += "--audit-log-maxsize=100"' /etc/kubernetes/manifests/kube-apiserver.yaml

echo "Waiting for kube-apiserver to restart"

#kubectl -n kube-system delete pod -l component=kube-apiserver

while true; do
  kubectl -n kube-system get pods -l component=kube-apiserver | grep -q "Running" && break
  sleep 5
done

