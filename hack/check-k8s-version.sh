#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo ">>> checking kubernetes master components"
kubectl -n kube-system get pods -l tier=control-plane -ojsonpath='{range .items[*]}{.spec.nodeName}/{.metadata.name}/{.status.phase}: {.spec.containers[0].image}{"\n"}{end}'
echo ">>> checking kubernetes kube-proxy"
kubectl -n kube-system get pods -l k8s-app=kube-proxy -ojsonpath='{range .items[*]}{.spec.nodeName}/{.metadata.name}/{.status.phase}: {.spec.containers[0].image}{"\n"}{end}'
echo ">>> checking nodes"
kubectl get nodes
